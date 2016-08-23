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

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    Answer *answer = [self.answers objectAtIndex:indexPath.row];
    cell.textLabel.text = answer.content;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    [separatorView setBackgroundColor:[UIColor lightGrayColor]];
    [separatorView setAlpha:0.8f];
    [cell addSubview:separatorView];
    
    
    return cell;
}


@end
