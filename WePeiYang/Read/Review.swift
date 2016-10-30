
//
//  MyCell.swift
//  CellAutolayout
//
//  Created by Halcao on 2016/10/24.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import UIKit
import SnapKit

class MyCell: UITableViewCell {
    var avatar: UIImageView = UIImageView()
    var content: UILabel = UILabel()
    var username: UILabel = UILabel()
    var rateView: RateStarView = RateStarView()
    var timestamp: UILabel = UILabel()
    var heartView: UIImageView = UIImageView()
    var like: UILabel = UILabel()

    func initWith(dic: NSDictionary) {
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(content)
        self.contentView.addSubview(username)
        self.contentView.addSubview(rateView)
        self.contentView.addSubview(timestamp)
        self.contentView.addSubview(heartView)
        self.contentView.addSubview(like)

        // let frame = avatar.frame
        // avatar.frame = CGRectMake(frame.origin.x, frame.origin.y, 45, 45)
        avatar.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(20)
            make.height.equalTo(45)
            make.width.equalTo(45)
        }

        avatar.layer.cornerRadius = 22.5
        avatar.layer.masksToBounds = true
        
        username.sizeToFit()
        username.snp_makeConstraints { make in
            make.left.equalTo(avatar.snp_right).offset(10)
            make.top.equalTo(contentView).offset(20)
        }
        
        rateView.snp_makeConstraints { make in
          //  make.width.equalTo(120)
          //  make.height.equalTo(20)
            make.top.equalTo(username.snp_bottom).offset(3)
            make.left.equalTo(avatar.snp_right).offset(9)
        }
        
        let width = UIScreen.mainScreen().bounds.size.width
        content.preferredMaxLayoutWidth = width - 40;
        content.lineBreakMode = NSLineBreakMode.ByWordWrapping
        content.font = UIFont.systemFontOfSize(18)
        content.numberOfLines = 0
        content.sizeToFit()
        content.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(avatar.snp_bottom).offset(10)
            make.right.equalTo(contentView).offset(-20)
        }
        
        timestamp.sizeToFit()
        timestamp.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(content.snp_bottom).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        like.snp_makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(content.snp_bottom).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        heartView.image = UIImage(named: "grey_heart")
        heartView.snp_makeConstraints { make in
            make.right.equalTo(like.snp_left).offset(-2)
            make.top.equalTo(content.snp_bottom).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.height.equalTo(16)
            make.width.equalTo(15)
        }
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
