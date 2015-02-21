//
//  DetailViewController.h
//  AddressBook
//
//  Created by Gabriel Theodoropoulos on 9/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *dictContactDetails;

@property (nonatomic, weak) IBOutlet UILabel *lblContactName;
@property (nonatomic, weak) IBOutlet UIImageView *imgContactImage;
@property (nonatomic, weak) IBOutlet UITableView *tblContactDetails;

-(IBAction)makeCall:(id)sender;
-(IBAction)sendSMS:(id)sender;

@end
