//
//  twtAppDelegate.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/19.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let oldAgent = UIWebView().stringByEvaluatingJavaScriptFromString("navigator.userAgent")
        let newAgent = oldAgent! + " WePeiYang_iOS"
        NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent": newAgent])
        
        WXApi.registerApp(twtSecretKeys.getWechatAppId())
        
        twtSDK.setAppKey(twtSecretKeys.getTWTAppKey(), appSecret: twtSecretKeys.getTWTAppSecret())
        dispatch_async(dispatch_get_global_queue(0, 0), {
            if AccountManager.tokenExists() {
                AccountManager.tokenIsValid(nil, failure: { errorMsg in
                    MsgDisplay.showErrorMsg(errorMsg)
                })
            }
        })
        
        //判断用户是否第一次启动新版本
        if self.window?.frame.size.height<1024 {
            let infoDic = NSBundle.mainBundle().infoDictionary
            let currentAppVersion = infoDic!["CFBundleShortVersionString"] as! String
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let appVersion = userDefaults.stringForKey("appVersion")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if appVersion == nil || appVersion != currentAppVersion {
                userDefaults.setValue(currentAppVersion, forKey: "appVersion")
                
                let guide = storyboard.instantiateViewControllerWithIdentifier("guide") as! UserGuideViewController
                self.window?.rootViewController = guide
            }
        }
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        //GPA 界面后台模糊
<<<<<<< HEAD
        if UIViewController.currentViewController().isKindOfClass(GPATableViewController){
            let frostedView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
            frostedView.frame = (UIApplication.sharedApplication().keyWindow?.frame)!
            let blurView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Light)))
            blurView.frame = frostedView.frame
            
            UIApplication.sharedApplication().keyWindow?.addSubview(frostedView)
            frostedView.contentView.addSubview(blurView)
=======
        if UIViewController.currentViewController().isKindOfClass(GPATableViewController) {
            let frostedView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
            frostedView.frame = (UIApplication.sharedApplication().keyWindow?.frame)!
//            let blurView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Light)))
//            blurView.frame = frostedView.frame
            
            UIApplication.sharedApplication().keyWindow?.addSubview(frostedView)
//            frostedView.contentView.addSubview(blurView)
>>>>>>> xnth97/master
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        let array = UIApplication.sharedApplication().keyWindow?.subviews
        for view in array! {
            if view.isKindOfClass(UIVisualEffectView) {
                view.removeFromSuperview()
            }
        }

        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if SchemeManager.handleURL(url) {
            return true
        } else {
            return WXApi.handleOpenURL(url, delegate: self)
        }
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
}