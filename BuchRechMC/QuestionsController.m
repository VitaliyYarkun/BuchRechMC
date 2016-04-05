//
//  QuestionsController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/4/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "QuestionsController.h"
#import "SWRevealViewController.h"

@interface QuestionsController()

@end

@implementation QuestionsController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.menuItem.target = self.revealViewController;
    self.menuItem.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


@end
