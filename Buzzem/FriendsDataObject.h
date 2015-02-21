//
//  FriendsDataObject.h
//  CheckyLand
//
//  Created by Sami Shamsan on 11/5/14.
//  Copyright (c) 2014 com.Sami.CheckyLand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FriendsDataObject : NSObject

-(id)initWithJSONData:(NSDictionary*)data;

@property (assign) NSInteger friendId;
@property (strong) NSString *friendIDS;

@property (strong) NSString *friendName;
@property (strong, nonatomic) NSString * friendimageURLstring;

@property (strong, nonatomic) NSURL * friendimageURL;
@property (strong, nonatomic) UIImage *friendimage;


@end
