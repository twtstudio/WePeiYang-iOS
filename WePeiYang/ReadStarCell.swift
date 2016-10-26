//
//  ReadStarCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class ReadStarCell: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    convenience init(a: Int) {
        self.init()
        
        let width = contentView.frame.size.width
        //let height = contentView.frame.size.height
        let avatarLength = 72
        
        let avatar1 = UIImageView(imageName: "thumbAppIcon", desiredSize: CGSize(width: avatarLength, height: avatarLength))
        let avatar2 = UIImageView(imageName: "thumbAppIcon", desiredSize: CGSize(width: avatarLength, height: 72))
        let avatar3 = UIImageView(imageName: "thumbAppIcon", desiredSize: CGSize(width: avatarLength, height: avatarLength))
        let nameLabel1 = UILabel(text: "猜猜我是谁")
        let nameLabel2 = UILabel(text: "啦啦啦")
        let nameLabel3 = UILabel(text: "qnx123456")
        let badge1 = UIImageView(imageName: "badge1", desiredSize: CGSize(width: 11, height: 16))
        let badge2 = UIImageView(imageName: "badge2", desiredSize: CGSize(width: 11, height: 16))
        let badge3 = UIImageView(imageName: "badge3", desiredSize: CGSize(width: 11, height: 16))
        let infoLabel1 = UILabel()
        let infoLabel2 = UILabel()
        let infoLabel3 = UILabel()
        
        contentView.addSubview(avatar1!)
        contentView.addSubview(avatar2!)
        contentView.addSubview(avatar3!)
        contentView.addSubview(nameLabel1)
        contentView.addSubview(nameLabel2)
        contentView.addSubview(nameLabel3)
        contentView.addSubview(badge1!)
        contentView.addSubview(badge2!)
        contentView.addSubview(badge3!)
        contentView.addSubview(infoLabel1)
        contentView.addSubview(infoLabel2)
        contentView.addSubview(infoLabel3)
        
        infoLabel1.attributedText = infoString("读过 6 本书")
        infoLabel2.attributedText = infoString("读过 6 本书")
        infoLabel3.attributedText = infoString("读过 6 本书")
        
        avatar1!.clipsToBounds = true
        avatar1!.layer.cornerRadius = CGFloat(avatarLength/2)
        for subview in avatar1!.subviews {
            subview.layer.cornerRadius = CGFloat(avatarLength/2)
        }
        avatar2!.clipsToBounds = true
        avatar2!.layer.cornerRadius = CGFloat(avatarLength/2)
        for subview in avatar2!.subviews {
            subview.layer.cornerRadius = CGFloat(avatarLength/2)
        }
        avatar3!.clipsToBounds = true
        avatar3!.layer.cornerRadius = CGFloat(avatarLength/2)
        for subview in avatar3!.subviews {
            subview.layer.cornerRadius = CGFloat(avatarLength/2)
        }
        
        
        avatar1?.snp_makeConstraints {
            make in
            make.top.equalTo(contentView).offset(16)
            make.centerX.equalTo(contentView).offset(-width/3)
        }
        
        avatar2?.snp_makeConstraints {
            make in
            make.top.equalTo(contentView).offset(16)
            make.centerX.equalTo(contentView)
        }
        
        avatar3?.snp_makeConstraints {
            make in
            make.top.equalTo(contentView).offset(16)
            make.centerX.equalTo(contentView).offset(width/3)
        }
        
        badge1?.snp_makeConstraints {
            make in
            make.right.equalTo((avatar1?.snp_left)!)
            make.top.equalTo(avatar1!)
        }
        
        badge2?.snp_makeConstraints {
            make in
            make.right.equalTo((avatar2?.snp_left)!)
            make.top.equalTo(avatar2!)
        }
        
        badge3?.snp_makeConstraints {
            make in
            make.right.equalTo((avatar3?.snp_left)!)
            make.top.equalTo(avatar3!)
        }
        
        nameLabel1.snp_makeConstraints {
            make in
            make.centerX.equalTo(avatar1!)
            make.top.equalTo((avatar1?.snp_bottom)!).offset(8)
        }
        
        nameLabel2.snp_makeConstraints {
            make in
            make.centerX.equalTo(avatar2!)
            make.top.equalTo((avatar2?.snp_bottom)!).offset(8)
        }
        
        nameLabel3.snp_makeConstraints {
            make in
            make.centerX.equalTo(avatar3!)
            make.top.equalTo((avatar3?.snp_bottom)!).offset(8)
        }
        
        infoLabel1.snp_makeConstraints {
            make in
            make.centerX.equalTo(avatar1!)
            make.top.equalTo(nameLabel1.snp_bottom).offset(8)
        }
        
        infoLabel2.snp_makeConstraints {
            make in
            make.centerX.equalTo(avatar2!)
            make.top.equalTo(nameLabel2.snp_bottom).offset(8)
        }
        
        infoLabel3.snp_makeConstraints {
            make in
            make.centerX.equalTo(avatar3!)
            make.top.equalTo(nameLabel3.snp_bottom).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
        }
        
    }
    
    func infoString(string: String) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: string)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSRange(location:0,length:3))
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(),range: NSRange(location:3,length:1))
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSRange(location:5,length:2))
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14.0)!, range: NSRange(location: 0, length: 7))
        
        return mutableAttributedString
    }
    
}
