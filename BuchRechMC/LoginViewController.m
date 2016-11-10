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
#import "User.h"

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
- (BOOL) connectedToInternet
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
    return ( URLString != NULL ) ? YES : NO;
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
    
    if ([self connectedToInternet]) {
        if ([Question allObjects].count > 0) {       // Used to check if server connection is successful
            self.access = true;
            RLMResults<User *> *users = [User allObjects];
            for(User *user in users)
            {
                [self.serverManager.realm deleteObject:user];
            }
            User *user = [[User alloc] init];
            user.name = self.serverManager.name;
            user.password = self.serverManager.password;
            [self.serverManager.realm beginWriteTransaction];
            [self.serverManager.realm addObject:user];
            [self.serverManager.realm commitWriteTransaction];
        }
    }
    else {
        RLMResults<User *> *users = [User allObjects];
        User *user = [users firstObject];
        if ([self.serverManager.name isEqualToString:user.name] && [self.serverManager.password isEqualToString:user.password])
        {
            if ([Question allObjects].count > 0) {       // Used to check if server connection is successful
                self.access = true;
            }                                           // Used to check if server connection is successful
            else                                        // Used to check if server connection is successful
                self.access = false;                    // Used to check if server connection is successful
        }
        else{
            self.access = false;
        }
        
    }
    
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
