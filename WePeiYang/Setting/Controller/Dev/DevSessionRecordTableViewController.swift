//
//  DevSessionRecordTableViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/6/2.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class DevSessionRecordTableViewController: UITableViewController {
    
    var dataArr: [DevSessionRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "Session 记录"
        dataArr = DevSessionRecorder.allSessionRecords()
        self.tableView.reloadData()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 68.0
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArr.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "reuseIdentifier")
        }
        let record = dataArr[indexPath.row]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        cell!.textLabel?.text = record.url
        cell!.textLabel?.numberOfLines = 0
        cell!.detailTextLabel?.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(record.id!)))
        cell!.accessoryType = .DisclosureIndicator
        return cell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            for tmpIndexPath in [indexPath] {
                DevSessionRecorder.removeSessionRecord(dataArr[tmpIndexPath.row])
                dataArr.removeAtIndex(tmpIndexPath.row)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let devSessionViewController = DevSessionViewController(nibName: nil, bundle: nil)
        devSessionViewController.sessionRecord = dataArr[indexPath.row]
        self.navigationController?.showViewController(devSessionViewController, sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

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
