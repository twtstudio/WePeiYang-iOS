//
//  HringTableCell.h
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-13.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HringTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *corpLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *timeImg;
@property (strong, nonatomic) IBOutlet UIImageView *placeImg;

@end
