//
//  AboutViewController.swift
//  WePeiYang
//
//  Created by 秦昱博 on 14/9/12.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {

    let aboutArr = ["关于我们","欢迎页面"];
    let webArr = ["抓取课程表","访问天外天网站"];
    let feedbackArr = ["发送反馈","联系我们"]
    
    var removeAlert:UIAlertView?
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController!.interactivePopGestureRecognizer.delegate = self
        
        UIButton.appearance().tintColor = UIColor.darkGrayColor()
        UITextView.appearance().tintColor = UIColor.darkGrayColor()
        UITextField.appearance().tintColor = UIColor.darkGrayColor()
        UINavigationBar.appearance().tintColor = UIColor.darkGrayColor()
        
        tableView = UITableView(frame: CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44), style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
        let navigationItem = UINavigationItem(title: "关于")
        
        let backIconPath:NSString! = NSBundle.mainBundle().pathForResource("backForNav@2x", ofType: "png")
        let backBarBtn = UIBarButtonItem(image: UIImage(contentsOfFile: backIconPath), style: UIBarButtonItemStyle.Plain, target: self, action: "backToHome")
        navigationBar.pushNavigationItem(navigationItem, animated: true)
        navigationItem.setLeftBarButtonItem(backBarBtn, animated: true)
        
        self.view.addSubview(tableView)
        self.view.addSubview(navigationBar)
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    //Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return aboutArr.count
        } else if section == 1 {
            return webArr.count
        } else if section == 2 {
            return feedbackArr.count
        } else if section == 3 {
            return self.logFileExists() ? 3 : 1
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let simpleTableIdentifer = "SimpleTableCell"
        var cell = UITableViewCell(style: .Default, reuseIdentifier: simpleTableIdentifer)
        var row = indexPath.row
        var section = indexPath.section
        if section == 0 {
            cell.textLabel.text = aboutArr[row] as NSString
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else if section == 1 {
            cell.textLabel.text = webArr[row] as NSString
        } else if section == 2 {
            cell.textLabel.text = feedbackArr[row] as NSString
            if row == 0 {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
        } else if section == 3 {
            cell.accessoryType = UITableViewCellAccessoryType.None
            if self.logFileExists() {
                if row == 0 {
                    cell.textLabel.text = self.tjuBinded() ? "解除办公网账号绑定" : "绑定办公网账号"
                } else if row == 1 {
                    cell.textLabel.text = self.libBinded() ? "解除图书馆账号绑定" : "绑定图书馆账号"
                } else if row == 2 {
                    cell.textLabel.text = "注销天外天账号"
                }
            } else {
                cell.textLabel.text = "登录天外天账号"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var row = indexPath.row
        var section = indexPath.section
        if section == 0 {
            if row == 0 {
                self.pushAboutUS()
            } else if row == 1 {
                self.showGuide()
            }
        } else if section == 1 {
            if row == 0 {
                if wpyDeviceStatus.getOSVersionFloat() < 8.0 {
                    var alert = UIAlertView(title: "对不起！", message: "课程表扩展暂不支持 iOS 8.0 以下的设备_(:з」∠)_", delegate: self, cancelButtonTitle: "哦")
                    alert.show()
                } else {
                    self.getClassData()
                }
                //self.getClassData()
            } else if row == 1 {
                self.openTwtInSafari()
            }
        } else if section == 2 {
            if row == 0 {
                self.pushFeedback()
            } else if row == 1 {
                self.sendEmail()
            }
        } else if section == 3 {
            if self.logFileExists() {
                if row == 0 {
                    if self.tjuBinded() {
                        self.jbTju()
                    } else {
                        self.bindTju()
                    }
                } else if row == 1 {
                    if self.libBinded() {
                        self.jbLib()
                    } else {
                        self.bindLib()
                    }
                } else if row == 2 {
                    self.logout()
                }
            } else {
                self.login()
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "关于"
        case 1:
            return "更多"
        case 2:
            return "反馈"
        case 3:
            return "帐号管理"
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return nil
        case 2:
            return "非常希望您能够将您的宝贵意见告诉我们。\n您的建议是微北洋持续改进的动力。"
        default:
            return nil
        }
    }
    
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if alertView == removeAlert {
            if buttonIndex != alertView.cancelButtonIndex {
                self.logout()
            }
        }
    }
    
    func backToHome() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func logout() {
        let url = "http://push-mobile.twtapps.net/user/logout"
        let parameters = ["id":data.shareInstance().userId, "token":data.shareInstance().userToken, "platform":"ios", "version":data.shareInstance().appVersion]
        var manager = AFHTTPRequestOperationManager()
        manager.POST(url, parameters: parameters, success: {
            (AFHTTPRequestOperation operation, AnyObject responseObject) in
            SVProgressHUD.showSuccessWithStatus("注销成功")
        }, failure: {
            (AFHTTPRequestOperation operation, NSError error) in
            SVProgressHUD.showErrorWithStatus("注销失败")
        })
        
        data.shareInstance().userId = ""
        data.shareInstance().userToken = ""
        
        var fileManager = NSFileManager.defaultManager()
        let files = ["login","libraryCollectionData","gpa","gpaResult","collectionData","noticeFavData","jobFavData","noticeAccount","twtLogin","libraryRecordCache","gpaCacheData","bindLib","bindTju"]
        for fileName in files {
            let path:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentPath = path[0] as String
            let plistPath = documentPath.stringByAppendingPathComponent(fileName)
            fileManager.removeItemAtPath(plistPath, error: nil)
        }
        
        let userDefault = NSUserDefaults(suiteName: "group.WePeiYang")
        userDefault?.removeObjectForKey("Classtable")
        userDefault?.synchronize()
        
        self.tableView.reloadData()
    }
    
    func jbTju() {
        let url = "http://push-mobile.twtapps.net/user/unbindTju"
        let parameters = ["id":data.shareInstance().userId, "token":data.shareInstance().userToken, "platform":"ios", "version":data.shareInstance().appVersion]
        var manager = AFHTTPRequestOperationManager()
        manager.POST(url, parameters: parameters, success: {
            (AFHTTPRequestOperation operation, AnyObject responseObject) in
                SVProgressHUD.showSuccessWithStatus("解除绑定成功")
                let files = ["gpa","gpaResult","gpaCacheData","bindTju"]
                for fileName in files {
                    var fileManager = NSFileManager.defaultManager()
                    let path:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    let documentPath = path[0] as String
                    let plistPath = documentPath.stringByAppendingPathComponent(fileName)
                    fileManager.removeItemAtPath(plistPath, error: nil)
                }
                self.tableView.reloadData()
        }, failure: {
            (AFHTTPRequestOperation operation, NSError error) in
                SVProgressHUD.showErrorWithStatus("解除绑定失败")
        })
    }
    
    func jbLib() {
        let url = "http://push-mobile.twtapps.net/user/unbindLib"
        let parameters = ["id":data.shareInstance().userId, "token":data.shareInstance().userToken, "platform":"ios", "version":data.shareInstance().appVersion]
        var manager = AFHTTPRequestOperationManager()
        manager.POST(url, parameters: parameters, success: {
            (AFHTTPRequestOperation operation, AnyObject responseObject) in
            SVProgressHUD.showSuccessWithStatus("解除绑定成功")
            let files = ["login","libraryRecordCache","bindLib"]
            for fileName in files {
                var fileManager = NSFileManager.defaultManager()
                let path:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                let documentPath = path[0] as String
                let plistPath = documentPath.stringByAppendingPathComponent(fileName)
                fileManager.removeItemAtPath(plistPath, error: nil)
            }
            self.tableView.reloadData()
            }, failure: {
                (AFHTTPRequestOperation operation, NSError error) in
                SVProgressHUD.showErrorWithStatus("解除绑定失败")
        })
    }
    
    func bindTju() {
        let gpaLogin = GPALoginViewController(nibName: nil, bundle: nil)
        self.presentViewController(gpaLogin, animated: true, completion: nil)
    }
    
    func bindLib() {
        let libLogin = LoginViewController(nibName: nil, bundle: nil)
        self.presentViewController(libLogin, animated: true, completion: nil)
    }
    
    func login() {
        let twtLogin = twtLoginViewController(nibName: nil, bundle: nil)
        self.presentViewController(twtLogin, animated: true, completion: nil)
    }
    
    //当前状态检测
    
    func logFileExists() -> Bool {
        let path:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = path[0] as String
        let plistPath = documentPath.stringByAppendingPathComponent("twtLogin")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(plistPath) {
            return true
        } else {
            return false
        }
    }
    
    func libBinded() -> Bool {
        let path:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = path[0] as String
        let plistPath = documentPath.stringByAppendingPathComponent("bindLib")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(plistPath) {
            return true
        } else {
            return false
        }
    }
    
    func tjuBinded() -> Bool {
        let path:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = path[0] as String
        let plistPath = documentPath.stringByAppendingPathComponent("bindTju")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(plistPath) {
            return true
        } else {
            return false
        }
    }
    
    func joinUs() {
        let twtUrl = NSURL(string: "http://mobile.twt.edu.cn/apply.html")
        UIApplication.sharedApplication().openURL(twtUrl!)
    }
    
    func pushFeedback() {
        var fb = FeedbackViewController()
        self.navigationController!.pushViewController(fb, animated: true)
    }
    
    func openTwtInSafari() {
        let twtURL = NSURL(string: "http://www.twt.edu.cn")
        UIApplication.sharedApplication().openURL(twtURL!)
    }
    
    func pushAboutUS() {
        var aboutUS = AboutUSViewController()
        self.navigationController!.pushViewController(aboutUS, animated: true)
    }
    
    func sendEmail() {
        var mailClass: AnyClass! = NSClassFromString("MFMailComposeViewController");
        if mailClass != nil {
            if mailClass.canSendMail() {
                self.displayComposerSheet()
            }
        }
    }
    
    func displayComposerSheet() {
        var mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject("")
        mc.setToRecipients(["mobile@twtstudio.com"])
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showGuide() {
        var guide = GuideViewController()
        self.presentViewController(guide, animated: true, completion: nil)
    }
    
    func getClassData() {
        if self.logFileExists() {
            if self.tjuBinded() {
                SVProgressHUD.showWithStatus("正在加载...")
                
                // Here to add functions to get class data
                var manager = AFHTTPRequestOperationManager()
                let url = "http://push-mobile.twtapps.net/classtable"
                let parameters = ["id": data.shareInstance().userId, "token": data.shareInstance().userToken, "platform":"ios", "version":data.shareInstance().appVersion]
                manager.GET(url, parameters: parameters, success: {
                    (AFHTTPRequestOperation operation, AnyObject responseObj) in
                        SVProgressHUD.dismiss()
                        self.getStartTime()
                        self.saveCacheWithData(responseObj)
                    }, failure: {
                    (AFHTTPRequestOperation operation, NSError error) in
                        SVProgressHUD.dismiss()
                        var alert = UIAlertView(title: "失败", message: "抓取课程表失败_(:з」∠)_\n要么您试试重新登陆下？", delegate: self, cancelButtonTitle: "哦")
                        alert.show()
                })
                
            } else {
                SVProgressHUD.showErrorWithStatus("您尚未绑定办公网账号哦~\n请向下滑动菜单，点击【绑定办公网账号】~")
            }
        } else {
            SVProgressHUD.showErrorWithStatus("您尚未登录哦~\n请滑动菜单至最下方，点击【登录天外天账号】~")
        }
    }
    
    func saveCacheWithData(responseObject: AnyObject) {
        
        let userDefault = NSUserDefaults(suiteName: "group.WePeiYang")
        userDefault?.removeObjectForKey("Classtable")
        userDefault?.setObject(responseObject, forKey: "Classtable")
        userDefault?.synchronize()

        var alert = UIAlertView(title: "成功", message: "抓取课程表成功！", delegate: self, cancelButtonTitle: "哦")
        alert.show()
    }
    
    func getStartTime() {
        var manager = AFHTTPRequestOperationManager()
        let url = "http://push-mobile.twtapps.net/start"
        let parameters = ["platform":"ios", "version":data.shareInstance().appVersion]
        manager.GET(url, parameters: parameters, success: {
            (AFHTTPRequestOperation operation, AnyObject responseObj) in
                let userDefault = NSUserDefaults(suiteName: "group.WePeiYang")
                userDefault?.removeObjectForKey("StartTime")
                userDefault?.setObject(responseObj, forKey: "StartTime")
                userDefault?.synchronize()
            }, failure: {
            (AFHTTPRequestOperation operation, NSError error) in
        })
    }
    

}
