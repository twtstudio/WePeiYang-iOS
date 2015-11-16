//
//  SolaInstance.m
//  Project Sola
//
//  Created by Qin Yubo on 15/10/29.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "SolaInstance.h"

@implementation SolaInstance

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (SolaInstance *)shareInstance {
    static SolaInstance *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
