//
//  wpyStringProcessor.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-25.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "wpyStringProcessor.h"

@implementation wpyStringProcessor

@synthesize finishCallbackBlock;

+ (void)convertToWebViewByString:(NSString *)contentStr withFinishCallbackBlock:(void(^)(NSString *))block
{
    wpyStringProcessor *wpySP = [[wpyStringProcessor alloc]init];
    wpySP.finishCallbackBlock = block;
    NSString *load = [NSString stringWithFormat:@"<html> \n"
                      "<head> \n"
                      "<style type=\"text/css\"> \n"
                      "body {font-family: \"%@\"; font-size: %@; color: %@;}\n"
                      "</style> \n"
                      "</head> \n"
                      "<body>%@</body> \n"
                      "</html>", @"宋体", @"48",@"000000",contentStr];
    
    if (wpySP.finishCallbackBlock)
    {
        wpySP.finishCallbackBlock(load);
    }
}

+ (void)convertToTextViewByString:(NSString *)contentStr withFinishCallbackBlock:(void (^)(NSString *))block
{
    wpyStringProcessor *wpySP = [[wpyStringProcessor alloc]init];
    wpySP.finishCallbackBlock = block;
    
    NSString *html;
    html = contentStr;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = @"\n";
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"&lt;" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"&gt;" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@&gt;",text] withString:@""];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"nbsp;" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"ldquo;" withString:@"“"];
    html = [html stringByReplacingOccurrencesOfString:@"rdquo;" withString:@"”"];
    html = [html stringByReplacingOccurrencesOfString:@"mdash;" withString:@"—"];
    html = [html stringByReplacingOccurrencesOfString:@"middot;" withString:@"·"];
    html = [html stringByReplacingOccurrencesOfString:@"gt;" withString:@">"];
    html = [html stringByReplacingOccurrencesOfString:@"lt;" withString:@"<"];
    html = [html stringByReplacingOccurrencesOfString:@"&#60;" withString:@"<"];
    html = [html stringByReplacingOccurrencesOfString:@"&#62;" withString:@">"];
    html = [html stringByReplacingOccurrencesOfString:@"&#33;" withString:@"!"];

    if (wpySP.finishCallbackBlock)
    {
        wpySP.finishCallbackBlock(html);
    }
}

@end
