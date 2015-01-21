//
//  FeedbackForm.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/21.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface FeedbackForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *deviceModel;
@property (nonatomic, copy) NSString *deviceVersion;
@property (nonatomic, copy) NSString *advices;

@end
