//
//  ServerManager.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/20/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "ServerManager.h"
#import "RESTAPI.h"
#import <Realm/Realm.h>
#import "Question.h"

@interface ServerManager()<RESTAPIDelegate>

@property (strong, nonatomic) NSString *stringURL;
@property (strong, nonatomic) RESTAPI *restApi;
@property (strong, nonatomic) NSArray *receivedData;
@property (strong, nonatomic) NSCharacterSet *set;

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

#pragma mark - HTTP requests

-(void) httpRequestWithUrl:(NSURL *) requestUrl
            withHTTPMethod:(NSString *) requestMethod
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    [request setHTTPMethod:requestMethod];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];
}

-(void) getAllQuestions
{
    self.set = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.stringURL = @"http://85.214.195.89:8080/api/questions/getAll";
    self.stringURL = [self.stringURL stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:self.stringURL];
    [self httpRequestWithUrl:url withHTTPMethod:@"GET"];

}

#pragma mark - PARSE methods

-(void) saveQuestionsToRealm
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



#pragma mark - RESTAPI response

-(RESTAPI *)restApi
{
    if (!_restApi)
    {
        _restApi = [[RESTAPI alloc] init];
    }
    return _restApi;
}



- (void)getReceivedData:(NSMutableData *)data sender:(RESTAPI *)sender
{
    NSError *error = nil;
    self.receivedData =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self saveQuestionsToRealm];
}


@end
