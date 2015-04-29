//
//  AccountManager.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/5.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "AccountManager.h"
#import "twtAPIs.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "twtSecretKeys.h"
#import "data.h"
#import "wpyEncryption.h"
#import "wpyCacheManager.h"

@implementation AccountManager

// Status

+ (BOOL)isLoggedIn {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isLibBinded {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    return [userDefaults boolForKey:@"bindLib"];
}

+ (BOOL)isTjuBinded {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    return [userDefaults boolForKey:@"bindTju"];
}

// Log in & Log out

+ (void)loginWithParameters:(NSDictionary *)parameters andType:(twtLoginType)type Success:(void (^)())success Failure:(void (^)(NSInteger, NSString *))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs login] parameters:parameters success:^(AFHTTPRequestOperation *operaion, id responseObject) {
        
        NSDictionary *contentDic = [operaion.responseString objectFromJSONString];
        
        NSUserDefaults *userDefault = [[NSUserDefaults alloc]init];
        
        NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:plistPath]) {
            [fileManager removeItemAtPath:plistPath error:nil];
        }
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        
        NSString *twtId = [contentDic objectForKey:@"id"];
        NSString *twtToken = [contentDic objectForKey:@"token"];
        NSString *key = [twtSecretKeys getSecretKey];
        NSData *plainId = [twtId dataUsingEncoding:NSUTF8StringEncoding];
        NSData *secretId = [plainId AES256EncryptWithKey:key];
        NSData *plainToken = [twtToken dataUsingEncoding:NSUTF8StringEncoding];
        NSData *secretToken = [plainToken AES256EncryptWithKey:key];
        
        NSMutableData *saveData = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:saveData];
        [archiver encodeObject:secretId forKey:@"id"];
        [archiver encodeObject:secretToken forKey:@"token"];
        [archiver finishEncoding];
        
        [saveData writeToFile:plistPath atomically:YES];
        
        [data shareInstance].userId = [contentDic objectForKey:@"id"];
        [data shareInstance].userToken = [contentDic objectForKey:@"token"];
        
        NSString *tjuuname = [contentDic objectForKey:@"tjuuname"];
        NSString *libuname = [contentDic objectForKey:@"libuname"];
        
        if ([tjuuname isEqualToString:@""])
        {
            [userDefault setBool:NO forKey:@"bindTju"];
        } else {
            [userDefault setBool:YES forKey:@"bindTju"];
        }
        if ([libuname isEqualToString:@""])
        {
            [userDefault setBool:NO forKey:@"bindLib"];
        } else {
            [userDefault setBool:YES forKey:@"bindLib"];
        }
        
        NSString *studentId = [contentDic objectForKey:@"studentid"];
        [userDefault setObject:studentId forKey:@"studentid"];
        
        // Block
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Block
        failure(operation.response.statusCode, error.localizedDescription);
    }];
}

+ (void)logoutWithParameters:(NSDictionary *)parameters withBlock:(void (^)())block {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs logout] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Log out successfully.");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Log out failed.");
    }];
    
    [data shareInstance].userId = @"";
    [data shareInstance].userToken = @"";
    
    NSArray *files = @[@"login",@"libraryCollectionData",@"gpa",@"gpaResult",@"collectionData",@"noticeFavData",@"jobFavData",@"noticeAccount",@"twtLogin",@"libraryRecordCache",@"gpaCacheData"];
    for (NSString *fileName in files) {
        [self removeFileWithFileName:fileName];
    }
    
    NSArray *caches = @[@"gpaCache"];
    for (NSString *cacheName in caches) {
        [wpyCacheManager removeCacheDataForKey:cacheName];
    }
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
    [userDefaults setBool:NO forKey:@"bindLib"];
    [userDefaults setBool:NO forKey:@"bindTju"];
    
    NSUserDefaults *suiteDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.WePeiYang"];
    [suiteDefaults removeObjectForKey:@"Classtable"];
    [suiteDefaults synchronize];
    
    block();
}

// Bind & Unbind

+ (void)bindTjuWithParameters:(NSDictionary *)parameters success:(void (^)())success failure:(void (^)(NSInteger, NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs bindTju] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
        [userDefaults setBool:YES forKey:@"bindTju"];
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode, error.localizedDescription);
    }];
}

+ (void)bindLibWithParameters:(NSDictionary *)parameters success:(void (^)())success failure:(void (^)(NSInteger, NSString *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs bindLib] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
        [userDefaults setBool:YES forKey:@"bindLib"];
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode, error.localizedDescription);
    }];
}

+ (void)unBindTjuWithParameters:(NSDictionary *)parameters success:(void (^)())success failure:(void (^)())failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs unbindTju] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *files = @[@"gpa",@"gpaResult",@"gpaCacheData"];
        for (NSString *fileName in files) {
            [self removeFileWithFileName:fileName];
        }
        
        [wpyCacheManager removeCacheDataForKey:@"gpaCache"];
        
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
        [userDefaults setBool:NO forKey:@"bindTju"];
        
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}

+ (void)unBindLibWithParameters:(NSDictionary *)parameters success:(void (^)())success failure:(void (^)())failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs unbindLib] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *files = @[@"login",@"libraryRecordCache"];
        for (NSString *fileName in files) {
            [self removeFileWithFileName:fileName];
        }
        
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
        [userDefaults setBool:NO forKey:@"bindLib"];
        
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
}

// Private Class Method

+ (void)removeFileWithFileName:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [fileManager removeItemAtPath:path error:nil];
}

@end
