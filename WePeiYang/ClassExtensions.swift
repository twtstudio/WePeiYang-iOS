//
//  ClassExtensions.swift
//  WePeiYang
//
//  Created by Allen X on 8/12/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

/**
 This file is wrapping all extensions of classes 
 */

extension UILabel {
    convenience init(text: String, color: UIColor) {
        self.init()
        self.text = text
        textColor = color
        self.sizeToFit()
    }
    
    convenience init(text: String) {
        self.init()
        self.text = text
        self.sizeToFit()
    }
}

extension UIView {
    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }
}

extension UIImage {
    static func resizedImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRect(x: 0.0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIImageView {
    convenience init?(imageName: String, desiredSize: CGSize) {
        guard var foo = UIImage(named: imageName) else {
            return nil
        }
        foo = UIImage.resizedImage(foo, scaledToSize: desiredSize)
        self.init()
        image = foo
    }
}