//
//  LostFoundDetail.h
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface LostFoundDetail : NSObject

@property (strong, nonatomic) NSString *index;
@property (nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *content;
@property (nonatomic) NSInteger lostType;
@property (strong, nonatomic) NSString *otherTag;
@property (strong, nonatomic) NSString *foundPic;

@end
