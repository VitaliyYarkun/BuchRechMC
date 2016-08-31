//
//  BookViewController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/6/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "BookViewController.h"
#import "Lecture.h"
#import "Question.h"
#import "QuestionViewController.h"

@interface BookViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *bookWebView;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) QuestionViewController *questionController;

@property (assign, nonatomic) NSInteger pdfPageCount;
@property (assign, nonatomic) NSInteger pdfPageHeight;
@property (assign, nonatomic) NSInteger halfScreenHeight;
@property (assign, nonatomic) NSInteger questionIndex;
@property (assign, nonatomic) BOOL shouldRecalculate;

@property RLMResults<Question *> *questions;
@property Question *question;

@property (weak, nonatomic) IBOutlet UIView *popupView;


@end

@implementation BookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self selectBook];
    [self selectTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    Lecture *lecture = [[Lecture alloc] init];
    //NSPredicate *lecturePred = [NSPredicate predicateWithFormat:@"name == %@",self.bookName];
    //self.lectureResult = [Lecture objectsWithPredicate:lecturePred];

    RLMResults *lectureResult = [Lecture objectsWhere:@"name BEGINSWITH '05'"];
    lecture = [lectureResult firstObject];
    
    //self.questions = [Question allObjects];
    //self.lectureResult = [Lecture allObjects];
    
    NSPredicate *questionPred = [NSPredicate predicateWithFormat:@"chapter BETWEEN {%d,%d}", lecture.startChapter, lecture.endChapter];
    self.questions = [Question objectsWithPredicate:questionPred];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    [self pageCalculation];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    self.pdfPageHeight = -1;
    self.bookWebView.scrollView.delegate = self;
    self.shouldRecalculate = NO;
    
    [self.bookWebView loadRequest:request];
    [self.bookWebView setScalesPageToFit:YES];
}

-(void) pageCalculation
{
    NSString *path = [[NSBundle mainBundle] pathForResource:self.bookName ofType:NULL];
    self.url =[NSURL fileURLWithPath:path];
  
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)self.url);
    self.pdfPageCount = (int)CGPDFDocumentGetNumberOfPages(pdf);

}
- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    self.shouldRecalculate = YES;
    if ((device.orientation == UIDeviceOrientationLandscapeLeft) || (device.orientation == UIDeviceOrientationLandscapeRight))
        [self pageCalculation];
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
        case kBF1:
            self.titleNavigationItem.title = @"Buchführung (Fallbeispiel 1)";
            break;
        case kBF2:
            self.titleNavigationItem.title = @"Modul Buchführung (BF) Fallbeispiel 2";
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
            self.bookName = @"02_TUM WS 2016_17_GL_final_V1_Lsg.pdf";
            break;
        case kBF:
            self.bookName = @"03_TUM WS 2016_17_BF_final_V1_Lsg.pdf";
            break;
        case kBF1:
            self.bookName = @"05_TUM WS 2016_17_Ü_BF_2_Fallbeispiel 1_Aufgaben_final_V1_Lsg.pdf";
            break;
        case kBF2:
            self.bookName = @"06_TUM WS 2016_17_Ü_BF_3_Fallbeispiel 2_Aufgaben_final_V1_Lsg.pdf";
            break;
        case kJA:
            self.bookName = @"07_TUM WS 2016_17_JA_[1-3]_final_V1_Lsg.pdf";
            break;
        case kBL:
            self.bookName = @"08_TUM WS 2016_17_JA_[4]_final_V1_Lsg.pdf";
            break;
        case kGV:
            self.bookName = @"09_TUM WS 2016_17_JA_[5-11]_final_V1_Lsg.pdf";
            break;
        case kBB:
            self.bookName = @"10_TUM WS 2016_17_BB_final_V1_Lsg.pdf";
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if((self.pdfPageHeight == -1) || self.shouldRecalculate)
    {
        CGFloat contentHeight = self.bookWebView.scrollView.contentSize.height;
        self.pdfPageHeight = contentHeight / self.pdfPageCount;
        
        self.halfScreenHeight = (self.bookWebView.frame.size.height / 2);
        self.shouldRecalculate = NO;
    }
    float verticalContentOffset = self.bookWebView.scrollView.contentOffset.y;
    NSInteger pageNumber = 0;
    if (scrollView.zoomScale == scrollView.minimumZoomScale)
    {
        pageNumber = ceilf((verticalContentOffset + self.halfScreenHeight) / self.pdfPageHeight);
        NSPredicate *currentPageQuestionPred = [NSPredicate predicateWithFormat:@"fromPage <= %d AND toPage >= %d",pageNumber, pageNumber];
        
        RLMResults<Question *> *result = [self.questions objectsWithPredicate:currentPageQuestionPred];
        self.question = [result firstObject];
        self.questionIndex = [self.questions indexOfObject:self.question];
        
        if (self.question)
        {
            self.popupView.hidden = NO;
            [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionTransitionFlipFromBottom) animations:^{
                self.popupView.alpha = 1.0;
            } completion:nil];
        }
        else
        {
            [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCurlDown) animations:^{
                self.popupView.alpha = 0.0;
            } completion:nil];
        }
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BookQuestionControllerSegue"])
    {
        self.questionController = (QuestionViewController *)segue.destinationViewController;
        self.questionController.selectedCell = self.questionIndex;
        self.questionController.allQuestions = self.questions;
    }
}

- (IBAction)goToQuestionAction:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"BookQuestionControllerSegue" sender:self];
}




@end
