//
//  YellowPageSearchHistoryCell.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit
import SnapKit

class YellowPageSearchHistoryCell: UITableViewCell {

    let deleteView = TappableImageView(with: CGRect.zero, imageSize: CGSize(width: 13, height: 13), image: UIImage(named: "delete"))
    let label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    convenience init(with name: String) {
        self.init(style: .Default, reuseIdentifier: "YellowPageSearchHistoryCell")
        let imgView = UIImageView()
        imgView.image = UIImage(named: "history")
        self.addSubview(imgView)
        imgView.snp_makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        }
        
        label.text = name
        label.font = UIFont.flexibleFont(with: 15)
        label.sizeToFit()
        self.addSubview(label)
        label.snp_makeConstraints { make in
            make.left.equalTo(imgView.snp_right).offset(22)
            make.centerY.equalTo(self)
        }
        
        //deleteView.image = UIImage(named: "delete")
        self.addSubview(deleteView)
        deleteView.snp_makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(23)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
        
    }
    
}
