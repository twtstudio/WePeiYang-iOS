//
//  data.m
//  News
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "data.h"

static data *INSTANCE;

@implementation data

- (id)init
{
    self = [super init];
    if (self)
    {
        //这里初始化原本木有的数据，e.g.，Dictionary,Array,etc.
    }
    return self;
}

+ (data *)shareInstance
{
    if (!INSTANCE)
    {
        INSTANCE = [[data alloc]init];
    }
    return INSTANCE;
}

@end
