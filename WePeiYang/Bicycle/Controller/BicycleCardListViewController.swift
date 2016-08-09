//
//  BicycleCardListViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class BicycleCardListViewController: UITableViewController, UIAlertViewDelegate {
    
    var choosenRow: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BicycleUser.sharedInstance.cradList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        }
        
        cell?.contentView.frame.size.height = 64
        cell?.textLabel?.text = "卡号：\(BicycleUser.sharedInstance.cradList[indexPath.row].id!)"
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        choosenRow = indexPath.row
        
        let alert = UIAlertView(title: "提示", message: "确定绑定此卡？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        
        alert.show()
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        let choosenCard = BicycleUser.sharedInstance.cradList[choosenRow];
        
        //坑：应该要先判断是哪个 alertView
        guard buttonIndex != alertView.cancelButtonIndex else {
            return
        }
        
        BicycleUser.sharedInstance.bindCard(choosenCard.id!, sign: choosenCard.sign!, doSomething: {
            
            //pop 到BicycleServiceViewController
            self.navigationController?.popViewControllerAnimated(true)
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
}