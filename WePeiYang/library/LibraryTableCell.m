//
//  LibraryTableCell.m
//  Library
//
//  Created by Qin Yubo on 13-11-5.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "LibraryTableCell.h"

@implementation LibraryTableCell

@synthesize titleLabel = _titleLabel;
@synthesize positionYearLabel = _positionYearLabel;
@synthesize leftLabel = _leftLabel;
@synthesize authorLabel = _authorLabel;
@synthesize cellBgImageView;

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
