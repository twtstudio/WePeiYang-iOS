//
//  DevControlViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/5/8.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

let DEV_DISPLAY_DEV_WEB_APP = "DEV_DISPLAY_DEV_WEB_APP"
let DEV_MODE_PASSWORD_NOT_REQUIRED = "DEV_MODE_PASSWORD_NOT_REQUIRED"
let DEV_RECORD_SESSION_INFO = "DEV_RECORD_SESSION_INFO"

class DevControlViewController: UITableViewController {
    
    typealias DevSwitchOption = (key: String, description: String)
    let options: [DevSwitchOption] = [
        (DEV_DISPLAY_DEV_WEB_APP, "显示测试 Web App"),
        (TOUCH_ID_KEY, "复写 Touch ID 设置"),
        (DEV_MODE_PASSWORD_NOT_REQUIRED, "简化 DevKit 进入流程")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "DevKit"
        self.navigationController?.navigationBar.barStyle = .BlackTranslucent
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem().bk_initWithTitle("Back", style: .Plain, handler: { sender in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }) as? UIBarButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return options.count
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "调试选项"
        case 1:
            return "记录 Session"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        switch (indexPath.section, indexPath.row) {
        case (0, let row):
            cell!.textLabel?.text = options[row].description
            cell!.accessoryView = {
                let devSwitch = UISwitch()
                if NSUserDefaults().objectForKey(self.options[row].key) == nil {
                    NSUserDefaults().setBool(false, forKey: self.options[row].key)
                }
                devSwitch.on = NSUserDefaults().boolForKey(self.options[row].key)
                devSwitch.bk_addEventHandler({ handler in
                    NSUserDefaults().setBool(devSwitch.on, forKey: self.options[row].key)
                }, forControlEvents: .ValueChanged)
                return devSwitch
            }()
            cell!.selectionStyle = .None
        case (1, 0):
            cell!.textLabel?.text = "记录 Session 信息"
            cell!.accessoryView = {
                let devSwitch = UISwitch()
                if NSUserDefaults().objectForKey(DEV_RECORD_SESSION_INFO) == nil {
                    NSUserDefaults().setBool(false, forKey: DEV_RECORD_SESSION_INFO)
                }
                devSwitch.on = NSUserDefaults().boolForKey(DEV_RECORD_SESSION_INFO)
                devSwitch.bk_addEventHandler({ handler in
                    NSUserDefaults().setBool(devSwitch.on, forKey: DEV_RECORD_SESSION_INFO)
                    }, forControlEvents: .ValueChanged)
                return devSwitch
                }()
            cell!.selectionStyle = .None
        case (1, 1):
            cell?.textLabel?.text = "查看 Session 记录"
            cell?.accessoryType = .DisclosureIndicator
        default:
            break
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 1):
            let devSessionRecords = DevSessionRecordTableViewController(style: .Grouped)
            self.navigationController?.showViewController(devSessionRecords, sender: nil)
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
