//
//  SettingViewController.m
//  Buzzem
//
//  Created by Sami Shamsan on 2/19/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "SettingViewController.h"
#import "SWRevealViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SlideMenu];

self.title=@"Settings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
