//
//  LoginViewController.m
//  ParseExample
//
//  Created by Nick Barrowclough on 8/9/13.
//  Copyright (c) 2013 Nicholas Barrowclough. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
 NSInteger NoResponseCounter;
    IBOutlet UIActivityIndicatorView *_activityIndicator;
    NSArray *AcountTypeArray;

}

@end

@implementation LoginViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     
        

    }
    return self;
}
//========================================================================
#pragma mark - Piker View Section

//============================================================================

-(void)viewWillAppear:(BOOL)animated
{

    AcountTypeArray = [[NSArray alloc]initWithObjects:
                       @"Personal"
                       ,@"Business"
                       , nil];
    NSLog(@"the array%@",AcountTypeArray);

}



//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
    return [AcountTypeArray count];
    
}


// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"the array%@",[AcountTypeArray objectAtIndex:row]);
    return [AcountTypeArray objectAtIndex:row];
    
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    
    // Do Nothing , Just to set up the picker view
    
}

- (void)pickerView:(UIPickerView *)ThepickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //[PVFIrstGroup resignFirstResponder];
    
    
    
    
   // NSString *valueStart = [AcountTypeArray objectAtIndex:[PVStart selectedRowInComponent:0]];
    
}

- (void)viewDidLoad
{
    
    self.usernameField.delegate=self;
    self.emailField.delegate=self;
    self.passwordField.delegate=self;
    self.reEnterPasswordField.delegate=self;
    self.loginUsernameField.delegate=self;
    self.loginPasswordField.delegate=self;

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.usernameField)
        [self.usernameField resignFirstResponder];
    if(textField==self.emailField)
        [self.emailField resignFirstResponder];
    if(textField==self.passwordField)
        [self.passwordField resignFirstResponder];
    if(textField==self.reEnterPasswordField)
        [self.reEnterPasswordField resignFirstResponder];
    //
    if(textField==self.usernameField)
        [self.loginUsernameField resignFirstResponder];

    if(textField==self.usernameField)
        [self.loginPasswordField resignFirstResponder];

    return YES;
    
}
- (void)viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    if (user.username != nil) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
    [_usernameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
    [self checkFieldsComplete];
}

- (void) checkFieldsComplete {
    if ([_usernameField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"You need to complete all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch {
    if (![_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooopss!" message:@"Passwords don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [self registerNewUser];
    }
}

- (void) registerNewUser {
    NSLog(@"registering....");
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameField.text;
    newUser.email = _emailField.text;
    newUser.password = _passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Registration success!");
            _loginPasswordField.text = nil;
            _loginUsernameField.text = nil;
            _usernameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        else {
            NSLog(@"There was an error in registration");
        }
    }];
}

- (IBAction)registeredButton:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _loginOverlayView.hidden = NO;
        _SignUpOverlayView.hidden=YES;
    }];
}

- (IBAction)loginButton:(id)sender {
    [PFUser logInWithUsernameInBackground:_loginUsernameField.text password:_loginPasswordField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Login user!");
            _loginPasswordField.text = nil;
            _loginUsernameField.text = nil;
            _usernameField.text = nil;
            _passwordField.text = nil;
            _reEnterPasswordField.text = nil;
            _emailField.text = nil;
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem logging you in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)LoginWithFB:(id)sender {
    // Set permissions required from the facebook user account
    [PFFacebookUtils initializeFacebook];
    
  
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
 
    // Login PFUser using Facebook
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
       [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NoResponseCounter=0;

                
                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        // Store the current user's Facebook ID on the user
                        [[PFUser currentUser] setObject:[result objectForKey:@"email"]
                                                 forKey:@"email"];
                        [[PFUser currentUser] setObject:[result objectForKey:@"name"]
                                                 forKey:@"name"];
                        [[PFUser currentUser] setObject:@NO
                                                 forKey:@"IsAbsent"];
                        [[PFUser currentUser] setObject:[NSNumber numberWithInteger:NoResponseCounter]

                                                 forKey:@"NoReponseCount"];

                        [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                                 forKey:@"fbid"];
                        [[PFUser currentUser] saveInBackground];
                        
                    }
                }];
                
                /*
                //PFObject *CurrentUser = [PFObject objectWithClassName:@"User"];
                if (FBSession.activeSession.isOpen) {
                    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *userdata, NSError *error) {
                        if (!error) {
                            
                            
                            NSString *myname =[userdata objectForKey:@"username"];
                            
                            NSString *myemail =[userdata objectForKey:@"email"];
                            NSString *mypassword =[userdata objectForKey:@"password"];
                           // int *NoResponseCount=0;
                            PFUser *newUser = [PFUser user];
                            newUser.username=myname;
                            newUser.password=mypassword;
                            newUser.email=myemail;
                            
                            
                            //[[PFUser currentUser] setObject:@NO forKey:@"IsAbsent"];

                            [newUser saveInBackground];

                            //self.nameLabel.text = user.name;
                            //self.emailLabel.text = [user objectForKey:@"email"];
                        }
                    }];*/
                    [self performSegueWithIdentifier:@"login" sender:self];
                    NSLog(@"User with facebook signed up and logged in!");
                
                //
               
            } else {
                [self performSegueWithIdentifier:@"login" sender:self];
                NSLog(@"User with facebook logged in!");
            }
            //[self _presentUserDetailsViewControllerAnimated:YES];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (IBAction)back:(id)sender {
    self.SignUpOverlayView.hidden=NO;
    self.loginOverlayView.hidden=YES;
}

/*
- (void)_presentUserDetailsViewControllerAnimated:(BOOL)animated {
    UserDetailsViewController *detailsViewController = [[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detailsViewController animated:animated];
}
 */
//}
@end
