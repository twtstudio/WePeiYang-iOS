//
//  RecommendedViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class RecommendedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    let tableView = UITableView(frame: CGRect(x: 0, y: 108, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height) , style: .Grouped)
    let sectionList = ["热门推荐", "热门书评", "阅读之星"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI() {
        
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
    }
    
    
    //Table DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = RecommendCell(a: 1)
            return cell
        case 2:
            let cell = ReadStarCell(a: 1)
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 200
//        case 2:
//            return 160
//        default:
//            return 0
//        }
//    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            
//        } else {
//            return nil
//        }
        return nil
    }
    
    //Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
