//
//  BBController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/5/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "BBController.h"

@interface BBController ()

@end

@implementation BBController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"10_TUM WS 2016_17_BB_final_V1_Lsg" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.bbWebView loadRequest:request];
    [self.bbWebView setScalesPageToFit:YES];
}

- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


@end
