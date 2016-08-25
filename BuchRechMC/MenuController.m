//
//  MenuController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/5/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "MenuController.h"
#import "SWRevealViewController.h"
#import "BookViewController.h"

@interface MenuController ()

@property (strong, nonatomic) BookViewController *bookController;
@property (assign, nonatomic) NSInteger cellTag;

@end

@implementation MenuController {
    NSArray *menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    menu = @[@"GL",@"BF",@"JA",@"BL",@"GV",@"BB"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* identifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.cellTag = cell.tag;
    [self performSegueWithIdentifier:@"BookControllerSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BookControllerSegue"])
    {
        self.bookController = (BookViewController*)segue.destinationViewController;
        self.bookController.cellTag = self.cellTag;
    }
}


@end
