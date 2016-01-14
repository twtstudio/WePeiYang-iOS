//
//  SolaInstance.h
//  Singleton to save the instances in SolaSDK
//  Project Sola
//
//  Created by Qin Yubo on 15/10/29.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SolaInstance : NSObject

@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appSecret;

+ (SolaInstance *)shareInstance;

@end
