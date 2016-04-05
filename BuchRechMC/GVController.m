//
//  GVController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/5/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "GVController.h"

@interface GVController ()

@end

@implementation GVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"09_TUM WS 2016_17_JA_[5-11]_final_V1_Lsg" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.gvWebView loadRequest:request];
    [self.gvWebView setScalesPageToFit:YES];
}
- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}



@end
