
//
//  SearchView.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit
import SnapKit

class SearchView: UIView {
    //let backBtn = UIButton()
    let backBtn = TappableImageView(with: CGRect.zero, imageSize: CGSize(width: 20, height: 20), image: UIImage(named: "ypback"))
    let textField = UITextField()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let bgdView = UIView()
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        bgdView.frame = rect
        self.addSubview(bgdView)
        self.backgroundColor = UIColor(red: 0.1059, green: 0.6352, blue: 0.9019, alpha: 0.5)

        bgdView.backgroundColor = UIColor(red: 0.1059, green: 0.6352, blue: 0.9019, alpha: 1)
        
        bgdView.addSubview(backBtn)
        backBtn.snp_makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalTo(self).offset(7)
            make.left.equalTo(self).offset(20)
        }

        let separator = UIView()
        separator.backgroundColor = UIColor(red: 0.074, green: 0.466, blue: 0.662, alpha: 1)
        bgdView.addSubview(separator)
        separator.snp_makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(20)
            make.centerY.equalTo(self).offset(7)
            make.left.equalTo(backBtn.snp_right).offset(10)
        }

        
        let iconView = UIImageView()
        iconView.image = UIImage(named: "search")
        bgdView.addSubview(iconView)
        iconView.snp_makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(self).offset(7)
            make.left.equalTo(separator.snp_right).offset(10)
        }
        
        let baseLine = UIView()
        baseLine.backgroundColor = UIColor.whiteColor()
        bgdView.addSubview(baseLine)
        baseLine.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(iconView.snp_bottom).offset(4)
            make.left.equalTo(iconView.snp_left)
            make.right.equalTo(bgdView).offset(-15)
        }
        
        self.addSubview(textField)
        textField.snp_makeConstraints { make in
            make.left.equalTo(iconView.snp_right).offset(2)
            make.right.equalTo(baseLine.snp_right)
            make.bottom.equalTo(baseLine.snp_top).offset(-3)
            make.height.equalTo(20)
        }
        textField.clearButtonMode = .UnlessEditing
        textField.textColor = UIColor.whiteColor()
    }


}
