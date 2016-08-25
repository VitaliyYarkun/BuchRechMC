//
//  BookViewController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/6/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *bookWebView;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;
@property (assign, nonatomic) NSInteger pdfPageCount;
@property (assign, nonatomic) NSInteger pdfPageHeight;
@property (assign, nonatomic) NSInteger halfScreenHeight;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self selectBook];
    [self selectTitle];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.bookName ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)url);
    self.pdfPageCount = (int)CGPDFDocumentGetNumberOfPages(pdf);
    self.pdfPageHeight = -1;
    self.bookWebView.scrollView.delegate = self;
    
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

#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.pdfPageHeight == -1)
    {
        CGFloat contentHeight = self.bookWebView.scrollView.contentSize.height;
        self.pdfPageHeight = contentHeight / self.pdfPageCount;
        
        self.halfScreenHeight = (self.bookWebView.frame.size.height / 2);
    }
    float verticalContentOffset = self.bookWebView.scrollView.contentOffset.y;
    
    int pageNumber = ceilf((verticalContentOffset + self.halfScreenHeight) / self.pdfPageHeight);
    
    
}







@end
