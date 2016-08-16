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
        print("didload")
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
        
        cell?.textLabel?.text = dict.objectForKey("test_name") as? String
        cell?.detailTextLabel?.text = dict.objectForKey("entry_time") as? String
        
        return cell!
    }
    
    //TableViewDataSource
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