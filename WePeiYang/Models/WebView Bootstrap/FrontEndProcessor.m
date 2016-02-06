//
//  wpyStringProcessor.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-25.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "FrontEndProcessor.h"

@implementation FrontEndProcessor

+ (NSString *)convertToBootstrapHTMLWithNewsContent:(NewsContent *)newsContent {
    NSString *contentStr = newsContent.content;
    NSScanner *imgScanner = [NSScanner scannerWithString:contentStr];
    while (![imgScanner isAtEnd]) {
        
        NSString *imgPath;
        NSString *imgStyle;
        
        NSString *imgHeaderStr = @"<img src=\"http://";
        [imgScanner scanUpToString:imgHeaderStr intoString:NULL];
        [imgScanner scanUpToString:@"http://" intoString:NULL];
        [imgScanner scanUpToString:@"\"" intoString:&imgPath];
        imgPath = [imgPath stringByReplacingOccurrencesOfString:imgHeaderStr withString:@""];
        
        NSString *imgStyleHeaderStr = @"\"";
        [imgScanner scanUpToString:imgStyleHeaderStr intoString:NULL];
        [imgScanner scanUpToString:@"/>" intoString:&imgStyle];
        
        NSString *originalImgStr = [NSString stringWithFormat:@"%@%@%@%@",@"<img src=\"",imgPath,imgStyle,@"/>"];
        NSString *responsiveImgStr = [NSString stringWithFormat:@"<img class=\"img-responsive\" alt=\"Responsive image\" src=\"%@\" width=100%%/>",imgPath];
        
        contentStr = [contentStr stringByReplacingOccurrencesOfString:originalImgStr withString:responsiveImgStr];
    }
    
    NSString *load = [NSString stringWithFormat:@"<!DOCTYPE html> \n"
                      "<html> \n"
                      "<head> \n"
                      "<meta charset=\"utf-8\"> \n"
                      "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> \n"
                      "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> \n"
                      "<link href=\"bootstrap.css\" rel=\"stylesheet\"> \n"
                      "</head> \n"
                      "<body> \n"
                      "<div class=\"container\"> \n"
                      "<div class=\"row\"> \n"
                      "<div class=\"col-sm-12\"> \n"
                      "<h4>%@</h4> \n"
                      "%@ \n"
                      "<br> \n"
                      "</div> \n"
                      "<div class=\"col-sm-12\" style=\"color: #666666\">%@<br>%@<br>%@<br>%@<br><br></div> \n"
                      "</div></div> \n"
                      "<script src=\"bootstrap.min.js\"></script> \n"
                      "<script src=\"jquery.min.js\"></script> \n"
                      "<script src=\"bridge.js\"></script> \n"
                      "</body> \n"
                      "</html>" , newsContent.subject, contentStr, [NSString stringWithFormat:@"来源：%@", newsContent.source], [NSString stringWithFormat:@"供稿：%@", newsContent.author], [NSString stringWithFormat:@"审稿：%@", newsContent.reviewer], (newsContent.photographer.length == 0) ? @"" : [NSString stringWithFormat:@"摄影：%@", newsContent.photographer]];
    
    return load;
}

@end
