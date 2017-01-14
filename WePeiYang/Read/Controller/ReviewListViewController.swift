//
//  ReviewListViewController.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/23.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import UIKit

class ReviewListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reviewArr: [Review] = []
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height) , style: .Grouped)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleLabel = UILabel(text: "我的评论", fontSize: 17)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = titleLabel;
        
        //NavigationBar 的背景，使用了View
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
        
        bgView.backgroundColor = UIColor(colorLiteralRed: 234.0/255.0, green: 74.0/255.0, blue: 70/255.0, alpha: 1.0)
        self.view.addSubview(bgView)
        
        //        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        if self.reviewArr.count == 0 {
            let label = UILabel(text: "你还没有点评哦，去评论吧！")
            label.sizeToFit()
            self.view.addSubview(label)
            label.snp_makeConstraints { make in
                make.center.equalTo(self.view.snp_center)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add TableView
        view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .None

    }
    
    // Mark: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ReviewCell(model: self.reviewArr[indexPath.row])
        if indexPath.row == reviewArr.count - 1 {
            cell.separator.removeFromSuperview()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = BookDetailViewController(bookID: "\(reviewArr[indexPath.row].bookID)")
        self.navigationController?.pushViewController(vc, animated: true)
        print("Push Detail View Controller, bookID: \(reviewArr[indexPath.row].bookID)")
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}