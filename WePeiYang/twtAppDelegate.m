//
//  twtAppDelegate.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-11-28.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "twtAppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "StartViewController.h"
#import "data.h"
#import "ReceivedNotificationViewController.h"
#import "DMSlideTransition.h"
#import "twtSecretKeys.h"
#import "RavenClient.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@implementation twtAppDelegate

{
    UIAlertView *pushAlert;
}

@synthesize slideTrans;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Configure the Sentry client
    [RavenClient clientWithDSN:@"http://4bdecbe73bac4899acd3f0cbf9e55b91:59f4ecc64de94659acbb88422e64494e@sentry-ops.twtapps.net/5"];
    
    // Install the global error handler
    [[RavenClient sharedClient] setupExceptionHandler];
    
    //ShareSDK appKey
    [ShareSDK registerApp:[twtSecretKeys getShareSDKAppKey]];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:[twtSecretKeys getWeiboAppKey]
                               appSecret:[twtSecretKeys getWeiboAppSecret]
                             redirectUri:@"http://mobile.twt.edu.cn"];
    
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:[twtSecretKeys getTencentWeiboAppKey]
                                  appSecret:[twtSecretKeys getTencentWeiboAppSecret]
                                redirectUri:@"http://mobile.twt.edu.cn"];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:[twtSecretKeys getQZoneAppKey]
                           appSecret:[twtSecretKeys getQZoneAppSecret]];
     
    //添加人人网应用
    [ShareSDK connectRenRenWithAppKey:[twtSecretKeys getRenrenAppKey]
                            appSecret:[twtSecretKeys getRenrenAppSecret]];
    
    //添加Facebook应用
    [ShareSDK connectFacebookWithAppKey:[twtSecretKeys getFacebookAppKey]
                              appSecret:[twtSecretKeys getFacebookAppSecret]];
    
    //添加Twitter应用
    [ShareSDK connectTwitterWithConsumerKey:[twtSecretKeys getTwitterConsumerKey]
                             consumerSecret:[twtSecretKeys getTwitterConsumerSecret]
                                redirectUri:@"http://mobile.twt.edu.cn"];
    
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:[twtSecretKeys getWechatAppId]        //此参数为申请的微信AppID
                           wechatCls:[WXApi class]];
    
    //添加QQ应用
    [ShareSDK connectQQWithQZoneAppKey:[twtSecretKeys getQQWithQZoneAppKey]                 //该参数填入申请的QQ AppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //……
    

    
    StartViewController *start = [[StartViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:start];
    
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];
    
    //Remote Notification
    UIRemoteNotificationType types = (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    
    //这里是当App未在运行时收到通知后的处理方式
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        NSString *pushMsg = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
        NSString *pushId = [[userInfo objectForKey:@"aps"]objectForKey:@"id"];
        [data shareInstance].pushMsg = pushMsg;
        [data shareInstance].pushId = pushId;
        [data shareInstance].newsTitle = [data shareInstance].pushMsg;
        [data shareInstance].newsId = [data shareInstance].pushId;
        ReceivedNotificationViewController *receivedNotificationViewController = [[ReceivedNotificationViewController alloc]initWithNibName:nil bundle:nil];
        slideTrans = [[DMSlideTransition alloc]init];
        [receivedNotificationViewController setTransitioningDelegate:slideTrans];
        [self.window.rootViewController presentViewController:receivedNotificationViewController animated:YES completion:nil];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
    }
    
    return YES;
}

//Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"apns -> devToken:%@",token);
    [data shareInstance].deviceToken = token;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"apns -> Register failed:%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"apns -> Msg:%@",[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]);
    NSLog(@"apns -> Id:%@",[[userInfo objectForKey:@"aps"]objectForKey:@"id"]);
    [data shareInstance].pushId = [[userInfo objectForKey:@"aps"] objectForKey:@"id"];
    [data shareInstance].pushMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    pushAlert = [[UIAlertView alloc]initWithTitle:@"新消息" message:[NSString stringWithFormat:@"%@",[data shareInstance].pushMsg] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
    [pushAlert show];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}

//Notifications End Here

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == pushAlert)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            [data shareInstance].newsTitle = [data shareInstance].pushMsg;
            [data shareInstance].newsId = [data shareInstance].pushId;
            ReceivedNotificationViewController *receivedNotificationViewController = [[ReceivedNotificationViewController alloc]initWithNibName:nil bundle:nil];
            DMSlideTransition *trans = [[DMSlideTransition alloc]init];
            [receivedNotificationViewController setTransitioningDelegate:trans];
            [self.window.rootViewController presentViewController:receivedNotificationViewController animated:YES completion:nil];
        }
    }
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 关于后台挂起

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeFloat:2.0 forKey:@"Version"];
}

- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder
{
    float lastVer = [coder decodeFloatForKey:@"Version"];
    NSLog(@"lastVer = %f",lastVer);
}

@end
