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
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "dashboard_bg.png")!)
        self.navigationController?.navigationBarHidden = true
        
        self.checkGuideStatus()
        self.checkLoginStatus()
        
        //INSTANCES
        
        let iconWidth = 80 as CGFloat
        let iconHeight = 120 as CGFloat
        
        let iconLineDistance = 30 as CGFloat //行距
        let iconRowDistance = 20 as CGFloat //列距
        
        //Draw UI
        
        //Line 1
        
        let studySearchBtn = UIButton.buttonWithType(.Custom) as UIButton
        studySearchBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance), 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance), iconWidth, iconHeight)
        studySearchBtn.setImage(UIImage(named: "studysearch.png"), forState: .Normal)
        studySearchBtn.addTarget(self, action: "pushStudySearch", forControlEvents: .TouchUpInside)
        self.view.addSubview(studySearchBtn)
        
        let newsBtn = UIButton.buttonWithType(.Custom) as UIButton
        newsBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+iconWidth+iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance), iconWidth, iconHeight)
        newsBtn.setImage(UIImage(named: "news.png"), forState: .Normal)
        newsBtn.addTarget(self, action: "pushNews", forControlEvents: .TouchUpInside)
        self.view.addSubview(newsBtn)
        
        let noticeBtn = UIButton.buttonWithType(.Custom) as UIButton
        noticeBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+2*iconWidth+2*iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance), iconWidth, iconHeight)
        noticeBtn.setImage(UIImage(named: "notice.png"), forState: .Normal)
        noticeBtn.addTarget(self, action: "pushNotice", forControlEvents: .TouchUpInside)
        self.view.addSubview(noticeBtn)
        
        //Line 2
        
        let gpaBtn = UIButton.buttonWithType(.Custom) as UIButton
        gpaBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance), 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+iconHeight+iconLineDistance, iconWidth, iconHeight)
        gpaBtn.setImage(UIImage(named: "gpa.png"), forState: .Normal)
        gpaBtn.addTarget(self, action: "authGPA", forControlEvents: .TouchUpInside)
        self.view.addSubview(gpaBtn)
        
        let libBtn = UIButton.buttonWithType(.Custom) as UIButton
        libBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+iconWidth+iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+iconHeight+iconLineDistance, iconWidth, iconHeight)
        libBtn.setImage(UIImage(named: "library.png"), forState: .Normal)
        libBtn.addTarget(self, action: "pushLibrary", forControlEvents: .TouchUpInside)
        self.view.addSubview(libBtn)
        
        let jobsBtn = UIButton.buttonWithType(.Custom) as UIButton
        jobsBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+2*iconWidth+2*iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+iconHeight+iconLineDistance, iconWidth, iconHeight)
        jobsBtn.setImage(UIImage(named: "jobs.png"), forState: .Normal)
        jobsBtn.addTarget(self, action: "pushJobs", forControlEvents: .TouchUpInside)
        self.view.addSubview(jobsBtn)
        
        //Line 3
        
        let lafBtn = UIButton.buttonWithType(.Custom) as UIButton
        lafBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance), 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+2*iconHeight+2*iconLineDistance, iconWidth, iconHeight)
        lafBtn.setImage(UIImage(named:"laf.png"), forState: .Normal)
        lafBtn.addTarget(self, action: "pushLAF", forControlEvents: .TouchUpInside)
        self.view.addSubview(lafBtn)
        
        let aboutBtn = UIButton.buttonWithType(.Custom) as UIButton
        aboutBtn.frame = CGRectMake(0.5*(deviceWidth-3*iconWidth-2*iconRowDistance)+iconWidth+iconRowDistance, 0.5*(deviceHeight-3*iconHeight-2*iconLineDistance)+2*iconHeight+2*iconLineDistance, iconWidth, iconHeight)
        aboutBtn.setImage(UIImage(named:"about.png"), forState: .Normal)
        aboutBtn.addTarget(self, action: "pushAbout", forControlEvents: .TouchUpInside)
        self.view.addSubview(aboutBtn)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let LAFVC = LAFound_QueryListViewController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(LAFVC, animated: true)
    }
    
    func pushAbout() {
        let aboutVC = AboutViewController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(aboutVC, animated: true)
    }
    
    // Loading user id & token
    
    func checkGuideStatus() {
        let path:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = path[0] as String
        let plistPath = documentPath.stringByAppendingPathComponent("guide1.2.0Loaded")
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(plistPath) {
            fileManager.createFileAtPath(plistPath, contents: nil, attributes: nil)
            let guide = GuideViewController()
            self.presentViewController(guide, animated: true, completion: nil)
        }
    }
    
    func checkLoginStatus() {
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
    
   
}
