//
//  SettingViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/11.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    // 用 map 来定义需要计算的全局变量
    var appVer: String {
        return wpyDeviceStatus.getAppVersion()
    }
    var appBuild: String {
        return wpyDeviceStatus.getAppBuild()
    }
    var titleArr = ["设置", "关于"]
    var footerArr: [String] {
        return ["", "微北洋 \(appVer) Build \(appBuild)"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.clearsSelectionOnViewWillAppear = true
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
    
    private func clearGPACacheWithFinishClosure(closure: () -> ()) {
        let alert = UIAlertController(title: "清除", message: "确定要清除吗", preferredStyle: .ActionSheet)
        let clearAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Destructive, handler: {action in
            wpyCacheManager.removeCacheDataForKey(GPA_USER_NAME_CACHE)
            wpyCacheManager.removeCacheDataForKey(GPA_CACHE)
            MsgDisplay.showSuccessMsg("Successful")
            closure()
        })
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Default, handler: {action in
            
        })
        alert.addAction(clearAction)
        alert.addAction(cancel)
        alert.modalPresentationStyle = .Popover
        alert.popoverPresentationController?.permittedArrowDirections = .Any
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.frame
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func loginGPAWithFinishCLosure(closure: () -> ()) {
        let alert = UIAlertController(title: "登录", message: "23333", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({textField in
            textField.placeholder = "ID"
        })
        alert.addTextFieldWithConfigurationHandler({textField in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: {action in
            let dic = [
                "username": alert.textFields![0].text!,
                "password": alert.textFields![1].text!
            ]
            wpyCacheManager.saveCacheData(dic, withKey: GPA_USER_NAME_CACHE)
            closure()
        })
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Default, handler: nil)
        alert.addAction(cancel)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
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
                cell.textLabel?.text = wpyCacheManager.cacheDataExistsWithKey(GPA_USER_NAME_CACHE) ? "注销 GPA 登录信息" : "登录办公网"
            default:
                break
            }
        case 1:
            switch row {
            case 0:
                cell.textLabel?.text = "关于"
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
            if (wpyCacheManager.cacheDataExistsWithKey(GPA_USER_NAME_CACHE)) {
                self.clearGPACacheWithFinishClosure({
                    self.tableView.reloadData()
                })
            } else {
                self.loginGPAWithFinishCLosure({
                    self.tableView.reloadData()
                })
            }
        case 1:
            switch row {
            case 0:
                break
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
