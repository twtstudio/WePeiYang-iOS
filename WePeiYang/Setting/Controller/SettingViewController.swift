//
//  SettingViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/11.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import LocalAuthentication
import BlocksKit
import CoreSpotlight

class SettingViewController: UITableViewController {
    
    // 用 map 来定义需要计算的全局变量
    var appVer: String {
        return wpyDeviceStatus.getAppVersion()
    }
    var appBuild: String {
        return wpyDeviceStatus.getAppBuild()
    }
    var titleArr = ["账号", "设置", "关于"]
    var footerArr: [String] {
        return ["", "允许 Spotlight 索引后，您可以在主屏幕搜索页里搜索您的成绩信息。", "微北洋 \(appVer) Build \(appBuild)"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.clearsSelectionOnViewWillAppear = true
        self.title = "设置"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func loginOrLogout() {
        if AccountManager.tokenExists() {
            let alert = UIAlertController(title: "注销", message: "确定要注销吗？", preferredStyle: .ActionSheet)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Destructive, handler: {action in
                AccountManager.removeToken()
                wpyCacheManager.removeCacheDataForKey(GPA_CACHE)
                wpyCacheManager.removeCacheDataForKey(GPA_USER_NAME_CACHE)
                MsgDisplay.showSuccessMsg("注销成功！")
                self.tableView.reloadData()
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.modalPresentationStyle = .Popover
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Any
            alert.popoverPresentationController?.sourceView = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            alert.popoverPresentationController?.sourceRect = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!.bounds
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let loginVC = LoginViewController(nibName: nil, bundle: nil)
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "reuseIdentifier")
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            switch row {
            case 0:
                cell.textLabel?.text = AccountManager.tokenExists() ? "注销" : "登录"
            default:
                break
            }
        case 1:
            switch row {
            case 0:
                cell.textLabel?.text = "使用 Touch ID"
                let TOUCH_ID_KEY = "touchIdEnabled"
                let touchIDSwitch = UISwitch()
                let defaults = NSUserDefaults()
                touchIDSwitch.on = defaults.boolForKey(TOUCH_ID_KEY)
                touchIDSwitch.bk_addEventHandler({handler in
                    if touchIDSwitch.on == false {
                        // 关闭touchID，需要验证
                        let authContext = LAContext()
                        var error: NSError?
                        guard authContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
                            MsgDisplay.showErrorMsg("您的设备不支持 Touch ID")
                            touchIDSwitch.setOn(false, animated: true)
                            defaults.setBool(false, forKey: TOUCH_ID_KEY)
                            return
                        }
                        authContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "改变Touch ID相关设置须验证您的指纹", reply: {(success, error) in
                            if success {
                                defaults.setBool(false, forKey: TOUCH_ID_KEY)
                            } else {
                                // 注意：TouchID之后的UI操作放在主线程
                                dispatch_async(dispatch_get_main_queue(), {
                                    touchIDSwitch.setOn(true, animated: true)
                                })
                                defaults.setBool(true, forKey: TOUCH_ID_KEY)
                            }
                        })
                    } else {
                        // 打开touchID，不需要验证
                        let authContext = LAContext()
                        var error: NSError?
                        guard authContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
                            MsgDisplay.showErrorMsg("您的设备不支持 Touch ID")
                            touchIDSwitch.setOn(false, animated: true)
                            return
                        }
                        defaults.setBool(true, forKey: TOUCH_ID_KEY)
                    }
                }, forControlEvents: .ValueChanged)
                cell.accessoryView = touchIDSwitch
                cell.selectionStyle = .None
            case 1:
                cell.textLabel?.text = "允许 Spotlight 索引"
                let ALLOW_SPOTLIGHT_KEY = "allowSpotlightIndex"
                let spotlightSwitch = UISwitch()
                let defaults = NSUserDefaults()
                if defaults.objectForKey(ALLOW_SPOTLIGHT_KEY) == nil {
                    if #available(iOS 9.0, *) {
                        defaults.setBool(true, forKey: ALLOW_SPOTLIGHT_KEY)
                    } else {
                        defaults.setBool(false, forKey: ALLOW_SPOTLIGHT_KEY)
                    }
                }
                spotlightSwitch.on = defaults.boolForKey(ALLOW_SPOTLIGHT_KEY)
                spotlightSwitch.bk_addEventHandler({handler in
                    if #available(iOS 9.0, *) {
                        if spotlightSwitch.on == false {
                            // 关闭
                            CSSearchableIndex.defaultSearchableIndex().deleteAllSearchableItemsWithCompletionHandler({error in
                                if (error != nil) {
                                   print(error)
                                }
                            })
                            defaults.setBool(false, forKey: ALLOW_SPOTLIGHT_KEY)
                        } else {
                            defaults.setBool(true, forKey: ALLOW_SPOTLIGHT_KEY)
                        }
                    } else {
                        // Fallback on earlier versions
                        MsgDisplay.showErrorMsg("您的 iOS 版本不支持 Spotlight 索引\n请升级至最新版本")
                    }
                }, forControlEvents: .ValueChanged)
                cell.accessoryView = spotlightSwitch
                cell.selectionStyle = .None
            default:
                break
            }
        case 2:
            switch row {
            case 0:
                cell.textLabel?.text = "关于微北洋"
                cell.accessoryType = .DisclosureIndicator
            case 1:
                cell.textLabel?.text = "反馈"
                cell.accessoryType = .DisclosureIndicator
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleArr[section]
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerArr[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            switch row {
            case 0:
                self.loginOrLogout()
            default:
                break
            }
        case 1:
            break
        case 2:
            switch row {
            case 0:
                break
            case 1:
                let feedbackVC = FeedbackViewController(style: .Grouped)
                self.navigationController?.showViewController(feedbackVC, sender: nil)
            default:
                break
            }
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
