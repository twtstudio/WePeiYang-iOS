//
//  wpyWebConnection.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-12.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "wpyWebConnection.h"

@implementation wpyWebConnection

{
    NSString *statusCode;
}

@synthesize resultData;
@synthesize finishCallbackBlock;

+ (void)getDataFromURLStr:(NSString *)urlStr withFinishCallbackBlock:(void (^)(NSDictionary *))block;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    wpyWebConnection *wpyConn = [[wpyWebConnection alloc]init];
    wpyConn.finishCallbackBlock = block;
    NSString *urlStrStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStrStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:wpyConn];
    [conn start];
}

+ (void)postDataToURLStr:(NSString *)urlStr withFinishCallbackBlock:(void (^)(NSDictionary *))block
{
    wpyWebConnection *wpyConn = [[wpyWebConnection alloc]init];
    wpyConn.finishCallbackBlock = block;
    NSString *urlStrStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStrStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 60;
    request.URL = url;
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:wpyConn];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [conn start];
}

+ (void)getDataFromURLStr:(NSString *)urlStr andBody:(NSString *)body withFinishCallbackBlock:(void (^)(NSDictionary *))block
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    wpyWebConnection *wpyConn = [[wpyWebConnection alloc]init];
    wpyConn.finishCallbackBlock = block;
    NSString *urlStrStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStrStr];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyStr = [NSString stringWithFormat:@"%@&platform=ios&version=%@",body,appVersion];
    NSData *postBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:wpyConn];
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    if (!resultData)
    {
        resultData = [[NSMutableData alloc]init];
    }
    else
    {
        [resultData setLength:0];
    }
    if ([response respondsToSelector:@selector(allHeaderFields)])
    {
        NSDictionary *dictionary = [resp allHeaderFields];
        NSLog(@"%@",[dictionary description]);
        NSLog(@"%d",[resp statusCode]);
        statusCode = [NSString stringWithFormat:@"%d",[resp statusCode]];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [resultData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[waitingAlert dismissWithClickedButtonIndex:nil animated:YES];
    
    if (finishCallbackBlock)
    {
        finishCallbackBlock(nil);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[waitingAlert dismissWithClickedButtonIndex:nil animated:YES];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    NSMutableDictionary *callBackDic = [[NSMutableDictionary alloc]init];
    [callBackDic setObject:statusCode forKey:@"statusCode"];
    if (![statusCode isEqualToString:@"500"]) [callBackDic setObject:resultDic forKey:@"content"];
    if (finishCallbackBlock)
    {
        finishCallbackBlock(callBackDic);
    }
}

@end
