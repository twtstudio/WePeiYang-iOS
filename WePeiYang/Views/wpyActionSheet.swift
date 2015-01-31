//
//  wpyActionSheet.swift
//  WePeiYang
//
//  Created by 秦昱博 on 14/11/26.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit

class wpyActionSheet: AHKActionSheet {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init!(title: String!) {
        
        super.init(title: title)
        
        self.blurTintColor = UIColor(white: 0.0, alpha: 0.75)
        self.blurRadius = 8.0
        self.buttonHeight = 54.0
        self.cancelButtonHeight = 64.0
        self.animationDuration = 0.3
        self.cancelButtonShadowColor = UIColor(white: 0.0, alpha: 0.1)
        self.separatorColor = UIColor(white: 1.0, alpha: 0.3)
        self.selectedBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        let defaultFont = UIFont(name: "Helvetica", size: 18.0) as UIFont!
        let defaultColor = UIColor.whiteColor()
        let destructiveColor = UIColor.redColor()
        
        self.buttonTextAttributes = [
            NSForegroundColorAttributeName: defaultColor,
            NSFontAttributeName: defaultFont
        ]
        self.cancelButtonTextAttributes = [
            NSForegroundColorAttributeName: defaultColor,
            NSFontAttributeName: defaultFont
        ]
        self.destructiveButtonTextAttributes = [
            NSForegroundColorAttributeName: destructiveColor,
            NSFontAttributeName: defaultFont
        ]
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
