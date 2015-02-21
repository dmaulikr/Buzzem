//
//  ParseExampleCell.m
//  ParseExample
//
//  Created by Nick Barrowclough on 3/7/13.
//  Copyright (c) 2013 Nicholas Barrowclough. All rights reserved.
//

#import "ParseExampleCell.h"

@implementation ParseExampleCell

@synthesize cellTitle;
@synthesize imgCheck;
@synthesize imgfriends;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
