//
//  BindTjuViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms
import BlocksKit

let NOTIFICATION_BINDTJU_SUCCESSED = "NOTIFICATION_BINDTJU_SUCCESSED"
let NOTIFICATION_BINDTJU_CANCELLED = "NOTIFICATION_BINDTJU_CANCELLED"

class BindTjuViewController: UITableViewController, FXFormControllerDelegate {
    
    var formController: FXFormController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "绑定办公网"
        formController = FXFormController()
        formController.tableView = self.tableView
        formController.delegate = self
        formController.form = BindTjuForm()
        
        let cancelBtn = UIBarButtonItem().bk_initWithBarButtonSystemItem(.Cancel, handler: {sender in
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_BINDTJU_CANCELLED, object: nil)
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }) as! UIBarButtonItem
        self.navigationItem.leftBarButtonItem = cancelBtn
        
        let doneBtn = UIBarButtonItem().bk_initWithBarButtonSystemItem(.Done, handler: {sender in
            let form = self.formController.form as! BindTjuForm
            let username = form.username
            let password = form.password
            if username != nil && password != nil && username != "" && password != "" {
                MsgDisplay.showLoading()
                AccountManager.bindTjuAccountWithTjuUserName(username, password: password, success: {
                    MsgDisplay.showSuccessMsg("办公网账号绑定成功！")
                    NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_BINDTJU_SUCCESSED, object: nil)
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                }, failure: {errorMsg in
                    MsgDisplay.showErrorMsg(errorMsg)
                })
            } else {
                MsgDisplay.showErrorMsg("账号或密码不能为空")
            }
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = doneBtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
