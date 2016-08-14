//
//  ScoreTableViewCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import UIKit
//import SnapKit

class ScoreTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    convenience init(title: String, score: String, completeTime: String) {
        self.init()
    
        
        
        let titleLabel = UILabel(text: title)
        let timeLabel = UILabel(text: completeTime)
        let scoreLabel = UILabel(text: score)
        
        titleLabel.font = UIFont.boldSystemFontOfSize(12.0)
        titleLabel.textColor = UIColor.lightGrayColor()
        scoreLabel.font = UIFont.boldSystemFontOfSize(12.0)
        scoreLabel.textColor = UIColor.redColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(10.0)
        timeLabel.textColor = UIColor.lightGrayColor()
        
        
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(scoreLabel)
        
        timeLabel.snp_makeConstraints {
            make in
            make.right.equalTo(contentView).offset(-8)
            make.centerY.equalTo(contentView)
        }
        
        scoreLabel.snp_makeConstraints {
            make in
            make.right.equalTo(timeLabel.snp_left).offset(-8)
            make.centerY.equalTo(contentView)
        }
        
        titleLabel.snp_makeConstraints {
            make in
            make.left.equalTo(contentView).offset(8)
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(scoreLabel.snp_left).offset(-8)
            
        }
        
       
    }
    
}