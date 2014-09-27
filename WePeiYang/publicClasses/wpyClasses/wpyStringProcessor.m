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
    
    NSScanner *imgScanner = [NSScanner scannerWithString:contentStr];
    while (![imgScanner isAtEnd]) {
        
        NSString *imgPath;
        NSString *imgStyle;
        
        NSString *imgHeaderStr = @"<img alt=\"\" src=\"http://";
        [imgScanner scanUpToString:imgHeaderStr intoString:NULL];
        [imgScanner scanUpToString:@"http://" intoString:NULL];
        [imgScanner scanUpToString:@"\"" intoString:&imgPath];
        imgPath = [imgPath stringByReplacingOccurrencesOfString:imgHeaderStr withString:@""];
        
        NSString *imgStyleHeaderStr = @"\"";
        [imgScanner scanUpToString:imgStyleHeaderStr intoString:NULL];
        [imgScanner scanUpToString:@"/>" intoString:&imgStyle];
        
        NSString *originalImgStr = [NSString stringWithFormat:@"%@%@%@%@",@"<img alt=\"\" src=\"",imgPath,imgStyle,@"/>"];
        NSString *responsiveImgStr = [NSString stringWithFormat:@"<img class=\"img-responsive\" alt=\"Responsive image\" src=\"%@\" width=96%%/>",imgPath];

        contentStr = [contentStr stringByReplacingOccurrencesOfString:originalImgStr withString:responsiveImgStr];
    }
    
    NSString *cssPath = [[NSBundle mainBundle]pathForResource:@"bootstrap" ofType:@"css"];
    NSString *jsPath = [[NSBundle mainBundle]pathForResource:@"bootstrap.min" ofType:@"js"];
    NSString *load = [NSString stringWithFormat:@"<!DOCTYPE html> \n"
                      "<html> \n"
                      "<head> \n"
                      "<meta charset=\"utf-8\"> \n"
                      "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> \n"
                      "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> \n"
                      "<link href=\"%@\" rel=\"stylesheet\"> \n"
                      "</head> \n"
                      "<body> \n"
                      "<div class=\"container\"> \n"
                      "<div class=\"row\"> \n"
                      "<div class=\"col-sm-12\"> \n"
                      "%@ \n"
                      "</div></div></div> \n"
                      "<script src=\"%@\"></script> \n"
                      "</body> \n"
                      "</html>" , cssPath, contentStr, jsPath];
    
    //NSLog(load);
    
    if (wpySP.finishCallbackBlock)
    {
        wpySP.finishCallbackBlock(load);
    }
}

@end
