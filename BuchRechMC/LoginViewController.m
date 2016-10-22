//
//  LoginViewController.m
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 10/21/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerManager.h"
#import "Question.h"                // Used to check if server connection is successful

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
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
    
    [self.serverManager sendLoginRequestWithUserName:self.emailTextField.text withPassword:self.passwordTextField.text];
    [self.serverManager getAllQuestions];
    [self.serverManager getAllLectures];
    
    if ([Question allObjects].count > 0)        // Used to check if server connection is successful
        self.access = true;                     // Used to check if server connection is successful
    else                                        // Used to check if server connection is successful
        self.access = false;                    // Used to check if server connection is successful
    
    if (self.access == true)
        [self performSegueWithIdentifier:@"loginSegue" sender:sender];
    else
        [self presentViewController:alertController animated:YES completion:nil];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)dismissKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
