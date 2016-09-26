//
//  QuestionsController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/4/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//
#import "QuestionsController.h"
#import "SWRevealViewController.h"
#import "Question.h"
#import "QuestionCustomCell.h"
#import "QuestionViewController.h"

@interface QuestionsController()

@property (strong, nonatomic) QuestionViewController *questionController;

@property RLMResults<Question *> *allQuestions;

@property (assign, nonatomic) NSInteger selectedCell;

@end

@implementation QuestionsController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelection = YES;
    self.menuItem.target = self.revealViewController;
    self.menuItem.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.tableView registerNib:[ UINib nibWithNibName:NSStringFromClass([QuestionCustomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuestionCustomCell class ])];
    [self.tableView reloadData];
    self.allQuestions = [Question allObjects];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allQuestions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionCustomCell class]) forIndexPath:indexPath];
    
    Question *question = [self.allQuestions objectAtIndex:indexPath.row];
    
    cell.tag = indexPath.row;
    cell.content.text = question.content;
    cell.content.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedCell = cell.tag;
    [self performSegueWithIdentifier:@"QuestionControllerSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"QuestionControllerSegue"])
    {
        self.questionController = (QuestionViewController *)segue.destinationViewController;
        self.questionController.selectedCell = self.selectedCell;
        self.questionController.allQuestions = self.allQuestions;
    }
}














@end
