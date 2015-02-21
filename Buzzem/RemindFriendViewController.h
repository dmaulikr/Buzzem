//
//  RemindFriendViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 2/17/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimatedGif.h"

@interface RemindFriendViewController : UIViewController
{

    IBOutlet UIImageView *ivOne, *ivTwo, *ivThree, *ivFour, *ivFive;

}
@property (weak, nonatomic) IBOutlet UITextField *txtReminderNote;
@property (nonatomic, strong) IBOutlet UIView *transparentview;
@property (weak, nonatomic) IBOutlet UIButton *btnrecord;

- (IBAction)btnRecord:(id)sender;
- (IBAction)btnTellFriends:(id)sender;

@end
