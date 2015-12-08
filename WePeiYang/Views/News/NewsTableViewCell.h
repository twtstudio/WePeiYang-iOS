//
//  NewsTableViewCell.h
//  WePeiYang
//
//  Created by Qin Yubo on 15/12/6.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsData.h"

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UIImageView *newsImg;

- (void)setNewsData:(NewsData *)data;

@end
