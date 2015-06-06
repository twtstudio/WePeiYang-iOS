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
        self.backgroundColor = [UIColor whiteColor];
        
        addedSubjectMarkImgView.backgroundColor = [UIColor colorWithRed:255/255.0f green:85/255.0f blue:95/255.0f alpha:1.0f];
        addedSubjectMarkImgView.layer.cornerRadius = 0.5 * addedSubjectMarkImgView.frame.size.width;
        addedSubjectMarkImgView.clipsToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
