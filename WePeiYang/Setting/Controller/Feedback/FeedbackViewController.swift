//
//  FeedbackViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/17.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms
import BlocksKit
import AFNetworking
import SwiftyJSON

class FeedbackViewController: UITableViewController, FXFormControllerDelegate {
    
    var formController: FXFormController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "反馈"
        formController = FXFormController()
        formController.tableView = self.tableView
        formController.delegate = self
        formController.form = FeedbackForm()
        
        let doneBtn = UIBarButtonItem().bk_initWithTitle(NSLocalizedString("Send", comment: ""), style: .Plain, handler: {sender in
            let form = self.formController.form as! FeedbackForm
            let email = form.email == nil ? "" : form.email!
            if form.content == nil || form.content!.isEmpty {
                MsgDisplay.showErrorMsg("请输入反馈内容！")
            } else {
                let content = "\(form.content!) (WePeiyang \(form.appVersion), \(form.deviceModel), \(form.iosVersion))"
                self.postFeedbackContent(content, email: email)
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
    
    private func postFeedbackContent(content: String, email: String) {
        MsgDisplay.showLoading()
        SolaSessionManager.solaSessionWithSessionType(.GET, URL: "/app/feedback", token: nil, parameters: ["content": content, "email": email], success: {(task, responseObj) in
            let dic = JSON(responseObj)
            if dic["error_code"].int == -1 {
                MsgDisplay.showSuccessMsg("反馈发送成功！")
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                MsgDisplay.showErrorMsg("反馈发送失败！")
            }
        }, failure: {(task, error) in
            if let errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData {
                let errorJSON = JSON(errorResponse)
                MsgDisplay.showErrorMsg("反馈发送失败！\n\(errorJSON["message"].stringValue)")
            } else {
                MsgDisplay.showErrorMsg("反馈发送失败！")
            }
        })
    }

    // MARK: - Table view data source

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
