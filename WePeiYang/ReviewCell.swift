//
//  ReviewCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class ReviewCell {
    
    func attributedString(title: String, content: String) -> NSMutableAttributedString {
        let fooString = "《\(title)》\(content)"
        let mutableAttributedString = NSMutableAttributedString(string: fooString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(),range: NSRange(location:0, length: title.characters.count+2))
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSRange(location:title.characters.count+2, length: content.characters.count))
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14.0)!, range: NSRange(location: 0, length: fooString.characters.count))
        
        return mutableAttributedString
    }
}
