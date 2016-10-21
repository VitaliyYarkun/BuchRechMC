//
//  LoginViewController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 10/21/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerManager.h"

@interface LoginViewController ()

@property (strong, nonatomic) ServerManager *serverManager;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (assign, nonatomic) BOOL access;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.access = false;
    self.serverManager = [ServerManager sharedManager];
    self.serverManager.realm = [RLMRealm defaultRealm];
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (IBAction)loginButtonAction:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incorrect input"
                                                                             message:@"Email or password is incorrect, please try again"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; 
    [alertController addAction:actionOk];
    self.access = [self.serverManager sendLoginRequestWithUserName:self.emailTextField.text withPassword:self.passwordTextField.text];
    
    [self.serverManager getAllQuestions];
    [self.serverManager getAllLectures];
    
    //self.access = false;
    
    if (self.access == true)
        [self performSegueWithIdentifier:@"loginSegue" sender:sender];
    else
        [self presentViewController:alertController animated:YES completion:nil];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
