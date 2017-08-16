//
//  twtAppDelegate.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/19.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import LocalAuthentication

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
    
    var window: UIWindow?
    var specialEventsShouldShow = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let oldAgent = UIWebView().stringByEvaluatingJavaScriptFromString("navigator.userAgent")
        let newAgent = oldAgent! + " WePeiYang_iOS"
        NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent": newAgent])
        if NSUserDefaults.standardUserDefaults().objectForKey("eventsWatchedStatusCleared") == nil {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("eventsWatched")
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "eventsWatchedStatusCleared")
        }
        
        WXApi.registerApp(twtSecretKeys.getWechatAppId())
        
        twtSDK.setAppKey(twtSecretKeys.getTWTAppKey(), appSecret: twtSecretKeys.getTWTAppSecret())
        dispatch_async(dispatch_get_global_queue(0, 0), {
            if AccountManager.tokenExists() {
                AccountManager.tokenIsValid(nil, failure: { errorMsg in
                    MsgDisplay.showErrorMsg(errorMsg)
                })
            }
        })

        var performAdditioinalHandling = true
        if #available(iOS 9.0, *) {
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
                performAdditioinalHandling = false
            }
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        //GPA 界面后台模糊
        if UIViewController.currentViewController().isKindOfClass(GPATableViewController) && NSUserDefaults().boolForKey(BACKGROUND_BLUR_KEY) == true {
            let frostedView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
            frostedView.frame = (UIApplication.sharedApplication().keyWindow?.frame)!
            //            let blurView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Light)))
            //            blurView.frame = frostedView.frame
            
            UIApplication.sharedApplication().keyWindow?.addSubview(frostedView)
            //            frostedView.contentView.addSubview(blurView)
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let array = UIApplication.sharedApplication().keyWindow?.subviews
        for view in array! {
            if view.isKindOfClass(UIVisualEffectView) {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    
    //3D Touch on iPhone 6s or later
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {        
        // TODO: Check Login
        let navVC = (window?.rootViewController as? UITabBarController)?.viewControllers?.first as? UINavigationController
        switch shortcutItem.type {
        case "showYellowPage":
//            if let tabVC = window?.rootViewController as? UITabBarController {
//                let navVC = tabVC.viewControllers![0] as? UINavigationController
                let ypVC = YellowPageMainViewController()
                navVC?.pushViewController(ypVC, animated: true)
//            }
        case "showGPA":
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gpaVC = storyboard.instantiateViewControllerWithIdentifier("GPATableViewController") as! GPATableViewController
            gpaVC.hidesBottomBarWhenPushed = true
            
            if NSUserDefaults.standardUserDefaults().objectForKey("twtToken") == nil {
                let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                navVC?.presentViewController(loginVC, animated: true, completion: nil)
            }

            let userDefaults = NSUserDefaults()
            let touchIdEnabled = userDefaults.boolForKey("touchIdEnabled")
            if (touchIdEnabled) {
                let authContext = LAContext()
                var error: NSError?
                guard authContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
                    return
                }
                authContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "GPA这种东西才不给你看", reply: {(success, error) in
                    if success {
                        dispatch_async(dispatch_get_main_queue(), {
                            navVC?.showViewController(gpaVC, sender: nil)
                        })
                    } else {
                        MsgDisplay.showErrorMsg("指纹验证失败")
                    }
                })
            } else {
                navVC?.showViewController(gpaVC, sender: nil)
            }
        case "showBike":
            let bikeVC = BicycleServiceViewController()
            //log.word(NSUserDefaults.standardUserDefaults().objectForKey("twtToken") as! String)/
            
            if NSUserDefaults.standardUserDefaults().objectForKey("twtToken") == nil {
                let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                navVC?.presentViewController(loginVC, animated: true, completion: nil)
            } else {
                //坑：让后面能自动弹出要求绑定，但是做法不太科学，应改为 Notification
                BicycleUser.sharedInstance.bindCancel = false
                /*
                 if NSUserDefaults.standardUserDefaults().valueForKey("BicycleToken") != nil {
                 
                 let BicycleExpire = NSUserDefaults.standardUserDefaults().valueForKey("BicycleExpire") as? Int
                 let now = NSDate()
                 let timeInterval: NSTimeInterval = now.timeIntervalSince1970
                 let timeStamp = Int(timeInterval)
                 if timeStamp <= BicycleExpire {
                 //隐藏tabbar
                 bikeVC.hidesBottomBarWhenPushed = true;
                 self.navigationController?.showViewController(bikeVC, sender: nil)
                 } else {
                 BicycleUser.sharedInstance.auth({
                 //隐藏tabbar
                 bikeVC.hidesBottomBarWhenPushed = true;
                 self.navigationController?.showViewController(bikeVC, sender: nil)
                 })
                 }
                 
                 } else {
                 }*/
                BicycleUser.sharedInstance.auth({
                    //隐藏tabbar
                    bikeVC.hidesBottomBarWhenPushed = true;
                    navVC?.showViewController(bikeVC, sender: nil)
                })
            }
        default:
            return
        }
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
