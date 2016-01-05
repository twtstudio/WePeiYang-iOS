//
//  wpyDeviceStatus.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-3.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "wpyDeviceStatus.h"
#include <sys/types.h>
#import <sys/sysctl.h>
#import "data.h"

@implementation wpyDeviceStatus

+ (NSString *)getAppVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+ (NSString *)getAppBuild {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return appVersion;
}

+ (NSString *)getDeviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    //NSString *platform = [NSStringstringWithUTF8String:machine];二者等效
    free(machine);
    NSString *device;
    if ([platform isEqualToString:@"x86_64"]) device = @"iPhone Simulator";
    else if ([platform isEqualToString:@"i386"]) device = @"iPhone Simulator";
    
    else if ([platform isEqualToString:@"iPhone2,1"]) device = @"iPhone 3GS";
    else if ([platform isEqualToString:@"iPhone3,1"]) device = @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,2"]) device = @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"]) device = @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone4,1"]) device = @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]) device = @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,2"]) device = @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]) device = @"iPhone 5c";
    else if ([platform isEqualToString:@"iPhone5,4"]) device = @"iPhone 5c";
    else if ([platform isEqualToString:@"iPhone6,1"]) device = @"iPhone 5s";
    else if ([platform isEqualToString:@"iPhone6,2"]) device = @"iPhone 5s";
    else if ([platform isEqualToString:@"iPhone7,1"]) device = @"iPhone 6 Plus";
    else if ([platform isEqualToString:@"iPhone7,2"]) device = @"iPhone 6";
    
    else if ([platform isEqualToString:@"iPod4,1"]) device = @"iPod touch 4";
    else if ([platform isEqualToString:@"iPod5,1"]) device = @"iPod touch 5";
    
    else if ([platform isEqualToString:@"iPad2,1"]) device = @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,2"]) device = @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,3"]) device = @"iPad 2";
    else if ([platform isEqualToString:@"iPad2,4"]) device = @"iPad 2 rev_a";
    else if ([platform isEqualToString:@"iPad3,1"]) device = @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,2"]) device = @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,3"]) device = @"iPad 3";
    else if ([platform isEqualToString:@"iPad3,4"]) device = @"iPad 4";
    else if ([platform isEqualToString:@"iPad3,5"]) device = @"iPad 4";
    else if ([platform isEqualToString:@"iPad3,6"]) device = @"iPad 4";
    else if ([platform isEqualToString:@"iPad4,1"]) device = @"iPad Air";
    else if ([platform isEqualToString:@"iPad4,2"]) device = @"iPad Air";
    else if ([platform isEqualToString:@"iPad4,3"]) device = @"iPad Air";
    else if ([platform isEqualToString:@"iPad5,3"]) device = @"iPad Air 2";
    else if ([platform isEqualToString:@"iPad5,4"]) device = @"iPad Air 2";
    
    else if ([platform isEqualToString:@"iPad2,5"]) device = @"iPad mini";
    else if ([platform isEqualToString:@"iPad2,6"]) device = @"iPad mini";
    else if ([platform isEqualToString:@"iPad2,7"]) device = @"iPad mini";
    else if ([platform isEqualToString:@"iPad4,4"]) device = @"iPad mini 2";
    else if ([platform isEqualToString:@"iPad4,5"]) device = @"iPad mini 2";
    else if ([platform isEqualToString:@"iPad4,6"]) device = @"iPad mini 2";
    else if ([platform isEqualToString:@"iPad4,7"]) device = @"iPad mini 3";
    else if ([platform isEqualToString:@"iPad4,8"]) device = @"iPad mini 3";
    else if ([platform isEqualToString:@"iPad4,9"]) device = @"iPad mini 3";
    
    else device = platform;

    return device;
}

+ (NSString *)getDeviceOSVersion {
    UIDevice *device_=[[UIDevice alloc] init];
    /*
    NSLog(@"设备所有者的名称－－%@",device_.name);
    NSLog(@"设备的类别－－－－－%@",device_.model);
    NSLog(@"设备的的本地化版本－%@",device_.localizedModel);
    NSLog(@"设备运行的系统－－－%@",device_.systemName);
    NSLog(@"当前系统的版本－－－%@",device_.systemVersion);
    NSLog(@"设备识别码－－－－－%@",device_.identifierForVendor.UUIDString);
     */
    return device_.systemVersion;
}

+ (NSString *)getScreenSize {
    
    NSString *device = [self getDeviceModel];
    
    NSString *screenSize;
    if ([device isEqualToString:@"iPhone Simulator"]) screenSize = @"Unlimited";
    else if ([device isEqualToString:@"iPhone 3GS"]) screenSize = @"320x480";
    else if ([device isEqualToString:@"iPhone 4"] || [device isEqualToString:@"iPhone 4S"] || [device isEqualToString:@"iPod touch 4"] || [device isEqualToString:@"iPad 2"] || [device isEqualToString:@"iPad 2 rev_a"] || [device isEqualToString:@"iPad 3"] || [device isEqualToString:@"iPad mini"] || [device isEqualToString:@"iPad 4"] || [device isEqualToString:@"iPad mini 2"] || [device isEqualToString:@"iPad Air"] || [device isEqualToString:@"iPad Air 2"] || [device isEqualToString:@"iPad mini 3"]) screenSize = @"640x960";
    else if ([device isEqualToString:@"iPhone 5"] || [device isEqualToString:@"iPhone 5c"] || [device isEqualToString:@"iPhone 5s"] || [device isEqualToString:@"iPod touch 5"]) screenSize = @"640x1136";
    else if ([device isEqualToString:@"iPhone 6"]) screenSize = @"750x1334";
    else if ([device isEqualToString:@"iPhone 6 Plus"]) screenSize = @"1080x1920";
    else screenSize = @"Unknown";

    return screenSize;
}

+ (float)getOSVersionFloat {
    NSString *version = [self getDeviceOSVersion];
    return version.floatValue;
}

+ (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
