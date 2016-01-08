//
//  HomeImageTitleView.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/8.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import AFNetworking
import Masonry

class HomeImageTitleView: UIView {
    
    var imgView: UIImageView!
    var titleLabel: UILabel!
    var directURL: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgView = UIImageView(frame: frame)
        self.addSubview(imgView)
        imgView.mas_makeConstraints({make in
            make.edges.equalTo()(self).with().insets()(UIEdgeInsetsMake(0, 0, 0, 0))
        })
        
        let blurEffect = UIBlurEffect(style: .Dark)
//        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let bgView = UIVisualEffectView(effect: blurEffect)
//        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        self.addSubview(bgView)
        bgView.mas_makeConstraints({make in
            make.bottom.equalTo()(self)
            make.left.equalTo()(self)
            make.right.equalTo()(self)
            make.height.mas_equalTo()(46)
        })
//        bgView.contentView.addSubview(vibrancyEffectView)
//        vibrancyEffectView.mas_makeConstraints({make in
//            make.edges.mas_equalTo()(bgView)
//        })
        
        titleLabel = UILabel()
        bgView.contentView.addSubview(titleLabel)
        titleLabel.mas_makeConstraints({make in
            make.top.equalTo()(bgView).with().offset()(8)
            make.bottom.equalTo()(bgView).with().offset()(-20)
            make.left.equalTo()(bgView).with().offset()(8)
            make.right.equalTo()(bgView).with().offset()(8)
        })
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.numberOfLines = 0
        
//        let tapRecognizer = UITapGestureRecognizer().bk_initWithHandler({(recognizer, state, point) in
//            
//        }) as! UITapGestureRecognizer
//        self.userInteractionEnabled = true
//        self.addGestureRecognizer(tapRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setObject(obj: HomeCellData) {
        self.imgView.setImageWithURL(NSURL(string: obj.pic)!)
        self.titleLabel.text = obj.subject
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
