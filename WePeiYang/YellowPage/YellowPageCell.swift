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
    
    convenience init(with style: YellowPageCellStyle, name: String) {
        self.init(style: .default, reuseIdentifier: style.rawValue)
        
        self.style = style
        switch style {
        case .header:
            commonView = CommonView(with: [])
            commonView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.contentView.addSubview(commonView)
            commonView.snp.makeConstraints { make in
                make.width.equalTo(UIScreen.main.bounds.size.width)
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
            arrowView.snp.makeConstraints { make in
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
            label.snp.makeConstraints { make in
                make.top.equalTo(contentView).offset(20)
                make.left.equalTo(arrowView.snp.right).offset(10)
                make.centerY.equalTo(contentView)
                make.bottom.equalTo(contentView).offset(-20)
            }

            countLabel = UILabel()
            self.contentView.addSubview(countLabel)
            countLabel.textColor = UIColor.lightGray
            countLabel.font = UIFont.systemFont(ofSize: 14)
            countLabel.snp.makeConstraints { make in
                make.left.equalTo(contentView.snp.right).offset(-30)
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
            textLabel?.snp.makeConstraints { make in
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
        self.init(style: .default, reuseIdentifier: style.rawValue)
        guard style == .detailed else {
            return
        }
        
        let nameLabel = UILabel()
        nameLabel.text = model.name
        nameLabel.font = UIFont.flexibleFont(with: 14)
        nameLabel.sizeToFit()
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(15)
            //make.bottom.equalTo(nameLabel).offset(-12)
        }
        
        let phoneLabel = UILabel()
        phoneLabel.text = model.phone
        phoneLabel.textColor = UIColor.gray
        phoneLabel.font = UIFont.flexibleFont(with: 14)
        phoneLabel.sizeToFit()
        self.contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(13)
            make.left.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).offset(-6)
        }
        
        let likeView = UIImageView()
            likeView.image = UIImage(named: model.isFavorite ? "like" : "dislike")
        self.contentView.addSubview(likeView)
        likeView.snp.makeConstraints { make in
            make.width.equalTo(18)
            make.height.equalTo(18)
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(-6)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageCell.likeTapped))
        likeView.addGestureRecognizer(tapGesture)
        
        let phoneView = UIImageView()
        phoneView.image = UIImage(named: "phone")

        self.contentView.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.width.equalTo(18)
            make.height.equalTo(18)
            make.right.equalTo(likeView.snp.left).offset(-30)
            make.bottom.equalTo(contentView).offset(-6)
        }
        
    }
    
    func likeTapped() {
        if detailedModel.isFavorite {
           PhoneBook.shared.favorite = PhoneBook.shared.favorite.filter { model in
                return !(model.isFavorite == detailedModel.isFavorite &&
                    model.name == detailedModel.name &&
                    model.phone == detailedModel.phone)
            }
            detailedModel.isFavorite = false
            // TODO: animation
        } else {
            detailedModel.isFavorite = true
            PhoneBook.shared.favorite.append(detailedModel)
            // TODO: animation
        }
    }
    
}

extension UIFont {
    static func flexibleFont(with baseSize: CGFloat) -> UIFont {
        let bigiPhoneWidth: CGFloat = 414.0
        let middleiPhoneWidth: CGFloat = 375.0
        let smalliPhoneWidth: CGFloat = 320.0

        var font: UIFont! = nil
        let width = UIScreen.main.bounds.size.width

        // default base size is 14
        
        if width >= bigiPhoneWidth { // 414 iPhone 6/7 Plus
            font = UIFont.systemFont(ofSize: baseSize+1)
        } else if width >= middleiPhoneWidth { // 375 iPhone 6(S) 7
            font = UIFont.systemFont(ofSize: baseSize)
        } else if width <= smalliPhoneWidth { // 320 iPhone 5(S)
            font = UIFont.systemFont(ofSize: baseSize-1)
        }
        return font
    }
}
