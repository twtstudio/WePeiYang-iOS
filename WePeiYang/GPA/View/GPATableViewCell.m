//
//  GPATableViewCell.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/15.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "GPATableViewCell.h"

@implementation GPATableViewCell

@synthesize nameLabel;
@synthesize scoreLabel;
@synthesize creditLabel;
@synthesize dotView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setClassData:(GPAClassData *)classData {
    nameLabel.text = classData.name;
    scoreLabel.text = classData.score;
    creditLabel.text = classData.credit;
}

@end
