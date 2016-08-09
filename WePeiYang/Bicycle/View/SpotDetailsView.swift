//
//  SpotDetailsView.swift
//  MapKitImplementAgain
//
//  Created by Allen X on 7/14/16.
//  Copyright © 2016 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
let bigiPhoneWidth: CGFloat = 414.0
let deviceWidth = UIScreen.mainScreen().bounds.size.width
let deviceHeight = UIScreen.mainScreen().bounds.size.height
let bgImgView = UIImageView()
let bgBlurImg = UIImage(named: "blurEffect")

class SpotDetailsView: UIView {
    
    init(positionsAvailable: String, spotName:String, distanceFromUser: Float) {
        
        let positionsAvailableLabel = UILabel()
        let spotNameLabel = UILabel()
        let distanceFromUserLabel = UILabel()
        
        
        positionsAvailableLabel.text = positionsAvailable
        spotNameLabel.text = spotName
        distanceFromUserLabel.text = "最近车位距我 \(distanceFromUser)m"
        distanceFromUserLabel.textColor = UIColor.grayColor()
        
        if deviceWidth < bigiPhoneWidth {
            super.init(frame:CGRect(x: 10 , y: deviceHeight - 83, width: deviceWidth - 20, height: 88))
            
            self.layer.cornerRadius = 8
            let shadowPath = UIBezierPath(rect: bounds)
            self.layer.masksToBounds = false
            
            self.layer.shadowColor = UIColor.grayColor().CGColor
            
            self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            self.layer.shadowOpacity = 0.8
            self.layer.shadowPath = shadowPath.CGPath
            self.layer.shadowRadius = 4
            
            bgImgView.contentMode = UIViewContentMode.ScaleToFill
            bgImgView.image = bgBlurImg
            
            
            //bgImgView.sizeToFit()
            
            
            //self.backgroundColor = UIColor.clearColor()
            bgImgView.addSubview(positionsAvailableLabel)
            bgImgView.addSubview(spotNameLabel)
            bgImgView.addSubview(distanceFromUserLabel)
            self.addSubview(bgImgView)
            self.clipsToBounds = true
            
            //set constraint
            positionsAvailableLabel.snp_makeConstraints {
                make in
                make.top.equalTo(self).offset(20)
                make.left.equalTo(self).offset(10)
                
            }
            
            
            
            spotNameLabel.snp_makeConstraints {
                make in
                make.top.equalTo(self).offset(20)
                make.left.equalTo(positionsAvailableLabel.snp_right).offset(15)
                
            }
            
            distanceFromUserLabel.snp_makeConstraints {
                make in
                make.top.equalTo(positionsAvailableLabel.snp_bottom).offset(10)
                make.left.equalTo(self).offset(10)
                
            }
            
            bgImgView.snp_makeConstraints {
                make in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.bottom.equalTo(self)
            }
        } else {
            super.init(frame:CGRect(x: 10 , y: deviceHeight - 73, width: deviceWidth - 20, height: 88))
            self.layer.cornerRadius = 8
            let shadowPath = UIBezierPath(rect: bounds)
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.blackColor().CGColor
            
            self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            self.layer.shadowOpacity = 0.8
            self.layer.shadowPath = shadowPath.CGPath
            self.layer.shadowRadius = 4
            
            bgImgView.contentMode = UIViewContentMode.ScaleToFill
            bgImgView.image = bgBlurImg
            
            
            //bgImgView.sizeToFit()
            
            
            //self.backgroundColor = UIColor.clearColor()
            bgImgView.addSubview(positionsAvailableLabel)
            bgImgView.addSubview(spotNameLabel)
            bgImgView.addSubview(distanceFromUserLabel)
            self.addSubview(bgImgView)
            self.clipsToBounds = true
            
            
            positionsAvailableLabel.font = positionsAvailableLabel.font.fontWithSize(16)
            spotNameLabel.font = spotNameLabel.font.fontWithSize(16)
            distanceFromUserLabel.font = distanceFromUserLabel.font.fontWithSize(16)
            
            //set constraint
            positionsAvailableLabel.snp_makeConstraints {
                make in
                make.top.equalTo(self).offset(28)
                make.left.equalTo(self).offset(10)
                
            }
            
            spotNameLabel.snp_makeConstraints {
                make in
                make.top.equalTo(self).offset(28)
                make.left.equalTo(positionsAvailableLabel.snp_right).offset(10)
                
            }
            
            distanceFromUserLabel.snp_makeConstraints {
                make in
                make.top.equalTo(self).offset(28)
                make.right.equalTo(self).offset(-10)
                
            }
            
            bgImgView.snp_makeConstraints {
                make in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.bottom.equalTo(self)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
