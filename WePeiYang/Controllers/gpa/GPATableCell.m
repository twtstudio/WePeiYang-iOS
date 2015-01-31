//
//  GPATableCell.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-10.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "GPATableCell.h"

@implementation GPATableCell

@synthesize nameCellLabel;
@synthesize scoreCellLabel;
@synthesize creditCellLabel;
@synthesize addedSubjectMarkImgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
