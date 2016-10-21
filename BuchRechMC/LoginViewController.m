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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.serverManager = [ServerManager sharedManager];
    self.serverManager.realm = [RLMRealm defaultRealm];
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (IBAction)loginButtonAction:(UIButton *)sender
{
    [self.serverManager sendLoginRequestWithUserName:self.emailTextField.text withPassword:self.passwordTextField.text];
    [self.serverManager getAllQuestions];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
