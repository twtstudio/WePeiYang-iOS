//
//  SchemeManager.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/24.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "SchemeManager.h"
#import "SolaFoundationKit.h"
#import "wpyWebViewController.h"
#import "SVModalWebViewController.h"

@implementation SchemeManager

+ (void)handleSchemeURL:(NSURL *)url {
    NSLog(@"URL scheme: %@", [url scheme]);
    NSLog(@"URL host: %@", [url host]);
    NSLog(@"URL path: %@", [url path]);
    NSLog(@"URL query: %@", [url query]);
    
    if ([[url host] isEqualToString:@"platform"]) {
        if ([[url path] isEqualToString:@"/startapp"]) {
            NSMutableDictionary *queryDic = [[NSMutableDictionary alloc] init];
            NSArray *urlComponents = [[url query] componentsSeparatedByString:@"&"];
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
                        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:url];
                        [[SolaFoundationKit topViewController] presentViewController:webViewController animated:YES completion:nil];
                    }
                } else if ([[queryDic objectForKey:@"app"] isEqualToString:@"main"]) {
                    
                } else if ([[queryDic objectForKey:@"app"] isEqualToString:@"gpa"]) {
                    
                } else if ([[queryDic objectForKey:@"app"] isEqualToString:@"classtable"]) {
                    
                }
            }
        }
    }

}

@end
