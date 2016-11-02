//
//  StatusInfoCell.swift
//  TableView
//
//  Created by Kyrie Wei on 10/26/16.
//  Copyright © 2016 Kyrie Wei. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class StatusInfoCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    convenience init(status: Bool, library: String, location: String) {
        self.init()
        
        let barcodeLabel:UILabel = {
        let barcodeLabel = UILabel()
        barcodeLabel.text = "索书号"
        barcodeLabel.textColor = UIColor.blackColor()
        barcodeLabel.textAlignment = .Center
        barcodeLabel.font = UIFont.systemFontOfSize(17)
        return barcodeLabel
    }()
    
    let locationLabel:UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "所在馆藏地点"
        locationLabel.textColor = UIColor.blackColor()
        locationLabel.textAlignment = .Center
        locationLabel.font = UIFont.systemFontOfSize(17)
        return locationLabel
    }()
    
    let statusLabel:UILabel = {
        let statusLabel = UILabel()
        
        if status == true {
            statusLabel.text = "在馆"
            statusLabel.textColor = UIColor.redColor()
        } else {
            statusLabel.text = "借出"
            statusLabel.textColor = UIColor.lightGrayColor()
        }
        
        statusLabel.textAlignment = .Center
        statusLabel.font = UIFont.systemFontOfSize(17)
        return statusLabel
    }()
        
        
        contentView.backgroundColor = UIColor.clearColor()
        
        contentView.addSubview(barcodeLabel)
        barcodeLabel.snp_makeConstraints {
            make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView).offset(-(contentView.frame.size.width / 36) * 31) //amazing number, ignore it
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        contentView.addSubview(locationLabel)
        locationLabel.snp_makeConstraints {
            make in
            make.left.equalTo(barcodeLabel.snp_right)
            make.right.equalTo(contentView).offset((-contentView.frame.size.width / 36) * 15) //amazing number, ignore it
            make.centerY.equalTo(barcodeLabel.snp_centerY)
        }
        
        contentView.addSubview(statusLabel)
        statusLabel.snp_makeConstraints{
            make in
            make.left.equalTo(locationLabel.snp_right)
            make.right.equalTo(contentView.snp_right)
            make.centerY.equalTo(barcodeLabel.snp_centerY)
        }
        
        if status == false {
            let dueTimeForMatter = NSDateFormatter()
            dueTimeForMatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let dueTimeLabel:UILabel = {
                let dueTimeLabel = UILabel()
                // dueTimeLabel.text = "应还时间：\(dueTimeForMatter.stringFromDate(duetime))"
                dueTimeLabel.text = "应还时间：2016-10-28 04:09"
                dueTimeLabel.textColor = UIColor.darkGrayColor()
                dueTimeLabel.textAlignment = .Center
                dueTimeLabel.font = UIFont.systemFontOfSize(12)
                return dueTimeLabel
            }()
            
            contentView.addSubview(dueTimeLabel)
            dueTimeLabel.snp_makeConstraints{
                make in
                make.bottom.equalTo(contentView.snp_bottom)
                make.right.equalTo(contentView).offset((-contentView.frame.size.width / 36) * 5)
            }
        }

    }
    
   
}