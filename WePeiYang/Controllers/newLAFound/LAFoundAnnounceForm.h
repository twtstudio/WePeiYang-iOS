//
//  LAFoundAnnounceForm.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface LAFoundAnnounceForm : NSObject <FXForm>

@property (nonatomic) NSInteger type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, copy) NSNumber *phone;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;

@end
