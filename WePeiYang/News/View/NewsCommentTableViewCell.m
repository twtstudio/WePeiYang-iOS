//
//  NewsCommentTableViewCell.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/13.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "NewsCommentTableViewCell.h"

@implementation NewsCommentTableViewCell

@synthesize userLabel;
@synthesize contentLabel;
@synthesize timeLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentObject:(NewsComment *)obj {
    userLabel.text = obj.cuser;
    contentLabel.text = obj.ccontent;
    timeLabel.text = obj.ctime;
}

@end
