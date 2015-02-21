//
//  LoginViewController.h
//  ParseExample
//
//  Created by Nick Barrowclough on 8/9/13.
//  Copyright (c) 2013 Nicholas Barrowclough. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (weak, nonatomic) IBOutlet UIView *loginOverlayView;
@property (weak, nonatomic) IBOutlet UIView *SignUpOverlayView;
@property (weak, nonatomic) IBOutlet UIPickerView *AcountType;


- (IBAction)registerAction:(id)sender;
- (IBAction)registeredButton:(id)sender;

- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;
- (IBAction)LoginWithFB:(id)sender;

- (IBAction)back:(id)sender;

@end
