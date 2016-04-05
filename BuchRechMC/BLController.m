//
//  BLController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/5/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "BLController.h"

@interface BLController ()

@end

@implementation BLController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"08_TUM WS 2016_17_JA_[4]_final_V1_Lsg" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.blWebView loadRequest:request];
    [self.blWebView setScalesPageToFit:YES];
}
- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}



@end
