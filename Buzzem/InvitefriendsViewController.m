//
//  InvitefriendsViewController.m
//  CheckyLand
//
//  Created by Sami Shamsan on 10/31/14.
//  Copyright (c) 2014 com.Sami.CheckyLand. All rights reserved.
//

#import "InvitefriendsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ParseExampleCell.h"
#import "FriendsDataObject.h"

@interface InvitefriendsViewController ()
@end

@implementation InvitefriendsViewController
@synthesize headerImageView;
@synthesize lblUserName;
@synthesize SwitchTable;
@synthesize friendsTable;
@synthesize lblCheckOnMeAndThem;

@synthesize lblNumberOfChecker;
@synthesize filteredCandyArray;
//@synthesize friendsSearchBar;
@synthesize lblSuccefulyAdded;
@synthesize SwitchGroup;
@synthesize lblGroupOnOff;
@synthesize lblGroups;
@synthesize btnAddgroup;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
               // Custom initialization
    }
    return self;
}
//*********************************************************

//get all data from Facebook Friends
- (void)startCalculationForAllFriends{
 //   NSLog(@"Start calculating ...");
    NSString *query = [NSString stringWithFormat:
                       @"{"
                       @"'all_friends':'SELECT first_name, last_name, uid, pic, sex, relationship_status FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())',"
                       @"'users_family':'SELECT uid FROM family WHERE profile_id = me()',"
                    
                       @"}"];

    // Set up the query parameter
    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
 
                              if (error) {
                                  NSLog(@"There was an error");
                              } else {
                                 
                                  FriendsArray = [result objectForKey:@"data"];
                                  
                                  NSLog(@"array: %@", FriendsArray);
                                [self processFBData:[result objectForKey:@"data"]];

                    
                                  
                                  /*
                                
                                  NSMutableSet* lookup = [NSMutableSet setWithArray:AlreadyCheckersArray];

                                 // DiffrentCheckersArray = [NSMutableArray array];
                                  for (NSObject* friend in FriendsArray) {
                                      NSString* friendID = [friend ];
                                      if (![lookup member:friendID]) {
                                          [DiffrentCheckersArray addObject:friend];
                                      }
                                  }
                                  */

                                  NSData* myJsonData = [NSJSONSerialization dataWithJSONObject:DiffrentCheckersArray
                                                           options:NSJSONWritingPrettyPrinted error:&error];
                                 // NSLog(@"array: %@", FriendsArray);

                                  
                                  [self setupFriendsFromJSONArray:myJsonData];
                                  [friendsTable reloadData];

                                  
                              }
                              [friendsTable reloadData];

                          }];
}
-(void)SaveFacebookFriendsAsUSer{
    PFUser *user;
    if (user.isNew) {
        
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
            [[PFUser currentUser] setObject:0
             
                                     forKey:@"NoReponseCount"];
            
            [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                     forKey:@"fbid"];
            [[PFUser currentUser] saveInBackground];
            
            
            
        }
    }];
    [self performSegueWithIdentifier:@"login" sender:self];
    NSLog(@"User with facebook signed up and logged in!");
    
    //
    
}
}
- (void)processFBData:(NSArray *)jsonData {
    
    
   // NSArray *friends = [[jsonData objectAtIndex:0] objectForKey:@"fql_result_set"];
   // NSLog(@"the frind now is %@",self.FriendsArray);
    for (NSDictionary *jsonDict in jsonData) {
        NSString *jsonpart = [jsonDict objectForKey:@"name"];
        NSArray *userIDArray = [jsonDict objectForKey:@"fql_result_set"];
        
        if ([jsonpart isEqualToString:@"users_family"]) {
            //NSLog(@"Family Members: %d", [userIDArray count]);
            //[self.currentUser setNumberFamilyMembers:[NSNumber numberWithInt:[userIDArray count]]];
            
            [self filterForFamilyMembers:userIDArray];
        }
     
    }
    
   // [self.friendsTable reloadData];
}


