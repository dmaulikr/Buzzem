//
//  InvitefriendsViewController.h
//  CheckyLand
//
//  Created by Sami Shamsan on 10/31/14.
//  Copyright (c) 2014 com.Sami.CheckyLand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface InvitefriendsViewController : UIViewController<UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate>{
    
    NSArray *FriendsArray;
    NSMutableArray *MutFriendsArray;
    NSMutableArray *CheckersArray;
    NSMutableArray *AlreadyCheckersArray;
    NSMutableArray *DiffrentCheckersArray;
    NSMutableArray *OnlyCheckerIDArray;

    NSMutableArray *selectedFriendsArray;

    NSTimer* HideLabletimer;
    IBOutlet UIActivityIndicatorView *_activityIndicator;
    NSInteger *selectedRow ;
    
    NSMutableArray *tableData;
    NSInteger myInt;
    NSString *name;
    NSString *facebookID;
}

- (IBAction)SwitchTable:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckOnMeAndThem;

@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfChecker;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchTable;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UITableView *friendsTable;
@property (weak, nonatomic) IBOutlet UILabel *lblSuccefulyAdded;
@property (weak, nonatomic) IBOutlet UISwitch *SwitchGroup;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupOnOff;
@property (weak, nonatomic) IBOutlet UIButton *btnAddgroup;

@property (weak, nonatomic) IBOutlet UILabel *lblGroups;
@property (strong,nonatomic) NSMutableArray *filteredCandyArray;
@property IBOutlet UISearchBar *friendsSearchBar;
- (IBAction)AddChecker:(id)sender;
- (IBAction)SwitchGroupMove:(id)sender;

@end
