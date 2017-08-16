//
//  CommonClientCell.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class CommonClientCell: UICollectionViewCell {
    var label = UILabel()
    var imgView = UIImageView()
    private let bigiPhoneWidth: CGFloat = 414.0
    private let middleiPhoneWidth: CGFloat = 375.0
    private let smalliPhoneWidth: CGFloat = 320.0
    func load(with name: String, and icon: String) {
        imgView.frame = CGRect(x: 0, y: 4, width: 25, height: 25)
        imgView.image = UIImage(named: icon)
        label.text = "\(name)"
        label.frame = CGRect(x: 35, y: 10, width: 140, height: 20)
        
        // adjust for various iPhones
        let width = UIScreen.main.bounds.size.width
        if width >= bigiPhoneWidth { // 414 iPhone 6/7 Plus
            label.font = UIFont.systemFont(ofSize: 15)
        } else if width >= middleiPhoneWidth { // 375 iPhone 6(S) 7
            label.font = UIFont.systemFont(ofSize: 14)
        } else if width <= smalliPhoneWidth { // 320 iPhone 5(S)
            label.font = UIFont.systemFont(ofSize: 13)
        }
        label.sizeToFit()
        self.addSubview(imgView)
        self.addSubview(label)
    }
}
