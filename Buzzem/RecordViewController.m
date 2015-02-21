//
//  RecordViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 1/20/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "RecordViewController.h"
#import "MyDocument.h"
#import <AudioToolbox/AudioServices.h>

#define kdBOffset       40
#define kMeterRefresh   0.03
@interface RecordViewController ()
{
    NSString *WhatPage;
    NSString *RecordFor;
    NSURL *WakeUpUrl;
    NSURL *SleepurlUrl;
    NSURL *DayReminderurl;
    NSURL *RestOfHoursUrl;
    NSURL *SleepWorkGabUrl;
}
@end
/*
 General Information
 Here are the results for few encoding supported by iPhone. Size of audio file in KB of duration 10 sec.
 
 kAudioFormatMPEG4AAC : 164,
 
 kAudioFormatAppleLossless : 430,
 
 kAudioFormatAppleIMA4 : 475,
 
 kAudioFormatULaw : 889,
 
 kAudioFormatALaw : 889,
 
 Among these kAudioFormatMPEG4AAC is having smallest size.
 
 */
@implementation RecordViewController
@synthesize levelMeter,lblMessage;

- (void)viewDidLoad
{
    [super viewDidLoad];

    WhatPage = [[NSUserDefaults standardUserDefaults] objectForKey:@"WhatPage"];
    RecordFor = [[NSUserDefaults standardUserDefaults] objectForKey:@"RecordFor"];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
 
   // [self CheckWhichAlaramWeHave];
    [self ArrangRecordingSession];
    [self LoadTheGestureSwipType];
    
  //Setup The button Round and Border width
   
}
-(void)ArrangRecordingSession
{


    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if (err) { /* handle error */ }
    
    err = nil;
    
    [audioSession setActive:YES error:&err];
    
    if (err) { /* handle error */ }
   // NSURL *url;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                              [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt:1], AVNumberOfChannelsKey, nil];
   
            
            WakeUpUrl  = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"MessageRecord.m4a"]];
            
            recorder = [[AVAudioRecorder alloc] initWithURL:WakeUpUrl
                                                   settings:settings error:&err];
    
    if (!recorder) { /* handle error */ }
    
    [recorder setDelegate:self];

}
- (void)viewDidUnload
{
    [self setLevelMeter:nil];
    [super viewDidUnload];
        // Release any retained subviews of the main view.
}


-(void)ChangeButtonsBackgrounds
{
    [self.BtnRecord setImage:[UIImage imageNamed:@"RecordNow.png"] forState:UIControlStateNormal];
    [self.BtnRecord setImage:[UIImage imageNamed:@"StopRecord.png"] forState:UIControlStateHighlighted];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//========================================================================
#pragma mark - Record System
//============================================================================
-(void)PlayWithUrl:(NSString *)recordName
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:recordName];
    
    NSURL *myUrl = [NSURL fileURLWithPath:filePath];
    lblMessage.text=@"Now Playing";
    
    NSError *error;
    NSLog(@"url is %@",myUrl);
    if (myUrl) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:myUrl error:&error];
        [player play];
   
    }
    else
    {
       UIAlertView  *Alert = [[UIAlertView alloc] initWithTitle:@"Record!" message:@"Please Add Record to this Section" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [Alert show];

    
    }
    

}


- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    levelMeter.value = ([recorder averagePowerForChannel:0]+kdBOffset)/kdBOffset;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Swipe Gesture with the whole four direction


-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}
-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}

-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    
}
-(void)LoadTheGestureSwipType
{
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    
}


//========================================================================
#pragma mark - UIAction
//============================================================================
- (IBAction)play:(id)sender {
   
    
            [self PlayWithUrl:@"MessageRecord.m4a"];
 
}

- (IBAction)StartRecording:(id)sender {
    if(![sender isSelected]){
        // If its recording
        levelMeter.hidden=NO;
        //[self.BtnRecord setImage:[UIImage imageNamed:@"StopRecord.png"] forState:UIControlStateHighlighted];
        
        lblMessage.text=@"Rocording...";
        
        [recorder pause];
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        [recorder updateMeters];
        levelTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0] interval:kMeterRefresh target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:levelTimer forMode:NSDefaultRunLoopMode];
        
        [sender setSelected:YES];

        
    }
   else
        
    {
        //Stop recording
        levelMeter.hidden=YES;
        self.btnPlay.hidden=NO;
        [recorder stop];
        [levelTimer invalidate];
        lblMessage.text=@"Done";
       
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasRecord"];
            
        
            
        
        [sender setSelected:NO];

    }
}
- (IBAction)BtnUse:(id)sender {
    // Go Public with the the notification Scoop
    
    
                [[NSUserDefaults standardUserDefaults] setObject:@"MessageRecord.m4a" forKey:@"RecordFileName"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRecordActive"];
                //Play the record after you set it up
                //[self PlayWithUrl:@"MessageRecord.m4a"];
        // Save to the iclloud to table Notification : Sound (audio file .m4a),AlertBody (Nsstring TxtreminderNote),FireDate (Nsdate =uidatepicker.date),
                [self exit:@"SWRevealViewController"];
    
}
    
    
    

-(void)exit:(NSString *)viewCOntroller
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:viewCOntroller];
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)Back:(id)sender {
    
    
        [self exit:@"SWRevealViewController"];

       
    
  
}

@end