- (void)filterForFamilyMembers:(NSArray *)familyMembers{
   
    for (NSDictionary *uidDict in familyMembers) {
        NSString *uid = [[uidDict allValues] objectAtIndex:0];
             
    
    }
}

-(void)setupFriendsFromJSONArray:(NSData*)dataFromServerArray{
    NSError *error;
    MutFriendsArray = [[NSMutableArray alloc] init];
   
   
     NSArray *arrayFromServe= [NSJSONSerialization JSONObjectWithData:dataFromServerArray  options:NSJSONReadingMutableContainers error:&error];
    
    if(error){
        NSLog(@"error parsing the json data from server with error description - %@", [error localizedDescription]);
    }
    else {
       
        
        MutFriendsArray = [[NSMutableArray alloc] init];
        
        
        
        
        
        for(NSDictionary *eachFriend in arrayFromServe)
        {
            
            FriendsDataObject *friend = [[FriendsDataObject alloc] initWithJSONData:eachFriend];
            [MutFriendsArray addObject:friend];
        }
        for (NSString *str in MutFriendsArray) {
            if (MutFriendsArray.count>0) {
                [OnlyCheckerIDArray addObject:[MutFriendsArray objectAtIndex:0]];
            }
        }
        [self queryfromCheky];
        DiffrentCheckersArray = [[NSMutableArray alloc] init];
        for(int i = 0 ; i < [FriendsArray count]; i++) {
            if(i <= [AlreadyCheckersArray count]){
                if(![AlreadyCheckersArray[i] isEqual:[FriendsArray[i] objectForKey:@"id"]]){
                    [DiffrentCheckersArray addObject:FriendsArray[i]];
                }
                else
                {
                    DiffrentCheckersArray=[MutFriendsArray copy];
                }
                
            
            }
        }

        //NSLog(@"Friends Array from inside : %@", MutFriendsArray.count);

        //Now you have your placesArray filled up with all your data objects
    }
}


-(void)queryfromCheky
{
    PFQuery *query = [PFQuery queryWithClassName:@"Checky"];
    [query selectKeys:@[@"CheckedBy"]];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
         
                

                
                for ( PFObject *OB in objects )
                {
                   
                    [AlreadyCheckersArray addObject:[OB objectForKey:@"CheckedBy"]];
                    

                }
            }
            
            // The find succeeded. The first 100 objects are available in objects
        
    }];
    [friendsTable reloadData];
   // NSLog(@"%@",AlreadyCheckersArray);

}
// Call The Last Method Example
-(void)connectionWasASuccess:(NSData *)data{
    [self setupFriendsFromJSONArray:data];
}
//*********************************************************
//UITable Fill up
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MutFriendsArray.count;
    
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    

    static NSString *CellIdentifier = @"myCell";
    ParseExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    
    // [self startCalculationForAllFriends];
  //  NSLog(@"Friends Array from inside : %@", FriendsArray);
    if([MutFriendsArray count] == 0){
        cell.cellTitle.text = @"no friends  to show";
        //cell.LikeBtn.hidden=YES;
        
    }
   

    else
    {
        
        
        FriendsDataObject *currentFriend = [MutFriendsArray objectAtIndex:indexPath.row];
        //[selectedFriendsArray addObject:[currentFriend friendIDS]];

       // NSLog(@"array already cher %@",AlreadyCheckersArray);
       
       
         // [mypfobject objectForKey:@"title"];
          // NSString *AlreadyCheckerText = [mypfobject objectForKey:@"CheckedBy"];
          // NSLog(@"already cheker array %@",AlreadyCheckersArray);

        // NSString *curentfriend =[currentFriend friendIDS];
           if ([AlreadyCheckersArray containsObject:[currentFriend friendIDS]])
               
           {
               cell.cellTitle.textColor=[UIColor blackColor];

               cell.backgroundColor=[UIColor greenColor];

           }
           else
           {
              // NSLog(@"Current Friend %@",[currentFriend friendIDS]);

cell.cellTitle.backgroundColor = [UIColor clearColor];
           }
       
       
        cell.cellTitle.text =[currentFriend friendName];
      
        [cell.imgfriends setImage:[currentFriend friendimage]];
        
    }
    [_activityIndicator stopAnimating];
    
    
    
    if ([selectedFriendsArray indexOfObject:cell.cellTitle.text] != NSNotFound) {
       
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

        
        cell.imgCheck.hidden=YES;

    }else{
        cell.imgCheck.hidden=NO;
        cell.accessoryType = UITableViewCellAccessoryNone;


    }

        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"myCell";
    ParseExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    FriendsDataObject *currentFriend = [MutFriendsArray objectAtIndex:indexPath.row];

    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
       
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        myInt=[lblNumberOfChecker.text intValue]-1;
         [selectedFriendsArray removeObject:[currentFriend friendIDS]];
        lblNumberOfChecker.text=[NSString stringWithFormat:@"%li", (long)myInt];
        cell.imgCheck.hidden=YES;

    }else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedFriendsArray addObject:[currentFriend friendIDS]];

        myInt=[lblNumberOfChecker.text intValue]+1;
        lblNumberOfChecker.text=[NSString stringWithFormat:@"%li", (long)myInt];
        cell.imgCheck.hidden=NO;

    }

}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.friendsTable.allowsSelection = NO;
    self.friendsTable.scrollEnabled = NO;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.friendsTable.allowsSelection = YES;
    self.friendsTable.scrollEnabled = YES;
}
- (void)doSearch:(NSString *)searchText {
    
   }
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some
    // api that you are using to do the search
    
    /*
    [searchBar resignFirstResponder];
    
    

    NSArray *results = [self doSearch:searchBar.text];
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.friendsTable.allowsSelection = YES;
    self.friendsTable.scrollEnabled = YES;
	
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:results];
    [friendsTable reloadData];
 */
}

