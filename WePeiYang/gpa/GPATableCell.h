//
//  GPATableCell.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-10.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPATableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameCellLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreCellLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditCellLabel;
@property (strong, nonatomic) IBOutlet UIImageView *addedSubjectMarkImgView;

@end
