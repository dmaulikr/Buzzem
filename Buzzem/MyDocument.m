//
//  MyDocument.m
//  TIMES
//
//  Created by Sami Shamsan on 1/21/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "MyDocument.h"
#import <UIKit/UIKit.h>

@implementation MyDocument
@synthesize dataContent;

// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    self.dataContent = [[NSData alloc] initWithBytes:[contents bytes] length:[contents length]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified" object:self];
    return YES;
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return self.dataContent;
}

@end
