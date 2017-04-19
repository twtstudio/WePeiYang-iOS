//
//  YellowPageDetailViewController.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit
import AddressBook

class YellowPageDetailViewController: UIViewController {
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .Plain)

    var models = Array<ClientItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let titleLabel = UILabel(text: self.navigationItem.title!)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(18.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel

        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
                
    }

}

extension YellowPageDetailViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = YellowPageCell(with: .detailed, model: models[indexPath.row])
        cell.delegate = self
        //cell.
        return cell
    }
}

extension YellowPageDetailViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGrayColor()
        return separator
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}

extension YellowPageDetailViewController: YellowPageCellDelegate {
    func cellDetailTapped(model: ClientItem, cell: YellowPageCell) {
        let vc = UIAlertController(title: "详情", message: "您想要做什么？", preferredStyle: .ActionSheet)
        let copyAction = UIAlertAction(title: "复制到剪切板", style: .Default) { action in
            cell.longPressed()
        }
//        let savePhoneBook
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { action in
            }
        vc.addAction(copyAction)
        vc.addAction(cancelAction)
        self.showViewController(vc, sender: nil)
//        let record = ABRecord
//        ABRecordSetValue
    }
}
