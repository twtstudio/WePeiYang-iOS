//
//  ReviewListViewController.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/23.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import UIKit

class ReviewListViewController: UITableViewController {
    
    var reviewArr: [Review] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleLabel = UILabel(text: "我的评论", fontSize: 17)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = titleLabel;
        
        //NavigationBar 的背景，使用了View
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: -664, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height+600))
        
        bgView.backgroundColor = UIColor(colorLiteralRed: 234.0/255.0, green: 74.0/255.0, blue: 70/255.0, alpha: 1.0)
        self.view.addSubview(bgView)
        
        //        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的评论"
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .None

    }
    
    // Mark: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ReviewCell(model: self.reviewArr[indexPath.row])
        // TODO: 头像
        cell.username.text = "这里是用户名"
        cell.avatar.image = UIImage(named: "avatar")
        if indexPath.row == reviewArr.count - 1 {
            cell.separator.removeFromSuperview()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: 跳转到书籍详情页面
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}