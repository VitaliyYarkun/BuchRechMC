//
//  BookViewController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/6/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *bookWebView;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self selectBook];
    [self selectTitle];
    NSString *path = [[NSBundle mainBundle] pathForResource:self.bookName ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.bookWebView loadRequest:request];
    [self.bookWebView setScalesPageToFit:YES];
}
- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) selectTitle
{
    switch (self.cellTag) {
        case kGL:
            self.titleNavigationItem.title = @"Einführung in das Rechnungswesen";
            break;
        case kBF:
            self.titleNavigationItem.title = @"Buchführung";
            break;
        case kJA:
            self.titleNavigationItem.title = @"Jahresabschluss";
            break;
        case kBL:
            self.titleNavigationItem.title = @"Bilanz";
            break;
        case kGV:
            self.titleNavigationItem.title = @"Gewinn- und Verlustrechnung";
            break;
        case kBB:
            self.titleNavigationItem.title = @"Bilanzpolitik und Bilanzanalyse";
            break;
        default:
            break;
    }
}

-(void) selectBook
{
    switch (self.cellTag) {
        case kGL:
            self.bookName = @"02_TUM WS 2016_17_GL_final_V1_Lsg";
            break;
        case kBF:
            self.bookName = @"03_TUM WS 2016_17_BF_final_V1_Lsg";
            break;
        case kJA:
            self.bookName = @"07_TUM WS 2016_17_JA_[1-3]_final_V1_Lsg";
            break;
        case kBL:
            self.bookName = @"08_TUM WS 2016_17_JA_[4]_final_V1_Lsg";
            break;
        case kGV:
            self.bookName = @"09_TUM WS 2016_17_JA_[5-11]_final_V1_Lsg";
            break;
        case kBB:
            self.bookName = @"10_TUM WS 2016_17_BB_final_V1_Lsg";
            break;
        default:
            break;
    }
}


@end
