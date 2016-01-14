//
//  NewsTableViewCell.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/12/6.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation NewsTableViewCell

@synthesize titleLabel;
@synthesize commentCount;
@synthesize visitCount;
@synthesize newsImg;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNewsData:(NewsData *)data {
    titleLabel.text = data.subject;
    commentCount.text = data.comments;
    visitCount.text = data.visitcount;
    [newsImg setImageWithURL:[NSURL URLWithString:data.pic] placeholderImage:[UIImage imageNamed:@"thumbIcon"]];
}

@end
