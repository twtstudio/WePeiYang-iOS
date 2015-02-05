//
//  DashboardViewController.swift
//  WePeiYang
//
//  Created by 秦昱博 on 14/9/14.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit
import LocalAuthentication

class DashboardViewController: UIViewController {
    
    var studySearchBtn: UIButton!
    var newsBtn: UIButton!
    var noticeBtn: UIButton!
    var gpaBtn: UIButton!
    var libBtn: UIButton!
    var jobsBtn: UIButton!
    var lafBtn: UIButton!
    var aboutBtn: UIButton!
    
    var buttonArr = Array<UIButton>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let infoDic:NSDictionary = NSBundle.mainBundle().infoDictionary!
        let appVersion:NSString = infoDic["CFBundleShortVersionString"] as NSString
        data.shareInstance().appVersion = appVersion
        data.shareInstance().deviceWidth = self.view.frame.size.width
        let deviceWidth = self.view.frame.size.width
        let deviceHeight = self.view.frame.size.height

        println(deviceWidth)
        println(deviceHeight)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true
        
        self.checkGuideStatus()
        self.checkLoginStatus()
        
        //INSTANCES
        
        let iconWidth = 72 as CGFloat
        let iconHeight = 108 as CGFloat
        
        let iconLineDistance = 24 as CGFloat //行距
        let iconRowDistance = 24 as CGFloat //列距
        
        
        // Draw background
        
        let bgPath = NSBundle.mainBundle().pathForResource("dashboardBg@2x", ofType: "jpg")
        let bgImgView = UIImageView(frame: UIScreen.mainScreen().bounds)
        bgImgView.image = UIImage(contentsOfFile: bgPath!)
        self.view.addSubview(bgImgView)
        
        let iconView = UIView(frame: UIScreen.mainScreen().bounds)
        
        //Draw UI
        
        //Line 1
        
