//
//  OpenInSafariActivity.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/21.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "OpenInSafariActivity.h"

@implementation OpenInSafariActivity {
    NSURL *url;
}

- (NSString *)activityType {
    return @"com.apple.safari.open-in";
}

- (NSString *)activityTitle {
    return NSLocalizedString(@"Open in Safari", @"");
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"openinsafari.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id tmp in activityItems) {
        if ([tmp isKindOfClass:[NSURL class]]) {
            url = [tmp copy];
        } else {
            continue;
        }
    }
}

- (void)performActivity {
    [[UIApplication sharedApplication] openURL:url];
    [self activityDidFinish:YES];
}

@end
