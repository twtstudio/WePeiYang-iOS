//
//  HringTableCell.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-13.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "HringTableCell.h"

@implementation HringTableCell

@synthesize titleLabel;
@synthesize corpLabel;
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize placeLabel;

- (void)awakeFromNib
{
    // Initialization code
}

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
