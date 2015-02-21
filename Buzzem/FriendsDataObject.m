//
//  FriendsDataObject.m
//  CheckyLand
//
//  Created by Sami Shamsan on 11/5/14.
//  Copyright (c) 2014 com.Sami.CheckyLand. All rights reserved.
//

#import "FriendsDataObject.h"

@implementation FriendsDataObject
@synthesize friendId;
@synthesize friendIDS;
@synthesize friendName;
@synthesize friendimageURL;
@synthesize friendimage;


-(id)initWithJSONData:(NSDictionary*)data{
    self = [super init];
    if(self){
        //NSLog(@"initWithJSONData method called");
        self.friendId = [[data objectForKey:@"id"] integerValue];
        self.friendIDS =  [data objectForKey:@"id"];
        self.friendName =  [data objectForKey:@"name"];
        self.friendimageURLstring =  [[data objectForKey:@"data"]objectForKey:@"url"];
        self.friendimageURL=[NSURL URLWithString:[data objectForKey:@"url"]];
       // self.friendimage=  [[data objectForKey:@"data"]objectForKey:@"url"]
        
        NSDictionary *image =  [[data objectForKey:@"data"]objectForKey:@"url"];
        NSURL *imageURL = [NSURL URLWithString:[image objectForKey:@"url"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        self.friendimage=   [UIImage  imageWithData:imageData];
        
    }
    return self;
}

@end
