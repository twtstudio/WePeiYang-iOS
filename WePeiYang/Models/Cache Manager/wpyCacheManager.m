//
//  wpyCacheManager.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/3/19.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "wpyCacheManager.h"

@implementation wpyCacheManager

+ (void)saveCacheData:(id)cacheData withKey:(NSString *)keyStr {
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:keyStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSLog(@"Cache file: %@ exists and replaced.", keyStr);
        [fileManager removeItemAtPath:cachePath error:nil];
    }
    [fileManager createFileAtPath:cachePath contents:nil attributes:nil];
    
    NSMutableData *toSaveCache = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:toSaveCache];
    [archiver encodeObject:cacheData forKey:@"data"];
    NSDate *now = [NSDate date];
    [archiver encodeObject:now forKey:@"time"];
    [archiver finishEncoding];
    [toSaveCache writeToFile:cachePath atomically:YES];
}

+ (void)loadCacheDataWithKey:(NSString *)keyStr andBlock:(void (^)(id))block {
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:keyStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath]) {
        NSLog(@"Cache file %@ doesn't Exist!", keyStr);
        return;
    } else {
        NSData *cacheData = [[NSData alloc]initWithContentsOfFile:cachePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:cacheData];
        id cacheObject = [unarchiver decodeObjectForKey:@"data"];
        [unarchiver finishDecoding];
        
        block(cacheObject);
        NSLog(@"Cache data %@ loaded in block.", keyStr);
    }
}

+ (void)removeCacheDataForKey:(NSString *)keyStr {
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:keyStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        [fileManager removeItemAtPath:cachePath error:nil];
    } else {
        NSLog(@"Cache file %@ doesn't exist.", keyStr);
    }
}

+ (BOOL)cacheDataExistsWithKey:(NSString *)keyStr {
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:keyStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        return YES;
    } else {
        return NO;
    }
}

@end
