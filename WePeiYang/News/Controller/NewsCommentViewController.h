//
//  NewsCommentViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/13.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLKTextViewController.h"

@interface NewsCommentViewController : SLKTextViewController

@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSArray *commentArray;

@end