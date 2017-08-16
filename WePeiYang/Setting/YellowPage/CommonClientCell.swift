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
    func load(with name: String, and icon: String) {
        imgView.frame = CGRect(x: 0, y: 4, width: 25, height: 25)
        imgView.image = UIImage(named: icon)
        label.text = "\(name)"
        label.frame = CGRect(x: 35, y: 10, width: 140, height: 20)
        
        // adjust for various iPhones
        label.font = UIFont.flexibleFont(with: 14)
        label.sizeToFit()
        self.addSubview(imgView)
        self.addSubview(label)
    }
}
