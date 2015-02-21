//
//  RemindFriendViewController.m
//  Buzzem
//
//  Created by Sami Shamsan on 2/17/15.
//  Copyright (c) 2015 com.Sami.Buzzem. All rights reserved.
//

#import "RemindFriendViewController.h"
#import "SWRevealViewController.h"
#import "RecordViewController.h"
#import "UIImageView+AnimatedGif.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface RemindFriendViewController ()<UITextFieldDelegate>
{
    NSMutableArray *friendsArray;
    NSTimer *DoneTimer;

    UIView *popup;
}
@end

@implementation RemindFriendViewController
@synthesize txtReminderNote;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SlideMenu];
    [self BuzzEm];
    txtReminderNote.delegate=self;
    self.transparentview.hidden=YES;
    self.btnrecord.hidden=NO;

    [self LoadTableViewData];
self.title=@"Remind Friends";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
        [txtReminderNote resignFirstResponder];
    
    return YES;
    
}


//========================================================================
#pragma mark - Slide Menue component
//============================================================================

-(void)SlideMenu
{
    UIImage* image3 = [UIImage imageNamed:@"SliderIconWhite.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self.revealViewController  action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *slidebutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem=slidebutton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}
//========================================================================
#pragma mark - Buzz Button
//============================================================================
-(void)BuzzEm
{
    
    UIImage* image3 = [UIImage imageNamed:@"Buzzy.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self  action:@selector(Buzz:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *HomeButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=HomeButton;
    
    
}
- (void)Buzz:(UIBarButtonItem *)sender{
    
   // Show UiView With animation
    // Message is : Buzz Sent Succefuly
    //with check animation
    self.transparentview.hidden=NO;
    self.btnrecord.hidden=YES;
    DoneTimer= [NSTimer scheduledTimerWithTimeInterval:3
                                                     target: self
                                                   selector: @selector(enableTransparentview)
                                                   userInfo: nil
                                                    repeats: YES];
}
//========================================================================
#pragma mark - Save To Batabase (iCloud API) Parse.com
//============================================================================

// Save The Data 


//========================================================================
#pragma mark - Enable/Disable Views
//============================================================================
-(void)enableTransparentview
{

        [self performSelectorOnMainThread:@selector(stopDoneTimer) withObject:nil waitUntilDone:YES];
        
        
        
    
    
}

- (void) stopDoneTimer
{
    // [secondBeep stop];
    
    [DoneTimer invalidate];
    DoneTimer = nil;
    self.transparentview.hidden=YES;
    self.btnrecord.hidden=NO;

    
}

-(void)LoadTableViewData
{
    
    
    /*
    NSString *ReminderTime;
    NSString * ReminderText;
    NSString *ToneName;
    BOOL *isRecordActive;
    NSString *FriendNumber;
    */
    friendsArray = [[NSMutableArray alloc]init];
    [friendsArray addObject:@"Add Friends"];
    
    if([friendsArray count]<2)
        [friendsArray addObject:@"No Friends Yet"];
    
    
}


//========================================================================
#pragma mark - Ui table View Section
//============================================================================


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [friendsArray objectAtIndex:indexPath.row];
    
    
    UIImage *originalImage =[UIImage imageNamed:@"group-32 (1)"];
    
    // Resize the image
    /*
     CGSize cellViewSize = CGSizeMake(46.0, 46.0);
     CGRect cellViewRect = [WLImageStore rectForImage:originalImage withSize:cellViewSize];
     UIGraphicsBeginImageContext(cellViewSize);
     [originalImage drawInRect:cellViewRect];
     UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
     */
    [[cell imageView] setImage:originalImage];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"Contact"];
        
        [self presentViewController:vc animated:YES completion:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"SecondGroup" forKey:@"WhatPage"];
        //[[NSUserDefaults standardUserDefaults] setObject:@"Day" forKey:@"ReminderFor"];
        
    }
    else
    {
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"RemindersTableViewController"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)btnRecord:(id)sender {
    RecordViewController *VoiceRecordView=[[RecordViewController alloc]init ];
    
    VoiceRecordView.view.frame=self.view.bounds;
    [self.view addSubview:VoiceRecordView.view];
    [self addChildViewController:VoiceRecordView];

}

- (IBAction)btnTellFriends:(id)sender {
    
    
    
}
@end
