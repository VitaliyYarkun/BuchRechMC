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
#import "ServerManager.h"

@interface QuestionsController()

@end

@implementation QuestionsController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.menuItem.target = self.revealViewController;
    self.menuItem.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    /*RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *customRealmPath = [documentsDirectory stringByAppendingPathComponent:@"default1.realm"];
    RLMRealm *realm = [RLMRealm realmWithPath:customRealmPath];
    config.path = [[NSBundle mainBundle] pathForResource:@"default1" ofType:@"realm"];
    config.readOnly = YES;
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:nil];
    RLMResults<Question *> *questions = [Question allObjects];*/
    ServerManager *manager = [ServerManager sharedManager];
    [manager getAllQuestions];
}















@end
