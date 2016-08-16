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
    var gradeList = Applicant.sharedInstance.applicantGrade ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}