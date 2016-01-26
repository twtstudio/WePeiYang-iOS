//
//  SchemeManager.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/24.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "SchemeManager.h"
#import "SolaFoundationKit.h"

@implementation SchemeManager

+ (void)handleSchemeWithQueryString:(NSString *)query {
    
    NSMutableDictionary *queryDic = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [query componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        [queryDic setObject:value forKey:key];
    }
    
    if ([queryDic objectForKey:@"app"] != nil) {
        if ([[queryDic objectForKey:@"app"] isEqualToString:@"h5"]) {
            if ([queryDic objectForKey:@"url"] != nil) {
                NSString *url = [queryDic objectForKey:@"url"];
                // BLABLABLA
                
            }
        } else if ([[queryDic objectForKey:@"app"] isEqualToString:@"main"]) {
            
        } else if ([[queryDic objectForKey:@"app"] isEqualToString:@"gpa"]) {
            
        } else if ([[queryDic objectForKey:@"app"] isEqualToString:@"classtable"]) {
            
        }
    }
    
}

@end
