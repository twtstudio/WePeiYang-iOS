//
//  PersonalStatusLabel.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/17.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class PersonalStatusLabel: UILabel{
    
    var status: Int? //0 for waiting, 1 for doing, 2 for done
    var borderView: UIView?
    var cornerView: UIImageView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    convenience init(title: String, status: Int) {
        self.init()
        
        self.status = status
        
        /*let label = UILabel(text: title)
        self.addSubview(label)
        label.font = UIFont.boldSystemFontOfSize(14)
        
        label.snp_makeConstraints {
            make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }*/
        self.text = title
        self.font = UIFont.boldSystemFontOfSize(14)
        self.backgroundColor = UIColor.whiteColor()
        self.textColor = UIColor.lightGrayColor()
        self.textAlignment = .Center
        
        /*cornerView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        cornerView?.image = UIImage(named: "done")
        //cornerView?.alpha = 0
        self.addSubview(cornerView!)*/
        
        
    }
    
    func showStatus() {
        
        cornerView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        cornerView?.image = UIImage(named: "done")
        cornerView?.alpha = 0
        self.addSubview(cornerView!)
        
        if self.status == 0 {
            
        } else if self.status == 1 {
            UIView.animateWithDuration(0.5, animations: {
                self.textColor = UIColor.redColor()
            })
        } else if self.status == 2 {
            
            UIView.animateWithDuration(0.5, animations: {
                self.cornerView?.alpha = 1
                self.textColor = UIColor.greenColor()
            })
        }
    }
    
}