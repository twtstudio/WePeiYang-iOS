//
//  BicycleServiceNotificationController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/7/11.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import MJRefresh

class BicycleServiceNotificationController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.refreshData()
        })
        
        //self.tableView.mj_header.beginRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshData() {
        NotificationList.sharedInstance.list.removeAll()
        NotificationList.sharedInstance.getList({
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
            NotificationList.sharedInstance.didGetNewNotification = false;
            self.tableView.mj_header.endRefreshing()
        })
    }
    
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationList.sharedInstance.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier")
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "identifier")
        }
        
        cell?.textLabel?.text = NotificationList.sharedInstance.list[indexPath.row].title
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cell?.detailTextLabel?.text = dateFormatter.stringFromDate(NotificationList.sharedInstance.list[indexPath.row].timeStamp)
        cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = BicycleNotificationDetailViewController(nibName: "BicycleNotificationDetailViewController", bundle: nil)
        detailVC.notificationTitle = NotificationList.sharedInstance.list[indexPath.row].title
        detailVC.notificationContent = NotificationList.sharedInstance.list[indexPath.row].content
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        detailVC.time = dateFormatter.stringFromDate(NotificationList.sharedInstance.list[indexPath.row].timeStamp)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}