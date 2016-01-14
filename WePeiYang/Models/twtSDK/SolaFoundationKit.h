//
//  SolaFoundationKit.h
//  Sola
//
//  Created by Qin Yubo on 15/10/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SolaFoundationKit : NSObject

+ (UIViewController *)topViewController;
+ (NSString *)appName;
+ (NSString *)appVersion;
+ (NSString *)appBuild;
+ (NSString *)deviceModel;
+ (NSString *)deviceOSVersion;
+ (NSString *)userAgentString;

@end
