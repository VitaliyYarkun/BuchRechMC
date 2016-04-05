//
//  GLController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/5/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "GLController.h"

@interface GLController ()

@end

@implementation GLController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"02_TUM WS 2016_17_GL_final_V1_Lsg" ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.glWebView loadRequest:request];
    [self.glWebView setScalesPageToFit:YES];
}

- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


@end