        studySearchBtn = UIButton.buttonWithType(.Custom) as UIButton
        studySearchBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance), 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance), iconWidth, iconHeight)
        studySearchBtn.setImage(UIImage(named: "studysearch.png"), forState: .Normal)
        studySearchBtn.addTarget(self, action: "pushStudySearch", forControlEvents: .TouchUpInside)
        studySearchBtn.hidden = true
        iconView.addSubview(studySearchBtn)
        
        newsBtn = UIButton.buttonWithType(.Custom) as UIButton
        newsBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+iconWidth+iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance), iconWidth, iconHeight)
        newsBtn.setImage(UIImage(named: "news.png"), forState: .Normal)
        newsBtn.addTarget(self, action: "pushNews", forControlEvents: .TouchUpInside)
        newsBtn.hidden = true
        iconView.addSubview(newsBtn)
        
        noticeBtn = UIButton.buttonWithType(.Custom) as UIButton
        noticeBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+2*iconWidth+2*iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance), iconWidth, iconHeight)
        noticeBtn.setImage(UIImage(named: "notice.png"), forState: .Normal)
        noticeBtn.addTarget(self, action: "pushNotice", forControlEvents: .TouchUpInside)
        noticeBtn.hidden = true
        iconView.addSubview(noticeBtn)
        
        //Line 2
        
        gpaBtn = UIButton.buttonWithType(.Custom) as UIButton
        gpaBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance), 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+iconHeight+iconLineDistance, iconWidth, iconHeight)
        gpaBtn.setImage(UIImage(named: "gpa.png"), forState: .Normal)
        gpaBtn.addTarget(self, action: "authGPA", forControlEvents: .TouchUpInside)
        gpaBtn.hidden = true
        iconView.addSubview(gpaBtn)
        
        libBtn = UIButton.buttonWithType(.Custom) as UIButton
        libBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+iconWidth+iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+iconHeight+iconLineDistance, iconWidth, iconHeight)
        libBtn.setImage(UIImage(named: "library.png"), forState: .Normal)
        libBtn.addTarget(self, action: "pushLibrary", forControlEvents: .TouchUpInside)
        libBtn.hidden = true
        iconView.addSubview(libBtn)
        
        jobsBtn = UIButton.buttonWithType(.Custom) as UIButton
        jobsBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+2*iconWidth+2*iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+iconHeight+iconLineDistance, iconWidth, iconHeight)
        jobsBtn.setImage(UIImage(named: "jobs.png"), forState: .Normal)
        jobsBtn.addTarget(self, action: "pushJobs", forControlEvents: .TouchUpInside)
        jobsBtn.hidden = true
        iconView.addSubview(jobsBtn)
        
        //Line 3
        
        lafBtn = UIButton.buttonWithType(.Custom) as UIButton
        lafBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance), 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+2*iconHeight+2*iconLineDistance, iconWidth, iconHeight)
        lafBtn.setImage(UIImage(named:"laf.png"), forState: .Normal)
        lafBtn.addTarget(self, action: "pushLAF", forControlEvents: .TouchUpInside)
        lafBtn.hidden = true
        iconView.addSubview(lafBtn)
        
        aboutBtn = UIButton.buttonWithType(.Custom) as UIButton
        aboutBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+iconWidth+iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+2*iconHeight+2*iconLineDistance, iconWidth, iconHeight)
        aboutBtn.setImage(UIImage(named:"about.png"), forState: .Normal)
        aboutBtn.addTarget(self, action: "pushAbout", forControlEvents: .TouchUpInside)
        aboutBtn.hidden = true
        iconView.addSubview(aboutBtn)
        
        iconView.alpha = 0.8
        
        buttonArr = [studySearchBtn, newsBtn, noticeBtn, gpaBtn, libBtn, jobsBtn, lafBtn, aboutBtn]
        
        self.view.addSubview(iconView)

        self.activeLaunchAnimations()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // POP Animation
    
    private func hideAllButtons() {
        
        studySearchBtn.hidden = true
        newsBtn.hidden = true
        noticeBtn.hidden = true
        gpaBtn.hidden = true
        libBtn.hidden = true
        jobsBtn.hidden = true
        lafBtn.hidden = true
        aboutBtn.hidden = true
    }
    
    private func activeLaunchAnimations() {
        
        // POP Animation
        
        let animSpringBounciness = 15.0 as CGFloat
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, block: {
            self.studySearchBtn.hidden = false
            
            var anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim.fromValue = NSValue(CGSize: CGSizeMake(0.0, 0.0))
            anim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
            anim.springBounciness = animSpringBounciness
            
            self.studySearchBtn.layer.pop_addAnimation(anim, forKey: "studySearchAnim")
        }, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.3, block: {
            self.newsBtn.hidden = false
            
            var anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim.fromValue = NSValue(CGSize: CGSizeMake(0.0, 0.0))
            anim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
            anim.springBounciness = animSpringBounciness
            
            self.newsBtn.layer.pop_addAnimation(anim, forKey: "newsAnim")
        }, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, block: {
            self.noticeBtn.hidden = false
            
            var anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim.fromValue = NSValue(CGSize: CGSizeMake(0.0, 0.0))
            anim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
            anim.springBounciness = animSpringBounciness
            
            self.noticeBtn.layer.pop_addAnimation(anim, forKey: "noticeAnim")
        }, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.2, block: {
            self.gpaBtn.hidden = false
            
            var anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim.fromValue = NSValue(CGSize: CGSizeMake(0.0, 0.0))
            anim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
            anim.springBounciness = animSpringBounciness
            
            self.gpaBtn.layer.pop_addAnimation(anim, forKey: "gpaAnim")
        }, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.4, block: {
            self.libBtn.hidden = false
            
            var anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim.fromValue = NSValue(CGSize: CGSizeMake(0.0, 0.0))
            anim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
            anim.springBounciness = animSpringBounciness
            
            self.libBtn.layer.pop_addAnimation(anim, forKey: "libAnim")
        }, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.6, block: {
            self.jobsBtn.hidden = false
            
            var anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim.fromValue = NSValue(CGSize: CGSizeMake(0.0, 0.0))
            anim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
            anim.springBounciness = animSpringBounciness
            
            self.jobsBtn.layer.pop_addAnimation(anim, forKey: "jobsAnim")
        }, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.3, block: {
            self.lafBtn.hidden = false
            
            var anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim.fromValue = NSValue(CGSize: CGSizeMake(0.0, 0.0))
            anim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
            anim.springBounciness = animSpringBounciness
            
            self.lafBtn.layer.pop_addAnimation(anim, forKey: "lafAnim")
        }, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, block: {
            self.aboutBtn.hidden = false
            
            var anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            anim.fromValue = NSValue(CGSize: CGSizeMake(0.0, 0.0))
            anim.toValue = NSValue(CGSize: CGSizeMake(1.0, 1.0))
            anim.springBounciness = animSpringBounciness
            
            self.aboutBtn.layer.pop_addAnimation(anim, forKey: "aboutAnim")
        }, repeats: false)
    }
    
    // WPY Push functions
    
    func pushStudySearch() {
        let studySearchVC = StudySearchViewController(nibName: "StudySearchViewController", bundle: nil)
        self.navigationController!.pushViewController(studySearchVC, animated: true)
    }
    
    func pushNews() {
        let newsVC = indexTabBarController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(newsVC, animated: true)
    }
    
    func pushNotice() {
        let noticeVC = NoticeViewController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(noticeVC, animated: true)
    }
    
    func pushLibrary() {
        let libraryVC = LibraryTabBarController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(libraryVC, animated: true)
    }
    
    func authGPA() {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var touchIdEnabled: AnyObject? = defaults.objectForKey("touchIdEnabled")
        
        if touchIdEnabled == nil {
            touchIdEnabled = false
        }
        
        if (touchIdEnabled as Bool) == true {
            var laContext = LAContext()
            var authError: NSError?
            var errorReason = "GPA这种东西怎么能随便给人看"
            //隐藏输入密码按钮
            laContext.localizedFallbackTitle = ""
            
            //第一层判断是否支持指纹识别
            if laContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError) {
                laContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: errorReason, reply: {
                    (BOOL success, NSError error) in
                    if success {
                        println("touch id success")
                        
                        //touch id 改变 UI 一定要从主线程
                        dispatch_async(dispatch_get_main_queue(), {
                            self.pushGPA()
                        })
                        
                    } else {
                        
                        if error.code == -1 {
                            dispatch_async(dispatch_get_main_queue(), {
                                var errorAlert = UIAlertView(title: "失败", message: "Touch ID 验证失败", delegate: self, cancelButtonTitle: "取消");
                                errorAlert.show()
                            })

                        } else if error.code == -2 {
                            //User Cancelled
                        }
                    }
                })
            } else {
                //不支持指纹识别的话
                self.pushGPA()
            }
            
        } else {
            self.pushGPA()
        }
        
    }
    
    func pushGPA() {
        let gpaVC = GPAViewController(nibName: "GPAViewController", bundle: nil)
        self.navigationController!.pushViewController(gpaVC, animated: true)
    }
    
    func pushJobs() {
        let jobsVC = JobTabBarController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(jobsVC, animated: true)
    }
    
    func pushLAF() {
        let LAFVC = LAFound_QueryListViewController()
        self.navigationController!.pushViewController(LAFVC, animated: true)
    }
    
    func pushAbout() {
        let aboutVC = AboutViewController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(aboutVC, animated: true)
    }
    
    // Loading user id & token
    
    private func checkGuideStatus() {
        
        let userDefaults = NSUserDefaults()
        let guideVersion = userDefaults.floatForKey("guideVersion")
        
        // 发布新版本Guide的时候一定要改下面的！
        
        if guideVersion < 1.3 {
            let guide = GuideViewController()
            self.presentViewController(guide, animated: true, completion: nil)
        }
    }
    
    private func checkLoginStatus() {
        let path:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = path[0] as String
        let plistPath = documentPath.stringByAppendingPathComponent("twtLogin")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(plistPath) {
            let savedData = NSData(contentsOfFile: plistPath)
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: savedData!)
            
            let secretId = unarchiver.decodeObjectForKey("id") as NSData
            let secretToken = unarchiver.decodeObjectForKey("token") as NSData
            unarchiver.finishDecoding()
            
            let key = twtSecretKeys.getSecretKey()
            let plainId = secretId.AES256DecryptWithKey(key)
            let plainToken = secretToken.AES256DecryptWithKey(key)
            
            let twtId = NSString(data: plainId, encoding: NSUTF8StringEncoding)
            let twtToken = NSString(data: plainToken, encoding: NSUTF8StringEncoding)
            
            data.shareInstance().userId = twtId
            data.shareInstance().userToken = twtToken
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
   
}
