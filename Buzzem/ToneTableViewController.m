//
//  ToneTableViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 1/24/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "ToneTableViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
@interface ToneTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    AVAudioPlayer *myplayer;


}
@end

@implementation ToneTableViewController
NSArray * ToneList;
NSArray * ActualToneList;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadToneList];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}


//========================================================================
#pragma mark - Ui table View Section
//============================================================================

-(void)LoadToneList
{
           
    
       ActualToneList = [[NSArray alloc]initWithObjects:
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

    ToneList = [[NSArray alloc]initWithObjects:
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
     return [ToneList count];
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
    
    cell.textLabel.text = [ToneList objectAtIndex:indexPath.row];
    return cell;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [self.mytableView indexPathForSelectedRow];
    [self.mytableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.mytableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellText = [ToneList objectAtIndex:indexPath.row];
    NSString *AcualToneFileName= [ActualToneList objectAtIndex:indexPath.row];
    myplayer = [self setupAudioPlayerWithFile:[ActualToneList objectAtIndex:indexPath.row] type:@"wav"];
    [myplayer play];
        // Set the recorder Activity with No to use the tones instead
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRecordActive"];
    

    NSString *ComingFrom = [[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromData"];
    if([ComingFrom isEqualToString:@"DayReminder"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:cellText forKey:@"DayReminderSelectedToneFileNameData"];

    }
    else if ([ComingFrom isEqualToString:@"Sleep"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:cellText forKey:@"SleepSelectedToneFileNameData"];
        [[NSUserDefaults standardUserDefaults] setObject:AcualToneFileName forKey:@"SleepSelectedToneActualFileNameData"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSleepRecordActive"];


    }
    else if ([ComingFrom isEqualToString:@"WakeUp"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:cellText forKey:@"WakeUpSelectedToneFileNameData"];
        [[NSUserDefaults standardUserDefaults] setObject:AcualToneFileName forKey:@"WakeUpSelectedToneActualFileNameData"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWakeUpRecordActive"];



    }
    else if ([ComingFrom isEqualToString:@"PersonalAlarm"])
    {
    
    //PersonalAlarmSelectedToneFileNameData
        [[NSUserDefaults standardUserDefaults] setObject:cellText forKey:@"PersonalAlarmSelectedToneFileNameData"];
        [[NSUserDefaults standardUserDefaults] setObject:AcualToneFileName forKey:@"PersonalAlarmSelectedToneActualFileNameData"];

        
    }
    /*
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:AcualToneFileName forKey:@"WakeUpSelectedToneFileNameData"];

    }
    */
    
    // Rigster the Display Name
    [[NSUserDefaults standardUserDefaults] setObject:cellText forKey:@"ToneNameData"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ToneNameFlag"];
    
    // RIgister the actual name
    [[NSUserDefaults standardUserDefaults] setObject:AcualToneFileName forKey:@"SelectedToneActualData"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SelectedToneActualFlag"];
    //[];
    //[self BackAndUpdate];
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

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

-(void)BackAndUpdateToWakeUpTone
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"WakeUp" forKey:@"ComingFromData"];

// back and update the table with the new value
     // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"FGAlarmsViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    


}
-(void)BackAndUpdateToSleep
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Sleep" forKey:@"ComingFromData"];

    
    // back and update the table with the new value
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"FGAlarmsViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}
-(void)BackAndUpdateToDayReminder
{
    [[NSUserDefaults standardUserDefaults] setObject:@"DayReminder" forKey:@"ComingFromData"];

    // back and update the table with the new value
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"SGRemindersViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}

- (IBAction)SaveAlarmSound:(id)sender {
   // FGAlarmsViewController *contrller =[[FGAlarmsViewController alloc]init];
    //[contrller LoadText];
    //[self BackAndUpdate];
    NSString *ComingFrom = [[NSUserDefaults standardUserDefaults] objectForKey:@"ComingFromData"];
    NSLog(@"COming From %@",ComingFrom);
    if([ComingFrom isEqualToString:@"FromDayReminder"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FromDayReminder"];
               // [self BackAndUpdateToDayReminder];
    }
    else if ([ComingFrom isEqualToString:@"Sleep"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fromSleep"];
        
        //[self BackAndUpdateToSleep];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FromWakup"];

        //[self BackAndUpdateToWakeUpTone];
    }
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}
@end