//*********************************************************
//make sure you have a global NSMutableArray *placesArray in your view controllers.h file.



- (void)_loadData {
    // ...
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            facebookID = userData[@"id"];
           name = userData[@"first_name"];
            //  NSString *location = userData[@"location"][@"name"];
            //NSString *gender = userData[@"gender"];
            //NSString *birthday = userData[@"birthday"];
            // NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            // Run network request asynchronously
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:
             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (connectionError == nil && data != nil) {
                     // Set the image in the header imageView
                     self.headerImageView.image = [UIImage imageWithData:data];
                     lblUserName.text=name;
                     
                 }
             }];
            
            // Now add the data to the UI elements
            // ...
        }
    }];
}

//*********************************************************
// Set Up the UItableview As a vertical setting
-(void)verticalTable
{
    
    
    self.friendsTable.rowHeight = 320.0;
    self.friendsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // Rotates the view.
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);
    self.friendsTable.transform = transform;
    // Repositions and resizes the view.
    CGRect contentRect = CGRectMake(0, 90, 320, 50);
    self.friendsTable.frame = contentRect;
    self.friendsTable.pagingEnabled
    = YES;
}

//*********************************************************
// Set Picture in a round shape
-(void)SetPictureRound
{
    
    CALayer * l = [headerImageView layer];
    [l setMasksToBounds:YES];
    
    [l setCornerRadius:25];
    
    // You can even add a border
    [l setBorderWidth:4.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
}
-(void)SetTableRound
{
    
    CALayer * l = [friendsTable layer];
    [l setMasksToBounds:YES];
    
    [l setCornerRadius:25];
    
    // You can even add a border
    [l setBorderWidth:4.0];
    [l setBorderColor:[[UIColor whiteColor] CGColor]];
}

//****************************************************
//Create A New Facebook Session
-(void)CreateNewFBSession
{
    if(![[FBSession activeSession] isOpen]){
        NSLog(@"Creating new session");
        [FBSession openActiveSessionWithPermissions:nil
                                       allowLoginUI:NO
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      [self makeRequestForUserData];
                                  }];
    }

}
- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
          //  NSLog(@"user info: %@", result);
            //[self.txtDetails setText: [result string]];
            //[[FBSession activeSession] closeAndClearTokenInformation];
        } else {
            NSLog(@"error %@", error.description);
        }
    }];
}
//*********************************************************
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
  // [PFUser logOut];
  //  [self dismissViewControllerAnimated:YES completion:nil];
   // NSLog(@"this is loged in ");
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    selectedRow=-1 ;
    tableData =[[NSMutableArray alloc]init];
   selectedFriendsArray= [[NSMutableArray alloc] init];
    AlreadyCheckersArray =[[NSMutableArray alloc]init];

    [self queryfromCheky];

    //friendsTable.allowsSelection = YES;

    [self CreateNewFBSession];
    [self SetTableRound];
    [SwitchGroup setOnTintColor:[UIColor whiteColor]];

    
    friendsTable.layer.borderWidth = 2.0;

    friendsTable.layer.borderColor = [UIColor whiteColor].CGColor;


   [_activityIndicator startAnimating];
    
    
    NSLog(@" current user %@",[PFUser currentUser]);
    [self performSelector:@selector(startCalculationForAllFriends)];


    // Do any additional setup after loading the view.
    [self SetPictureRound];
    [self _loadData];

    //When You Press the tab Bar Change the color
   // [[UITabBar appearance] setSelectedImageTintColor:[UIColor blueColor]];


}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//*********************************************************
//Fade in Fade Put Message
-(void)hideLabel
{
    lblSuccefulyAdded.hidden=YES;
}
-(void)FadeInFadeoutLablemessage
{
   
    
    
    lblSuccefulyAdded.alpha = 0.0;
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         lblSuccefulyAdded.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:3.0
                                               delay:1.0
                                             options: UIViewAnimationCurveEaseOut
                                          animations:^{
                                              lblSuccefulyAdded.alpha = 0.0;
                                              
                                          }
                
                                          completion:^(BOOL finished){
                                              lblSuccefulyAdded.hidden=NO;
                                              
                                          }];
                         HideLabletimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideLabel) userInfo:nil repeats:NO];  }];

}

