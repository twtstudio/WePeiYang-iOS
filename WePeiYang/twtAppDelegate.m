//
//  twtAppDelegate.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-11-28.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "twtAppDelegate.h"
#import "data.h"
#import "twtSecretKeys.h"
#import "RavenClient.h"
#import "WePeiYang-Swift.h"
#import "TWTNavController.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@implementation twtAppDelegate

{
    UIAlertView *pushAlert;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Configure the Sentry client
    [RavenClient clientWithDSN:[twtSecretKeys getRavenKey]];
    
    // Install the global error handler
    [[RavenClient sharedClient] setupExceptionHandler];
    
    // Set NSURLCache
    NSURLCache *sharedCache = [[NSURLCache alloc]initWithMemoryCapacity:2 * 1024 * 1024 diskCapacity:30 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    DashboardViewController *dashboard = [[DashboardViewController alloc]init];
    // UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dashboard];
    TWTNavController *nav = [[TWTNavController alloc]initWithRootViewController:dashboard];
    
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];
    
    //Remote Notification
    /*
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
    }*/
    
    return YES;
}

//Notifications
/*
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"apns -> devToken:%@",token);
    //[data shareInstance].deviceToken = token;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"apns -> Register failed:%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"apns -> Msg:%@",[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]);
    NSLog(@"apns -> Id:%@",[[userInfo objectForKey:@"aps"]objectForKey:@"id"]);
    //[data shareInstance].pushId = [[userInfo objectForKey:@"aps"] objectForKey:@"id"];
    //[data shareInstance].pushMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    //pushAlert = [[UIAlertView alloc]initWithTitle:@"新消息" message:[NSString stringWithFormat:@"%@",[data shareInstance].pushMsg] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
    [pushAlert show];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}
*/
//Notifications End Here

/*
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == pushAlert)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            //[data shareInstance].newsTitle = [data shareInstance].pushMsg;
            //[data shareInstance].newsId = [data shareInstance].pushId;
            //ReceivedNotificationViewController *receivedNotificationViewController = [[ReceivedNotificationViewController alloc]initWithNibName:nil bundle:nil];
            //[receivedNotificationViewController setTransitioningDelegate:trans];
            //[self.window.rootViewController presentViewController:receivedNotificationViewController animated:YES completion:nil];
        }
    }
}
 */

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
