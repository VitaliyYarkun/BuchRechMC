//
//  QuestionViewController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/22/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController ()

@property RLMArray <Answer *><Answer> *answers;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger questionIndex;
@property (strong, nonatomic) Question *question;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionIndex = self.selectedCell;
    self.question = [self.allQuestions objectAtIndex:self.questionIndex];
    self.questionTextView.text = self.question.content;
    self.answers = self.question.possibleAnswers;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.answers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    Answer *answer = [self.answers objectAtIndex:indexPath.row];
    cell.textLabel.text = answer.content;
    cell.tag = answer.answerId;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    [separatorView setBackgroundColor:[UIColor lightGrayColor]];
    [separatorView setAlpha:0.8f];
    [cell addSubview:separatorView];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell.tag == self.question.correctAnswerId){
        [cell setBackgroundColor:[UIColor greenColor]];
        tableView.allowsSelection = NO;
    }
    else {
        [cell setBackgroundColor:[UIColor redColor]];
    }

}

- (IBAction)nextQuestionAction:(UIBarButtonItem *)sender
{
    self.questionIndex++;
    if (self.questionIndex < [self.allQuestions count]) {
        self.tableView.allowsSelection = YES;
        self.question = [self.allQuestions objectAtIndex:self.questionIndex];
        self.questionTextView.text = self.question.content;
        self.answers = self.question.possibleAnswers;
        NSArray *rowsToReload = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],
                                 [NSIndexPath indexPathForRow:1 inSection:0],
                                 [NSIndexPath indexPathForRow:2 inSection:0],
                                 [NSIndexPath indexPathForRow:3 inSection:0], nil];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }
    else
        self.questionIndex = [self.allQuestions count];
    
}
- (IBAction)previousQuestionAction:(UIBarButtonItem *)sender
{
    self.questionIndex--;
    if ((self.questionIndex < [self.allQuestions count]) && (self.questionIndex >= 0)) {
        self.tableView.allowsSelection = YES;
        self.question = [self.allQuestions objectAtIndex:self.questionIndex];
        self.questionTextView.text = self.question.content;
        self.answers = self.question.possibleAnswers;
        NSArray *rowsToReload = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],
                                 [NSIndexPath indexPathForRow:1 inSection:0],
                                 [NSIndexPath indexPathForRow:2 inSection:0],
                                 [NSIndexPath indexPathForRow:3 inSection:0], nil];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
    }
    else
        self.questionIndex = 0;
}
@end
