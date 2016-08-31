//
//  QuizCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation


class QuizCell: UICollectionViewCell {
    
    var label:UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        return label
        
    }()
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
        
        imageView.snp_makeConstraints {
            make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.height.equalTo(64)
            make.width.equalTo(64)
        }
        
        label.snp_makeConstraints {
            make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
