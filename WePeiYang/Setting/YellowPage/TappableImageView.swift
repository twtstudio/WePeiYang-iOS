//
//  TappableImageView.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/24.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class TappableImageView: UIView {

    let imgView = UIImageView()
    var imgSize: CGSize! = nil
    
    convenience init(with frame: CGRect, imageSize: CGSize, image: UIImage?) {
        self.init(frame: frame)
        imgView.image = image
        imgView.frame = frame
        self.imgSize = imageSize
        self.addSubview(imgView)
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = true
        drawRect(self.bounds)
    }
    
    override func drawRect(rect: CGRect) {
        imgView.snp_makeConstraints { make in
            make.width.equalTo(self.imgSize.width)
            make.height.equalTo(self.imgSize.height)
            make.center.equalTo(self.snp_center)
        }
    }

}
