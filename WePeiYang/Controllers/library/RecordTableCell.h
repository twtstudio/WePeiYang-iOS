//
//  RecordTableCell.h
//  Library
//
//  Created by Qin Yubo on 13-11-5.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *recordCellBgImage;

@end
