//
//  QuestionsController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/4/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "QuestionsController.h"
#import "SWRevealViewController.h"
#import <Realm/Realm.h>
#import "Question.h"
#import "RESTAPI.h"

@interface QuestionsController() <RESTAPIDelegate>

@property (strong, nonatomic) NSURL *fileURL;
@property (strong, nonatomic) RESTAPI *restApi;
@property (strong, nonatomic) NSDictionary *receivedData;
@property (strong, nonatomic) NSCharacterSet *set;


@end

@implementation QuestionsController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.menuItem.target = self.revealViewController;
    self.menuItem.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.set = [NSCharacterSet URLQueryAllowedCharacterSet];
    /*RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *customRealmPath = [documentsDirectory stringByAppendingPathComponent:@"default1.realm"];
    RLMRealm *realm = [RLMRealm realmWithPath:customRealmPath];
    config.path = [[NSBundle mainBundle] pathForResource:@"default1" ofType:@"realm"];
    config.readOnly = YES;
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:nil];
    RLMResults<Question *> *questions = [Question allObjects];*/
    [self questionsRequest];
    
}

- (void)questionsRequest
{
    NSString* urlString;
    urlString = @"http://85.214.195.89:8080/api/questions/getAll";
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:self.set];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    self.restApi.delegate = self;
    [self.restApi httpRequest:request];    
}


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
    
}
























@end
