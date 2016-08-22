//
//  ServerManager.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/20/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "ServerManager.h"
#import <Realm/Realm.h>
#import "Question.h"

@interface ServerManager()

@property (strong, nonatomic) NSString *stringURL;
@property (strong, nonatomic) NSArray *receivedData;
@property (strong, nonatomic) NSCharacterSet *set;
@property (assign, nonatomic) RealmDataSaveOption saveOption;
@property (nonatomic, strong) __block NSData *data;


@end

@implementation ServerManager

+(instancetype) sharedManager
{
    static ServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - HTTP requests methods

-(void) httpRequestWithUrl:(NSURL *) requestUrl
            withHTTPMethod:(NSString *) requestMethod
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    [request setHTTPMethod:requestMethod];
    [self sendSynchronousRequest:request returningResponse:nil error:nil];
}

-(void) getAllQuestions
{
    self.saveOption = kSaveAllQuestionsOption;
    self.set = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.stringURL = @"http://85.214.195.89:8080/api/questions/getAll";
    self.stringURL = [self.stringURL stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:self.stringURL];
    [self httpRequestWithUrl:url withHTTPMethod:@"GET"];

}

-(void) getAllLectures
{
    self.set = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.stringURL = @"http://85.214.195.89:8080/api/lectures/getAll";
    self.stringURL = [self.stringURL stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:self.stringURL];
    [self httpRequestWithUrl:url withHTTPMethod:@"GET"];
}

-(void) getAllTopics
{
    self.saveOption = kSaveAllTopicsOption;
    self.set = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.stringURL = @"http://85.214.195.89:8080/api/topics/getAllTopics";
    self.stringURL = [self.stringURL stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:self.stringURL];
    [self httpRequestWithUrl:url withHTTPMethod:@"GET"];
}

#pragma mark - PARSE and SAVE to Realm

-(void) saveAllQuestionsToRealm
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    
    for(NSDictionary *questionDict in self.receivedData)
    {
        Question* question = [[Question alloc] init];
        question.bookingEntry = [[questionDict objectForKey:@"bookingEntry"] integerValue];
        question.chapter = [[questionDict objectForKey:@"chapter"] integerValue];
        question.content = [questionDict objectForKey:@"content"];
        question.correctAnswerId = [[questionDict objectForKey:@"correctAnswerId"] integerValue];
        question.fromPage = [[questionDict objectForKey:@"fromPage"] integerValue];
        question.toPage = [[questionDict objectForKey:@"toPage"] integerValue];
        question.hint = [questionDict objectForKey:@"hint"];
        question.generalId = [[questionDict objectForKey:@"id"] integerValue];
        
        for (NSDictionary * possibleAnswersDict in [questionDict objectForKey:@"possibleAnswers"])
        {
            Answer *answer = [[Answer alloc]  init];
            answer.content = [possibleAnswersDict objectForKey:@"answer"];
            answer.answerId = [[possibleAnswersDict objectForKey:@"answerId"] integerValue];
            answer.generalId = [[possibleAnswersDict objectForKey:@"id"] integerValue];
            [question.possibleAnswers addObject:answer];
        }
        [realm beginWriteTransaction];
        [realm addObject:question];
        [realm commitWriteTransaction];
        
    }
    
}



#pragma mark - RESTAPI request

-(void)sendSynchronousRequest:(NSURLRequest *)request
            returningResponse:(__autoreleasing NSURLResponse **)responsePtr
                        error:(__autoreleasing NSError **)errorPtr {
    dispatch_semaphore_t    sem;
    sem = dispatch_semaphore_create(0);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         if (errorPtr != NULL) {
                                             *errorPtr = error;
                                         }
                                         if (responsePtr != NULL) {
                                             *responsePtr = response;
                                         }
                                         if (error == nil) {
                                             self.data = data;
                                         }
                                         dispatch_semaphore_signal(sem);
                                     }] resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    NSError *error = nil;
    self.receivedData =[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&error];
    if (self.saveOption == kSaveAllQuestionsOption)
        [self saveAllQuestionsToRealm];
}





@end
