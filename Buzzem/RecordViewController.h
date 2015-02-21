//
//  RecordViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 1/20/15.
//  Copyright (c) 2015 com.Appadoodee.Times. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "F3BarGauge.h"
#import <MessageUI/MessageUI.h>
// Always Start With A prayer



@interface RecordViewController : UIViewController<AVAudioRecorderDelegate, MFMailComposeViewControllerDelegate> {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSTimer *levelTimer;
}



@property (nonatomic,strong)IBOutlet UIButton *BtnRecord;
@property (nonatomic,strong)IBOutlet UIButton *BtnUse;

@property (nonatomic,strong)IBOutlet UIButton *btnPlay;

@property (nonatomic,strong)IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIView *btnExit;
@property (weak, nonatomic) IBOutlet F3BarGauge *levelMeter;

- (IBAction)BtnUse:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)StartRecording:(id)sender;
- (IBAction)Back:(id)sender;
@end



