//
//  LostFoundTableViewCell.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "LostFoundTableViewCell.h"
#import "UIKit+AFNetworking.h"

@implementation LostFoundTableViewCell

@synthesize picImageView;
@synthesize phoneLabel;
@synthesize placeLabel;
@synthesize timeLabel;
@synthesize nameLabel;
@synthesize titleLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLostFoundItem:(LostFoundItem *)obj withType:(NSInteger)type {
    nameLabel.text = obj.name;
    titleLabel.text = obj.title;
    placeLabel.text = obj.place;
    timeLabel.text = obj.time;
    phoneLabel.text = obj.phone;
    if (type == 0) {
        // lost
        /*
         'lost_type' => [
         '0' => '其它，用户自定义',
         '1' => '银行卡',
         '2' => '饭卡&身份证',
         '3' => '钥匙',
         '4' => '书包',
         '5' => '电脑包',
         '6' => '手表&饰品',
         '7' => 'U盘&硬盘',
         '8' => '水杯',
         '9' => '书',
         '10' => '手机'
         ],
         */
        switch (obj.lostType) {
            case 0:
                picImageView.image = [UIImage imageNamed:@"lf_item_lostDefault"];
                break;
            case 1:
                picImageView.image = [UIImage imageNamed:@"lf_item_card"];
                break;
            case 2:
                picImageView.image = [UIImage imageNamed:@"lf_item_idcard"];
                break;
            case 3:
                picImageView.image = [UIImage imageNamed:@"lf_item_key"];
                break;
            case 4:
                picImageView.image = [UIImage imageNamed:@"lf_item_schoolbag"];
                break;
            case 5:
                picImageView.image = [UIImage imageNamed:@"lf_item_pcbag"];
                break;
            case 6:
                picImageView.image = [UIImage imageNamed:@"lf_item_watch"];
                break;
            case 7:
                picImageView.image = [UIImage imageNamed:@"lf_item_udisk"];
                break;
            case 8:
                picImageView.image = [UIImage imageNamed:@"lf_item_cup"];
                break;
            case 9:
                picImageView.image = [UIImage imageNamed:@"lf_item_book"];
                break;
            case 10:
                picImageView.image = [UIImage imageNamed:@"lf_item_phone"];
                break;
            default:
                break;
        }
    } else {
        [picImageView setImageWithURL:[NSURL URLWithString:obj.foundPic] placeholderImage:[UIImage imageNamed:@"lf_item_foundDefault"]];
    }
}

@end
