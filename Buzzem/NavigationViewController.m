//
//  NavigationViewController.m
//  Buzzem
//
//  Created by Sami Shamsan on 2/11/15.
//  Copyright (c) 2015 com.Sami.Buzzem. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "FriendsDataObject.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface NavigationViewController ()
{
    NSArray *NavigationList;
    NSArray *NavigationImages;
    NSString *Facebookname;
    NSString *facebookID;
    UIImage *Facebookimage;

}
@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self LoadTheNavigationItems];
   
        [self connectWithFacebook];

       // [self GoToHome];
}
-(void)connectWithFacebook
{
    if(![[FBSession activeSession] isOpen]){
        NSLog(@"Creating new session");
        [FBSession openActiveSessionWithPermissions:nil
                                       allowLoginUI:NO
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      [self makeRequestForUserData];
                                  }];
    }
    
    [self _loadData];

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
-(void)viewWillAppear:(BOOL)animated
{
    [self _loadData];


}
-(void)GoToHome
{
    
    UIImage* image3 = [UIImage imageNamed:@"home-2-32.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self  action:@selector(GoHome:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *HomeButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem=HomeButton;
    
    
}
- (void)GoHome:(UIBarButtonItem *)sender{
    
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
//========================================================================
#pragma mark - Import Facebook Image
//============================================================================
- (void)_loadData {
    // ...
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            facebookID = userData[@"id"];
            Facebookname = userData[@"first_name"];
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
                    Facebookimage = [UIImage imageWithData:data];
                     
                 }
             }];
            
            // Now add the data to the UI elements
            // ...
        }
    }];
}

-(void)LoadTheNavigationItems
{//RemindFriend
    
    NSString *Name;
    NSString *profileImage;

    if(!Name)
        Name=@"UserName";
    if(!profileImage)
        profileImage=@"user-2-32.png";

    NavigationList=@[Name,@"Inbox",@"Setting",@"Logout"];
    NavigationImages=@[profileImage,@"settings-12-32.png",@"settings-12-32.png",@"logout-32.png"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [NavigationList count];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   

    NSString *CellIdentfier=[NavigationList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier forIndexPath:indexPath];
    // Configure the cell...
   
    
    UIImage *originalImage =[UIImage imageNamed:[NavigationImages objectAtIndex:indexPath.row]];
    // Resize the image
    
    
    if(indexPath.row==0)
    {
        originalImage =Facebookimage;
        cell.textLabel.text=Facebookname;
        
    }
    CGSize cellViewSize = CGSizeMake(32.0, 32.0);
    UIImage *resizedImage=[self imageWithImage:originalImage scaledToSize:cellViewSize];
    
    [[cell imageView] setImage:resizedImage];

        
    return cell;
        
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==3)
    {
         [PFUser logOut];
         [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

@end
