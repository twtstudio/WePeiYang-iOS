//
//  DashboardViewController.swift
//  WePeiYang
//
//  Created by 秦昱博 on 14/9/14.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let infoDic:NSDictionary = NSBundle.mainBundle().infoDictionary
        let appVersion:NSString = infoDic["CFBundleShortVersionString"] as NSString
        data.shareInstance().appVersion = appVersion
        data.shareInstance().deviceWidth = self.view.frame.size.width
        let deviceWidth = self.view.frame.size.width
        let deviceHeight = self.view.frame.size.height

        println(deviceWidth)
        println(deviceHeight)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "dashboard_bg.png"))
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
        gpaBtn.addTarget(self, action: "pushGPA", forControlEvents: .TouchUpInside)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushStudySearch() {
        let studySearchVC = YViewController(nibName: "YViewController", bundle: nil)
        self.navigationController!.pushViewController(studySearchVC, animated: true)
    }
    
    func pushNews() {
        let newsVC = indexTabBarController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(newsVC, animated: true)
    }
    
    func pushNotice() {
        let noticeVC = noticeTabBarController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(noticeVC, animated: true)
    }
    
    func pushLibrary() {
        let libraryVC = LibraryTabBarController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(libraryVC, animated: true)
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
        let LAFVC = LAFTabBarController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(LAFVC, animated: true)
    }
    
    func pushAbout() {
        let aboutVC = AboutViewController(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(aboutVC, animated: true)
    }
    
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
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: savedData)
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
