//
//  LostFoundDetailViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms
import ObjectMapper
import SwiftyJSON

class LostFoundDetailViewController: UITableViewController, FXFormControllerDelegate {
    
    var formController: FXFormController!
    var type: String!
    var index: String!
    
    private var phoneNum = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == "0" {
            self.title = "丢失物品"
        } else {
            self.title = "捡到物品"
        }

        formController = FXFormController()
        formController.tableView = self.tableView
        formController.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem().bk_initWithImage(UIImage(named: "lf_phone"), style: .Plain, handler: { handler in
            if !self.phoneNum.isEmpty {
                let phoneNumber = Int(self.phoneNum)
                if phoneNumber != nil {
                    
                    let alert = UIAlertController(title: "呼叫", message: "", preferredStyle: .ActionSheet)
                    let callAction = UIAlertAction(title: "\(phoneNumber!)", style: .Destructive, handler: {handler in
                        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(self.phoneNum)")!)
                    })
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
                    alert.addAction(callAction)
                    alert.addAction(cancelAction)
                    alert.modalPresentationStyle = .Popover
                    alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                    alert.popoverPresentationController?.sourceView = self.view
                    alert.popoverPresentationController?.sourceRect = self.view.bounds
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
        }) as? UIBarButtonItem
        
        twtSDK.getLostFoundDetailWithID(index, success: {(task, responseObj) in
            let dic = JSON(responseObj)
            if dic["error_code"].int == -1 {
                if let lostFoundDetail = Mapper<LostFoundDetail>().map(dic["data"].object) {
                    self.phoneNum = lostFoundDetail.phone
                    let form = LostFoundDetailForm()
                    form.detailItem = lostFoundDetail
                    self.formController.form = form
                    self.tableView.reloadData()
                }
            }
        }, failure: {(task, error) in
            MsgDisplay.showErrorMsg(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

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
