//
//  JobTableCell.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *corporationLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *corpIconImg;
@property (strong, nonatomic) IBOutlet UIImageView *timeIconImg;

@end
