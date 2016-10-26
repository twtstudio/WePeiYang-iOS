//
//  RecommendCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class RecommendCell: UITableViewCell {
    
    
    let arr = [
        [
            "isbn": "sbsbsb",
            "title": "从你的全世界路过",
            "author": "张嘉佳",
            "cover": "http://imgsrc.baidu.com/forum/w%3D580/sign=90a6b0a29f16fdfad86cc6e6848e8cea/fd1f4134970a304e1256eb73d3c8a786c8175cc6.jpg",
            "rate": 5
        ],
        [
            "isbn": "sbsbsb",
            "title": "雷雨",
            "author": "曹禺",
            "cover": "http://pic9.997788.com/pic_auction/00/08/13/58/au8135818.jpg",
            "rate": 5
        ],
        [
            "isbn": "sbsbsb",
            "title": "目送",
            "author": "龙应台",
            "cover": "http://shopimg.kongfz.com.cn/20110803/1228444/10445rxsker_b.jpg",
            "rate": 5
        ],
        [
            "isbn": "sbsbsb",
            "title": "雷雨",
            "author": "曹禺",
            "cover": "http://pic9.997788.com/pic_auction/00/08/13/58/au8135818.jpg",
            "rate": 5
        ],
        [
            "isbn": "sbsbsb",
            "title": "雷雨",
            "author": "曹禺",
            "cover": "http://pic9.997788.com/pic_auction/00/08/13/58/au8135818.jpg",
            "rate": 5
        ],
        [
            "isbn": "sbsbsb",
            "title": "雷雨",
            "author": "曹禺",
            "cover": "http://pic9.997788.com/pic_auction/00/08/13/58/au8135818.jpg",
            "rate": 5
        ],
        
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    convenience init(a: Int) {
        self.init()
        
        let scrollView = UIScrollView()
        var imageViewArray = [UIImageView]()
        var titleLabelArray = [UILabel]()
        var authorLabelArray = [UILabel]()
        
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSize(width: 112*arr.count, height: 200)
        
        contentView.addSubview(scrollView)
        
        scrollView.snp_makeConstraints {
            make in
            make.height.equalTo(200)
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        for i in 0..<arr.count {
            imageViewArray.append(UIImageView())
            titleLabelArray.append(UILabel(text: "\(arr[i]["title"]!)"))
            authorLabelArray.append(UILabel(text: "\(arr[i]["author"]!) 著"))
            
            scrollView.addSubview(imageViewArray[i])
            scrollView.addSubview(titleLabelArray[i])
            scrollView.addSubview(authorLabelArray[i])
            
            imageViewArray[i].userInteractionEnabled = true
            imageViewArray[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecommendCell.pushBookDetailController)))
            titleLabelArray[i].userInteractionEnabled = true
            titleLabelArray[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecommendCell.pushBookDetailController)))
            authorLabelArray[i].userInteractionEnabled = true
            authorLabelArray[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecommendCell.pushBookDetailController)))
            authorLabelArray[i].font = UIFont(name: "Arial", size: 14)
            authorLabelArray[i].textColor = UIColor.grayColor()
            
            imageViewArray[i].contentMode = .ScaleAspectFit
            imageViewArray[i].setImageWithURL(NSURL(string: "\(arr[i]["cover"]!)")!)
             
            if i == 0 {
                imageViewArray[i].snp_makeConstraints {
                    make in
                    make.top.equalTo(scrollView).offset(16)
                    make.left.equalTo(scrollView).offset(16)
                    make.width.equalTo(80)
                    make.height.equalTo(120)
                }
            } else {
                imageViewArray[i].snp_makeConstraints {
                    make in
                    make.top.equalTo(scrollView).offset(16)
                    make.left.equalTo(imageViewArray[i-1].snp_right).offset(32)
                    make.width.equalTo(80)
                    make.height.equalTo(120)
                }
            }
            
            titleLabelArray[i].snp_makeConstraints {
                make in
                make.top.equalTo(imageViewArray[i].snp_bottom).offset(8)
                make.centerX.equalTo(imageViewArray[i])
                make.width.lessThanOrEqualTo(100)
            }
            
            authorLabelArray[i].snp_makeConstraints {
                make in
                make.top.equalTo(titleLabelArray[i].snp_bottom).offset(8)
                make.centerX.equalTo(imageViewArray[i])
            }
            
        }
        
    }
    
    func pushBookDetailController() {
        print("push Detail View Controller")
    }
    
}
