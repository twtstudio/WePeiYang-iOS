//
//  LAFound_QueryListTableViewCell.h
//  LostAndFound
//
//  Created by 马骁 on 14-4-12.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LAFound_QueryListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *borderImage;
@property (weak, nonatomic) IBOutlet UIImageView *placeLogo;
@property (weak, nonatomic) IBOutlet UIImageView *timeLogo;

@end
