//
//  GradeDetailViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class GradeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var index: Int?
    
    let entryStatus = ["正常", "作弊", "违纪", "缺考"]
    let passStatus = ["不合格", "合格", "优秀"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let _ = index {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        }
        
        cell?.textLabel?.textColor = UIColor.lightGrayColor()
        cell?.textLabel?.font = UIFont.boldSystemFontOfSize(14.0)
        
        let dict = Applicant.sharedInstance.applicantGrade[index!]
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "姓名：\(Applicant.sharedInstance.realName!)"
        } else if indexPath.row == 1 {
            cell?.textLabel?.text = "学号：\(dict.objectForKey("sno") as! String)"
        } else if indexPath.row == 2 {
            cell?.textLabel?.text = "活动期数：\(dict.objectForKey("test_name") as! String)"
        } else if indexPath.row == 3 {
            cell?.textLabel?.text = "考试时间：\(dict.objectForKey("entry_time") as! String)"
        } else if indexPath.row == 4 {
            cell?.textLabel?.text = "笔试成绩：\(dict.objectForKey("entry_practicegrade") as! String)"
        } else if indexPath.row == 5 {
            cell?.textLabel?.text = "论文成绩：\(dict.objectForKey("entry_articlegrade") as! String)"
        } else if indexPath.row == 6 {
            cell?.textLabel?.text = "成绩状态：\(entryStatus[Int(dict.objectForKey("entry_status") as! String)!])"
        } else if indexPath.row == 4 {
            cell?.textLabel?.text = "考试状态：\(passStatus[Int(dict.objectForKey("entry_ispassed") as! String)!])"
        }
        
        return cell!
    }
}