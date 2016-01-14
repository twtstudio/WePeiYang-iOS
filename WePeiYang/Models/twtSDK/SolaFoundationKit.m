//
//  SolaFoundationKit.m
//  Sola
//
//  Created by Qin Yubo on 15/10/29.
//
//

#import "SolaFoundationKit.h"
#import <sys/sysctl.h>

@implementation SolaFoundationKit

+ (UIViewController *)topViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (NSString *)appName {
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *appName =[infoDict objectForKey:@"CFBundleName"];
    return appName;
}

+ (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+ (NSString *)appBuild {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return appVersion;
}

+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    //NSString *platform = [NSStringstringWithUTF8String:machine];二者等效
    free(machine);
    return platform;
}

+ (NSString *)deviceOSVersion {
    return [[UIDevice alloc] init].systemVersion;
}

+ (NSString *)userAgentString {
    NSString *uaString = [[NSString alloc] initWithFormat:@"%@/%@(%@; iOS %@)", [self appName], [self appVersion], [self deviceModel], [self deviceOSVersion]];
    return uaString;
}

@end
