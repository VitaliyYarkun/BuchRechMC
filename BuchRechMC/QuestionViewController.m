//
//  QuestionViewController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/22/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController ()

@property Question *question;
@property RLMArray <Answer *><Answer> *answers;

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger questionIndex;
@property (strong, nonatomic) NSMutableArray *cellsArray;

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.questionIndex = self.selectedCell;
    self.question = [self.allQuestions objectAtIndex:self.questionIndex];
    self.questionTextView.text = self.question.content;
    self.answers = self.question.possibleAnswers;
    self.cellsArray = [[NSMutableArray alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    [self.cellsArray addObject:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.allowsSelection = NO;
    UITableViewCell *chosenCell = [tableView cellForRowAtIndexPath:indexPath];
    [chosenCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (chosenCell.tag == self.question.correctAnswerId)
        [chosenCell setBackgroundColor:[UIColor greenColor]];
    else
    {
        [chosenCell setBackgroundColor:[UIColor redColor]];
        UITableView *correctCell = [self.cellsArray objectAtIndex:self.question.correctAnswerId];
        [correctCell setBackgroundColor:[UIColor greenColor]];
    }

}

- (IBAction)nextQuestionAction:(UIBarButtonItem *)sender
{
    [self.cellsArray removeAllObjects];
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
    [self.cellsArray removeAllObjects];

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