- (IBAction)AddChecker:(id)sender {
    
    
 //   NSLog(@"this is selcted array content %@",selectedFriendsArray);
    PFObject *addValues= [PFObject objectWithClassName:@"Checky"];
 for(NSObject *checkerid in selectedFriendsArray)
 {
    if ([[NSSet setWithArray:selectedFriendsArray] isEqualToSet:[NSSet setWithArray:AlreadyCheckersArray]])
   
   {
            NSLog(@"Some friends already check on you");
        }
        else
        {
    [addValues setObject:facebookID  forKey:@"CheckedOn"];
    [addValues setObject:checkerid forKey:@"CheckedBy"];
   // [addValues setObject:NO forKey:@"CheckedBy"];
    
            [self queryfromCheky];
        }
 }
    [addValues saveInBackground];
    
    [friendsTable reloadData];
    selectedRow=0;
    lblNumberOfChecker.text=@"";
   // [selectedFriendsArray removeAllObjects];
    [self FadeInFadeoutLablemessage];
}

- (IBAction)SwitchGroupMove:(id)sender {
    if ([SwitchGroup isOn]) {
        lblGroupOnOff.text= @"ON";
       // btnAddgroup.enabled=YES;
       // lblGroups.textColor = [UIColor colorWithRed:188 green:149 blue:88 alpha:1.0];



    }
    else
    {
        lblGroupOnOff.text= @"OFF";
       // btnAddgroup.enabled=NO;


    }
}
- (IBAction)SwitchTable:(id)sender {
    
    
    if ([SwitchTable isOn]) {
        
        lblCheckOnMeAndThem.text=@"I Check On Them";

    }
    else
    {
        lblCheckOnMeAndThem.text=@"They Check On Me";


    }
}
@end
