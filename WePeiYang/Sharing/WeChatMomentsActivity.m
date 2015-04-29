//
//  WeChatMomentsActivity.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/29.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "WeChatMomentsActivity.h"

@implementation WeChatMomentsActivity {
    NSURL *url;
    NSString *titleStr;
}

- (NSString *)activityType {
    return @"com.tecent.wechat.moment";
}

- (NSString *)activityTitle {
    return @"分享到朋友圈";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"wxTimeline"];
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
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    [self activityDidFinish:YES];
}

@end
