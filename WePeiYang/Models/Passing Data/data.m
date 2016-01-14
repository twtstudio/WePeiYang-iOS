//
//  data.m
//  News
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "data.h"

@implementation data

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (data *)shareInstance {
    static data *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
