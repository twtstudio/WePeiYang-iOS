//
//  LostFoundTableViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/3/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

class LostFoundTableViewController: UITableViewController {
    
    var type: Int = 0
    private var currentPage: Int = 1
    private var dataArr: NSMutableArray = []
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: "LostFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "lfIdentifier")
        
        if self.navigationController?.navigationBar.translucent == true {
            self.automaticallyAdjustsScrollViewInsets = false
            var insets = self.tableView.contentInset
            insets.top = (self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height + CGFloat(MENU_VIEW_HEIGHT)
            insets.bottom = 49
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        }
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData()
        })
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.nextPage()
        })
        self.tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func refreshData() {
        currentPage = 1
        self.fetchData()
    }
    
    private func nextPage() {
        currentPage = currentPage + 1
        self.fetchData()
    }
    
    private func fetchData() {
        twtSDK.getLostFoundListWithType(type, page: currentPage, success: {task, responseObj in
            let responseData = JSON(responseObj)
            if self.currentPage == 1 {
                self.dataArr.removeAllObjects()
                self.dataArr = LostFoundItem.mj_objectArrayWithKeyValuesArray(responseData["data"].object)
            } else {
                self.dataArr.addObjectsFromArray(LostFoundItem.mj_objectArrayWithKeyValuesArray(responseData["data"].object) as [AnyObject])
            }
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }, failure: {task, error in
            MsgDisplay.showErrorMsg(error.localizedDescription)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lfIdentifier", forIndexPath: indexPath) as! LostFoundTableViewCell
        cell.setLostFoundItem(dataArr[indexPath.row] as! LostFoundItem, type: type)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let tmp = dataArr[row] as! LostFoundItem
        let lfDetailVC = LostFoundDetailViewController(style: .Grouped)
        lfDetailVC.index = tmp.index
        lfDetailVC.type = "\(type)"
        self.navigationController?.showViewController(lfDetailVC, sender: nil)
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
