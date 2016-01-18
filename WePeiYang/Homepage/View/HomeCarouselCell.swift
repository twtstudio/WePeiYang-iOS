//
//  HomeCarouselCell.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/8.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

@objc protocol HomeCarouselCellDelegate {
    optional func goToContent(content: NewsData)
}

class HomeCarouselCell: UITableViewCell, UIScrollViewAccessibilityDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var delegate: HomeCarouselCellDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        scrollView = UIScrollView(frame: self.frame)
        scrollView.pagingEnabled = true
        self.addSubview(scrollView)
        scrollView.mas_makeConstraints({make in
            make.edges.equalTo()(self).with().offset()(0)
        })
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width*5, scrollView.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        pageControl = UIPageControl()
        self.addSubview(pageControl)
        pageControl.numberOfPages = 5
        pageControl.userInteractionEnabled = false
        pageControl.mas_makeConstraints({make in
            make.bottom.equalTo()(self).with().offset()(8)
            make.centerX.equalTo()(self).with().offset()(0)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setArrayObject(objArr: [NewsData]) {
//        let count = objArr.count
        var imgViewArr = [HomeImageTitleView]()
        for i in 0...4 {
            let imgView = HomeImageTitleView()
            imgView.setObject(objArr[i])
            imgView.tag = i
            imgViewArr.append(imgView)
            scrollView.addSubview(imgView)
            imgView.mas_makeConstraints({make in
                make.width.mas_equalTo()(self.scrollView)
                make.height.mas_equalTo()(self.scrollView)
                // 需要写splitView时轮播的动态约束
                if i == 0 {
                    make.left.mas_equalTo()(self.scrollView).offset()(0)
                } else {
                    make.left.mas_equalTo()(imgViewArr[i-1].mas_right).offset()(0)
                }
            })
            
            let tapRecognizer = UITapGestureRecognizer().bk_initWithHandler({(recognizer, state, point) in
                self.delegate.goToContent!(objArr[i])
            }) as! UITapGestureRecognizer
            imgView.userInteractionEnabled = true
            imgView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        UIView.animateWithDuration(0.3, animations: {
            self.pageControl.currentPage = Int(offset.x) / Int(self.frame.size.width)
        })
    }

}
