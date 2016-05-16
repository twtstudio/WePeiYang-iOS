//
//  NewsCommentTableViewCell.h
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/13.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsComment.h"

@interface NewsCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setCommentObject:(NewsComment *)obj;

@end
