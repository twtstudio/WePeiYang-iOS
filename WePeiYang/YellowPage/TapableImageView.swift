//
//  TapableImageView.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/24.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class TapableImageView: UIView {

    let imgView = UIImageView()
    var imgSize: CGSize! = nil
    
    convenience init(with frame: CGRect, imageSize: CGSize, image: UIImage) {
        self.init(frame: frame)
        imgView.image = image
        self.addSubview(imgView)
        imgView.snp.makeConstraints { _ in 
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }

}
