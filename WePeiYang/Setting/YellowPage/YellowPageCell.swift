//
//  YellowPageCell.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit
import SnapKit

// haeder: the view on top
// section: which can be fold and unfold
// item: for each item in section
// detailed: detailed info
enum YellowPageCellStyle: String {
    case header = "headerCell"
    case section = "sectionCell"
    case item = "itemCell"
    case detailed = "detailedCell"
}

class YellowPageCell: UITableViewCell {
    
    var canUnfold = true {
        didSet {
            if self.canUnfold && style == .section {
                arrowView.image = UIImage(named: "ic_arrow_right")
            } else {
                arrowView.image = UIImage(named: "ic_arrow_down")
            }
        }
    }
    var name = ""
    let arrowView = UIImageView()
    var countLabel: UILabel! = nil
    var style: YellowPageCellStyle = .header
    var detailedModel: ClientItem! = nil
    var commonView: CommonView! = nil
    var likeView: TappableImageView! = nil
    
    convenience init(with style: YellowPageCellStyle, name: String) {
        self.init(style: .Default, reuseIdentifier: style.rawValue)
        
        self.style = style
        switch style {
        case .header:
            commonView = CommonView(with: [])
            commonView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.contentView.addSubview(commonView)
            commonView.snp_makeConstraints { make in
                make.width.equalTo(UIScreen.mainScreen().bounds.size.width)
                make.height.equalTo(200)
                make.top.equalTo(contentView)
                make.left.equalTo(contentView)
                make.right.equalTo(contentView)
                make.bottom.equalTo(contentView)
            }
            
        case .section:
            arrowView.image = UIImage(named: self.canUnfold ? "ic_arrow_right" : "ic_arrow_down")
            arrowView.sizeToFit()
            self.contentView.addSubview(arrowView)
            arrowView.snp_makeConstraints { make in
                make.width.equalTo(15)
                make.height.equalTo(15)
                make.left.equalTo(contentView).offset(10)
                make.centerY.equalTo(contentView)
            }
            
            let label = UILabel()
            self.contentView.addSubview(label)
            // TODO: adjust font size
            label.text = name
            label.font = UIFont.flexibleFont(with: 15)
            label.sizeToFit()
            label.snp_makeConstraints { make in
                make.top.equalTo(contentView).offset(20)
                make.left.equalTo(arrowView.snp_right).offset(10)
                make.centerY.equalTo(contentView)
                make.bottom.equalTo(contentView).offset(-20)
            }

            countLabel = UILabel()
            self.contentView.addSubview(countLabel)
            countLabel.textColor = UIColor.lightGrayColor()
            countLabel.font = UIFont.systemFontOfSize(14)
            countLabel.snp_makeConstraints { make in
                make.left.equalTo(contentView.snp_right).offset(-30)
                make.centerY.equalTo(contentView)
            }
            
        case .item:
            self.textLabel?.text = name
//            if width >= bigiPhoneWidth { // 414 iPhone 6/7 Plus
//                font = UIFont.systemFont(ofSize: 15)
//            } else if width >= middleiPhoneWidth { // 375 iPhone 6(S) 7
//                font = UIFont.systemFont(ofSize: 14)
//            } else if width <= smalliPhoneWidth { // 320 iPhone 5(S)
//                font = UIFont.systemFont(ofSize: 14)
//            }
            textLabel?.font = UIFont.flexibleFont(with: 14)
            
            textLabel?.sizeToFit()
            textLabel?.snp_makeConstraints { make in
                make.top.equalTo(contentView).offset(12)
                make.centerY.equalTo(contentView)
                make.left.equalTo(contentView).offset(15)
                make.bottom.equalTo(contentView).offset(-12)
            }
        case .detailed:
            break
        }
        
    }
    
    convenience init(with style: YellowPageCellStyle, model: ClientItem) {
        self.init(style: .Default, reuseIdentifier: style.rawValue)
        guard style == .detailed else {
            return
        }
        self.detailedModel = model
        let nameLabel = UILabel()
        nameLabel.text = model.name
        nameLabel.font = UIFont.flexibleFont(with: 14)
        nameLabel.sizeToFit()
       
        // paste
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(YellowPageCell.longPressed))
        self.addGestureRecognizer(longPress)
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(15)
            //make.bottom.equalTo(nameLabel).offset(-12)
        }
        
        
        let phoneLabel = UILabel()
        phoneLabel.text = model.phone
        phoneLabel.textColor = UIColor.grayColor()
        phoneLabel.font = UIFont.flexibleFont(with: 14)
        phoneLabel.sizeToFit()
        self.contentView.addSubview(phoneLabel)
        phoneLabel.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom).offset(13)
            make.left.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).offset(-6)
        }
        
//        let likeView = UIImageView()
        likeView = TappableImageView(with: CGRect.zero, imageSize: CGSize(width: 18, height: 18), image: UIImage(named: model.isFavorite ? "like" : "dislike"))
        //likeView.image = UIImage(named: model.isFavorite ? "like" : "dislike")
        self.contentView.addSubview(likeView)
        likeView.snp_makeConstraints { make in
//            make.width.equalTo(18)
//            make.height.equalTo(18)
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.right.equalTo(contentView).offset(-14)
            //make.bottom.equalTo(contentView)//.offset(4)
            make.centerY.equalTo(phoneLabel.snp_centerY)
        }
        likeView.userInteractionEnabled = true
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageCell.likeTapped))
        likeView.addGestureRecognizer(likeTapGesture)
        
//        let phoneView = UIImageView()
//        phoneView.image = UIImage(named: "phone")
        let phoneView = TappableImageView(with: CGRect.zero, imageSize: CGSize(width: 18, height: 18), image: UIImage(named: "phone"))
        let phoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageCell.phoneTapped))
        phoneView.addGestureRecognizer(phoneTapGesture)
        
        self.contentView.addSubview(phoneView)
        phoneView.snp_makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.right.equalTo(likeView.snp_left).offset(-24)
            //make.bottom.equalTo(contentView)//.offset(4)
            make.centerY.equalTo(phoneLabel.snp_centerY)
        }
        
    }
    
    func likeTapped() {
        if detailedModel.isFavorite {
            PhoneBook.shared.removeFromFavorite(with: self.detailedModel.name) {
                self.likeView.imgView.image = UIImage(named: "dislike")
            }
            detailedModel.isFavorite = false
            // TODO: animation
        } else {
            PhoneBook.shared.addToFavorite(with: self.detailedModel.name) {
                self.likeView.imgView.image = UIImage(named: "like")
            }
            detailedModel.isFavorite = true
            // TODO: animation
            // refresh data
        }
    }
    
    func phoneTapped() {
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(self.detailedModel.phone)")!)
    }
    
    func longPressed() {
        if let text = UIPasteboard.generalPasteboard().string {
            if text == self.detailedModel.phone {
                MsgDisplay.showSuccessMsg("已经复制到剪切板")
                return
            }
        }
        UIPasteboard.generalPasteboard().string = self.detailedModel.phone
        MsgDisplay.showSuccessMsg("已经复制到剪切板")
    }
    
}
