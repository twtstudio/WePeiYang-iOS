//
//  GPATableViewCell.h
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/15.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPATableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dotView;

@end
