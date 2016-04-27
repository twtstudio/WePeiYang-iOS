//
//  MicroservicesTableViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import AFNetworking
import MJRefresh
import SafariServices
import SwiftyJSON
import ObjectMapper

class MicroservicesTableViewController: UITableViewController {
    
    var dataArr: [WebAppItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "实验室"
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 65
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: "WebAppTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refresh()
        })
        self.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func refresh() {
        MsgDisplay.showLoading()
        SolaSessionManager.solaSessionWithSessionType(.GET, URL: "/microservices", token: nil, parameters: nil, success: {(task, responseObject) in
            let dic = JSON(responseObject)
            if dic["error_code"].int == -1 {
                self.dataArr = Mapper<WebAppItem>().mapArray(dic["data"].arrayObject)!
                // 约吧测试
                // self.dataArr.append(WebAppItem(name: "yueba", sites: "http://yueba.twtstudio.com", desc: "", iconURL: "", fullScreen: true))
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
            }
            MsgDisplay.dismiss()
        }, failure: {(task, error) in
            if let errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData {
                let errorJSON = JSON(errorResponse)
                MsgDisplay.showErrorMsg("获取数据失败\n\(errorJSON["message"])")
            } else {
                MsgDisplay.showErrorMsg("获取数据失败\n请稍后再试...")
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? WebAppTableViewCell
        let row = indexPath.row
        cell?.setObject(dataArr[row])
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let dataItem = dataArr[row]

        if dataItem.fullScreen {
            let webAppController = WebAppViewController(address: dataItem.sites)
            self.navigationController?.showViewController(webAppController, sender: nil)
        } else {
            let webViewController = wpyWebViewController(address: dataItem.sites)
            self.navigationController?.showViewController(webViewController, sender: nil)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
