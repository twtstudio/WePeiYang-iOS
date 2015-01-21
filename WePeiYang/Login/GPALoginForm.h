//
//  GPALoginForm.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface GPALoginForm : NSObject <FXForm>

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;

@end
