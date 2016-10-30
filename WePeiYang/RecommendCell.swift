//
//  RecommendCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class RecommendCell: UITableViewCell {
    
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    convenience init(model: [Recommender.RecommendedBook]) {
        self.init()
        
        let scrollView = UIScrollView()
        var imageViewArray = [UIImageView]()
        var titleLabelArray = [UILabel]()
        var authorLabelArray = [UILabel]()
        
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSize(width: 128*model.count, height: 200)
        //关闭滚动条显示
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        contentView.addSubview(scrollView)
        
        scrollView.snp_makeConstraints {
            make in
            make.height.equalTo(200)
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        for i in 0..<model.count {
            imageViewArray.append(UIImageView())
            titleLabelArray.append(UILabel(text: "\(model[i].title)"))
            authorLabelArray.append(UILabel(text: "\(model[i].author) 著"))
            
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
            imageViewArray[i].setImageWithURL(NSURL(string: "\(model[i].cover)")!)
            
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
                make.top.equalTo(titleLabelArray[i].snp_bottom).offset(2 )
                make.centerX.equalTo(imageViewArray[i])
                make.width.lessThanOrEqualTo(100)
            }
            
        }
        
    }
    
    func pushBookDetailController() {
        print("push Detail View Controller")
    }
    
}
