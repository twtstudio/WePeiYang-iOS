//
//  LostFoundTableViewCell.h
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LostFoundItem.h"

@interface LostFoundTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setLostFoundItem:(LostFoundItem *)obj withType:(NSInteger)type;

@end
