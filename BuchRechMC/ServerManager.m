//
//  ServerManager.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/20/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "ServerManager.h"
#import "Question.h"
#import "Lecture.h"
#import "NSURLSession+SynchronousTask.h"
#import <UIKit/UIKit.h>

@interface ServerManager()

@property (strong, nonatomic) NSString *stringURL;
@property (strong, nonatomic) NSArray *receivedData;
@property (strong, nonatomic) NSCharacterSet *set;
@property (assign, nonatomic) RealmDataSaveOption saveOption;


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

#pragma mark - HTTP request methods

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
    self.saveOption = kSaveAllLecturesOption;
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
    [self.realm beginWriteTransaction];
    [self.realm deleteAllObjects];
    [self.realm commitWriteTransaction];
    
    for(NSDictionary *questionDict in self.receivedData)
    {
        Question *question = [[Question alloc] init];
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
        [self.realm beginWriteTransaction];
        [self.realm addObject:question];
        [self.realm commitWriteTransaction];
        
    }
    
}
-(void) saveAllLecturesToRealm
{
    for(NSDictionary *lectureDict in self.receivedData)
    {
        Lecture *lecture = [[Lecture alloc] init];
        lecture.lectureId = [[lectureDict objectForKey:@"id"] integerValue];
        lecture.name = [lectureDict objectForKey:@"name"];
        lecture.startChapter = [[lectureDict objectForKey:@"startChapter"] integerValue];
        lecture.endChapter = [[lectureDict objectForKey:@"endChapter"] integerValue];
        
        [self.realm beginWriteTransaction];
        [self.realm addObject:lecture];
        [self.realm commitWriteTransaction];
        
    }
}



#pragma mark - RESTAPI request
/*
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
    else if (self.saveOption == kSaveAllLecturesOption)
        [self saveAllLecturesToRealm];
}*/

-(void) sendSynchronousRequest:(NSURLRequest *)request
             returningResponse:(__autoreleasing NSURLResponse **)responsePtr
                         error:(__autoreleasing NSError **)errorPtr
{
    NSData *data = [[NSURLSession sharedSession] sendSynchronousDataTaskWithRequest:request returningResponse:responsePtr error:errorPtr];
    NSError *error = nil;
    if (data)
    {
        self.receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (self.saveOption == kSaveAllQuestionsOption)
            [self saveAllQuestionsToRealm];
        else if (self.saveOption == kSaveAllLecturesOption)
            [self saveAllLecturesToRealm];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect to server" delegate:nil cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil ];
        [alertView show];
    }
    

}








@end
