//
//  ClassCellView.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/16.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import Masonry

class ClassCellView: UIView {
    
    var classLabel: UILabel!
    
    init() {
        super.init(frame: CGRectZero)
        
        classLabel = UILabel()
        self.addSubview(classLabel)
        classLabel.mas_makeConstraints({make in
            make.left.mas_equalTo()(4)
            make.right.mas_equalTo()(-4)
            make.top.mas_equalTo()(4)
            make.bottom.mas_equalTo()(-4)
        })
        classLabel.numberOfLines = 0
        classLabel.textColor = UIColor.whiteColor()
        classLabel.textAlignment = .Center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
