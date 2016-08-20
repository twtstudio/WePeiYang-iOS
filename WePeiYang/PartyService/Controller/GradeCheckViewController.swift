//
//  GradeCheckViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class GradeCheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var testType: String?
    var gradeList = [NSDictionary]()
    
    /*convenience init(type: String) {
        self.init()
        testType = type
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("didload")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //TableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "identifier")
        }
        
        let dict = gradeList[indexPath.row]
        //print(dict)
        
        if testType == "probationary" {
            cell?.textLabel?.text = dict.objectForKey("train_name") as? String
        } else {
            cell?.textLabel?.text = dict.objectForKey("test_name") as? String
        }
        cell?.detailTextLabel?.text = "0000-00-00"
        
        
        //不想直接做字符串操作
        /*if let fooString = dict.objectForKey("entry_time") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.dateFromString(fooString as! String)
            print(date)
            cell?.detailTextLabel?.text = dateFormatter.stringFromDate(date!)
        }*/
        
        if let foo = dict.objectForKey("entry_time") as? String {
            cell?.detailTextLabel?.text = (foo as NSString).substringToIndex(10)
        }
        
        cell?.textLabel?.font = UIFont.boldSystemFontOfSize(13)
        cell?.detailTextLabel?.font = UIFont.boldSystemFontOfSize(13)
        //cell?.detailTextLabel?.textColor = UIColor.lightGrayColor()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, height: 40))
        
        let titleLabel = UILabel(text: "考试名称")
        let timeLabel = UILabel(text: "完成时间")
        
        titleLabel.font = UIFont.boldSystemFontOfSize(13.0)
        titleLabel.textColor = UIColor.lightGrayColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(13.0)
        timeLabel.textColor = UIColor.lightGrayColor()
        
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        
        timeLabel.snp_makeConstraints {
            make in
            make.right.equalTo(view).offset(-8)
            make.centerY.equalTo(view)
        }
        
        titleLabel.snp_makeConstraints {
            make in
            make.left.equalTo(view).offset(8)
            make.centerY.equalTo(view)
            
        }
        
        return view
        
    }
    
    //TableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = GradeDetailViewController()
        detailVC.index = indexPath.row
        detailVC.testType = testType
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    func refreshUI() {
        
        //TODO: 写成闭包
        if testType == "applicant" {
            gradeList = Applicant.sharedInstance.applicantGrade
        } else if testType == "academy" {
            gradeList = Applicant.sharedInstance.academyGrade
        } else if testType == "probationary" {
            gradeList = Applicant.sharedInstance.probationaryGrade
        }
        
        tableView.reloadData()
    }
    
    //因为暂时无法使用 init
    func fetchData() {
        Applicant.sharedInstance.getGrade(testType!, doSomething: {
            self.refreshUI()
        })
    }
}