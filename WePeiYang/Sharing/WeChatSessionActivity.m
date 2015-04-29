//
//  WeChatSessionActivity.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "WeChatSessionActivity.h"

@implementation WeChatSessionActivity {
    NSURL *url;
    NSString *titleStr;
}

- (NSString *)activityType {
    return @"com.tecent.wechat.session";
}

- (NSString *)activityTitle {
    return @"分享到微信";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"wxSession"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id tmp in activityItems) {
        if ([tmp isKindOfClass:[NSURL class]]) {
            url = [tmp copy];
        } else if ([tmp isKindOfClass:[NSString class]]) {
            titleStr = [tmp copy];
        } else {
            continue;
        }
    }
}

- (void)performActivity {
    
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = titleStr;
    [msg setThumbImage:[UIImage imageNamed:@"thumbIcon"]];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = [url absoluteString];
    
    msg.mediaObject = webObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = msg;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    
    [self activityDidFinish:YES];
}

@end
