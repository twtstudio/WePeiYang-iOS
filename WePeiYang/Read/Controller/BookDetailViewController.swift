//
//  ViewController.swift
//  TableView
//
//  Created by Kyrie Wei on 10/25/16.
//  Copyright © 2016 Kyrie Wei. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let detailTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.frame = view.frame
        
        self.view.addSubview(detailTableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DetailInfoCell")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "DetailInfoCell")
        }
        
        if indexPath.section == 0{
            let statusInfoCell = StatusInfoCell(status: false, library: "beiyangyuan", location: "beiyangyuan")
            cell = statusInfoCell
        } else if indexPath.section == 1 {
            //书评
            cell?.textLabel?.text = "用户名：小韦"
            cell?.detailTextLabel?.text = "谢邀。 这本书还行吧，一般作家的水平。"
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 47
        }
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return 100
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = UIView()
            headerView.backgroundColor = UIColor(red: 247/255.0, green:247/255.0, blue:247/255.0, alpha:1.0)
            
            
            let headerLabel = UILabel()
            headerLabel.text = "在馆信息"
            headerLabel.font = UIFont(name: "Futura", size: 17)
            headerLabel.textColor = UIColor.lightGrayColor()
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            headerLabel.snp_makeConstraints{
                make in
                make.left.equalTo(headerView).offset(16)
                make.top.equalTo(headerView).offset(5)
            }
            
            let barcode = UILabel()
            barcode.text = "索书号"
            barcode.font = UIFont(name: "Futura", size: 14)
            barcode.textAlignment = .Center
            barcode.textColor = UIColor.lightGrayColor()
            barcode.backgroundColor = UIColor.whiteColor()
            headerView.addSubview(barcode)
            barcode.snp_makeConstraints{
                make in
                make.left.equalTo(headerView)
                make.right.equalTo(headerView).offset((-self.view.frame.size.width / 3) * 2)
                make.bottom.equalTo(headerView)
            }
    
            let locationLabel = UILabel()
            locationLabel.text = "所在馆藏地点"
            locationLabel.textAlignment = .Center
            locationLabel.font = UIFont(name: "Futura", size: 14)
            locationLabel.textColor = UIColor.lightGrayColor()
            locationLabel.backgroundColor = UIColor.whiteColor()
            headerView.addSubview(locationLabel)
            locationLabel.snp_makeConstraints{
                make in
                make.left.equalTo(barcode.snp_right)
                make.right.equalTo(headerView).offset(-self.view.frame.size.width / 3)
                make.centerY.equalTo(barcode.snp_centerY)
            }
            
            let statusLabel = UILabel()
            statusLabel.text = "在馆状态"
            statusLabel.textAlignment = .Center
            statusLabel.font = UIFont(name: "Futura", size: 14)
            statusLabel.textColor = UIColor.lightGrayColor()
            statusLabel.backgroundColor = UIColor.whiteColor()
            headerView.addSubview(statusLabel)
            statusLabel.snp_makeConstraints{
                make in
                make.left.equalTo(locationLabel.snp_right)
                make.right.equalTo(headerView)
                make.centerY.equalTo(barcode.snp_centerY)
            }
            
            return headerView
            
        } else {
            let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
            headerView.backgroundColor = UIColor(red: 247/255.0, green:247/255.0, blue:247/255.0, alpha:1.0)
            
            let headerLabel2 = UILabel()
            headerLabel2.text = "全部书评"
            headerLabel2.font = UIFont(name: "Futura", size: 17)
            headerLabel2.textColor = UIColor.lightGrayColor()
            headerView.addSubview(headerLabel2)
            headerLabel2.snp_makeConstraints{
                make in
                make.left.equalTo(headerView).offset(16)
                make.top.equalTo(headerView).offset(5)
            }
            return headerView
        }
        
    }
  
    
}
