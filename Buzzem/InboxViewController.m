//
//  InboxViewController.m
//  Buzzem
//
//  Created by Sami Shamsan on 2/19/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "InboxViewController.h"
#import "SWRevealViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
@interface InboxViewController ()<UITableViewDelegate,UITableViewDataSource>
{// Define Arrays
    
    NSArray * RemindersOfRecordsNameList;
    NSArray * ActualRemindersOfRecordsNameList;
    NSArray *TimeArray;
    AVAudioPlayer *myplayer;

}
@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SlideMenu];
    self.title=@"Reminders Inbox";
    [self LoadTableArrays];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Load the Array
//============================================================================

-(void)LoadTableArrays
{
    // Featch Data From DataBase (iCloud API) Parse.com :) Amazing Platform
    ActualRemindersOfRecordsNameList = [[NSArray alloc]initWithObjects:
                      @"APDD-TimesApp-WakeUpAlarm-Anew"
                      ,@"APDD-TimesApp-WakeUpAlarm-Creation",
                      @"APDD-TimesApp-WakeUpAlarm-Epic"
                      ,@"APDD-TimesApp-WakeUpAlarm-Lazy"
                      //,@"APDD-TimesApp-WakeUpAlarm-Mystery"
                      ,@"APDD-TimesApp-WakeUpAlarm-Playful"
                      ,@"APDD-TimesApp-WakeUpAlarm-Search"
                      ,@"APDD-TimesApp-SmoothSound-01-MORNING COSMIC VICTORY"
                      ,@"APDD-TimesApp-Bedtime-Fairy Night"
                      ,@"APDD-TimesApp-Bedtime-Magic Night"
                      ,@"APDD-TimesApp-Drinking Reminder"
                      ,@"APDD-TimesApp-Walking Reminder"
                      ,@"APDD-TimesApp-OnTheHour Reminder"
                      ,@"APDD-TimesApp-General-02"
                      ,@"APDD-TimesApp-General-01"
                      
                      , nil];
    
    RemindersOfRecordsNameList = [[NSArray alloc]initWithObjects:
                @"Anew"
                ,@"Creation",
                @"Epic"
                ,@"Lazy"
                //,@"Mystery"
                ,@"PlayFul"
                ,@"Search"
                ,@"MORNING COSMIC VICTORY"
                ,@"Fairy Night"
                ,@"Magic Night"
                ,@"Drinking"
                ,@"Walking"
                ,@"On The Hour"
                ,@"iDea"
                ,@"Ring"
                
                , nil];
    
    TimeArray = [[NSArray alloc]initWithObjects:
                                  @"01:20 Pm"
                                  ,@"03:30 Pm",
                                  @"4:00 Pm"
                                  ,@"07:00 Pm"
                                  //,@"Mystery"
                                  ,@"08:00 Pm"
                                  ,@"09:00 Pm"
                                  ,@"10:00 Pm"
                                  ,@"11:00 Pm"
                                  ,@"12:00 Am"
                                  ,@"1:00 Am"
                                  ,@"02:00 Pm"
                                  ,@"02:30 Pm"
                                  ,@"03:00 Pm"
                                  ,@"07:00 Pm"
                                  
                                  , nil];
    
    
    //======= Appendix
    //1- @"Anew"
    //2- @"Creation",
    //3- @"Epic"
    //4- @"Lazy"
    //5- @"Mystery"
    //6- @"PlayFul"
    //7- @"Search"
    //8- @"MORNING COSMIC VICTORY"
    //9- @"Fairy Night"
    //10-@"Magic Night"
    //11-@"Drinking"
    //12-@"Walking"
    //13-@"On The Hour"
    //14-@"iDea"
    //15-@"Ring"
    
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [RemindersOfRecordsNameList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 129;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *topLabel;
    UIButton *AcceptBtn;

    
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [RemindersOfRecordsNameList objectAtIndex:indexPath.row];
    // Create the label for the top row of text
    //
    topLabel =
    [[UILabel alloc]
     initWithFrame:
     CGRectMake(14,5,170,40)];
    [cell.contentView addSubview:topLabel];
    
    //
    // Configure the properties for the text that are the same on every row
    //
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = [UIColor blackColor];
    topLabel.highlightedTextColor = [UIColor whiteColor];
    topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]+2];
    
    // Create the Button for the bottom right row
    //
    AcceptBtn =
    [[UIButton alloc]
     initWithFrame:
     CGRectMake(14,89,80,40)];
    [cell.contentView addSubview:AcceptBtn];
    
    //
    // Configure the properties for the text that are the same on every row
    //
    AcceptBtn.backgroundColor = [UIColor blueColor];
    AcceptBtn.titleLabel.textColor = [UIColor blueColor];
    [AcceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
    [AcceptBtn addTarget:self action:@selector(AcceptBtn:)forControlEvents:UIControlEventTouchDown];

    
     NSDate *mydate=[NSDate date];
    
    //Create the dateformatter object
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    //Set the required date format
    
    [formatter setDateFormat:@"HH : mm a"];
    
    //Get the string date
    
    NSString* str = [formatter stringFromDate:mydate];
    
    //Display on the console
   

    topLabel.text =str;
    return cell;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [self.mytableView indexPathForSelectedRow];
    [self.mytableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.mytableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    myplayer = [self setupAudioPlayerWithFile:[ActualRemindersOfRecordsNameList objectAtIndex:indexPath.row] type:@"wav"];
    [myplayer play];
    
    
}

-(void)AcceptBtn:(id)sender
{
    UIButton *myBtn = (UIButton *)sender;
    myBtn.hidden=YES;
}


//Play Audio Method
- (AVAudioPlayer *)setupAudioPlayerWithFile:(NSString *)file type:(NSString *)type
{
    // 1
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 2
    NSError *error;
    
    // 3
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    // 4
    if (!audioPlayer) {
        NSLog(@"%@",[error description]);
    }
    
    // 5
    return audioPlayer;
}

@end
