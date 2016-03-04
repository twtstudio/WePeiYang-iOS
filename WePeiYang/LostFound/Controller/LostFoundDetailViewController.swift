//
//  LostFoundDetailViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms
import MJExtension

class LostFoundDetailViewController: UITableViewController, FXFormControllerDelegate {
    
    var formController: FXFormController!
    var type: String!
    var index: String!

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
        
        twtSDK.getLostFoundDetailWithID(index, success: {(task, responseObj) in
            let dic = responseObj as! [String: AnyObject]
            if dic["error_code"] as? Int == -1 {
                let lostFoundDetail = LostFoundDetail.mj_objectWithKeyValues(dic["data"])
                let form = LostFoundDetailForm()
                form.detailItem = lostFoundDetail
                self.formController.form = form
                self.tableView.reloadData()
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
