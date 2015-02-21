//
//  ToneTableViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 1/24/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToneTableViewController : UIViewController
@property (nonatomic,strong)IBOutlet UITableView *mytableView;
- (IBAction)SaveAlarmSound:(id)sender;

@end
