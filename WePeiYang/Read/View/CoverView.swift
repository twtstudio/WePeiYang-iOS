//
//  CoverView.swift
//  WePeiYang
//
//  Created by Allen X on 10/27/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

let readRed = UIColor(red: 237.0/255.0, green: 84.0/255.0, blue: 80.0/255.0, alpha: 1.0)
let computedBGViewHeight = UIScreen.mainScreen().bounds.height * 0.52
let computedBGViewWidth = UIScreen.mainScreen().bounds.width

class CoverView: UIView {
    
    var book: Book!
    var coverView: UIImageView!
    var computedBGView: UIView!
    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var publisherLabel: UILabel!
    var yearLabel: UILabel!
    var scoreLabel: UILabel!
    var favBtn: UIButton!
    var reviewBtn: UIButton!
    var starReviewLabel: UILabel!
    var summaryLabel: UILabel!
    
    
    convenience init(book: Book) {
        self.init()
        self.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1)
        self.book = book
        coverView = {
            $0.contentMode = UIViewContentMode.ScaleAspectFit
            $0.sizeToFit()
            $0.layer.masksToBounds = false;
            $0.layer.shadowOffset = CGSizeMake(-15, 15);
            $0.layer.shadowRadius = 10;
            $0.layer.shadowOpacity = 0.5;
            return $0
        }(UIImageView())
        
        computedBGView = UIView()
        
        //coverView.setImageWithURL(NSURL(string: book.coverURL))
        titleLabel = {
            $0.font = UIFont.boldSystemFontOfSize(28)
            return $0
        }(UILabel(text: book.title, color: .blackColor()))
        
        authorLabel = {
            //$0.font = UIFont.boldSystemFontOfSize(14)
            $0.font = UIFont.systemFontOfSize(14)
            return $0
        }(UILabel(text: "作者："+book.author, color: .grayColor()))
        
        publisherLabel = {
            //$0.font = UIFont.boldSystemFontOfSize(14)
            $0.font = UIFont.systemFontOfSize(14)
            return $0
        }(UILabel(text: "出版社："+book.publisher, color: .grayColor()))
        
        yearLabel = {
            //$0.font = UIFont.boldSystemFontOfSize(14)
            $0.font = UIFont.systemFontOfSize(14)
            return $0
        }(UILabel(text: "出版时间："+book.year, color: .grayColor()))
        
        favBtn = UIButton(title: "收藏", borderWidth: 1.5, borderColor: readRed)
        favBtn.addTarget(self, action: #selector(self.favourite), forControlEvents: .TouchUpInside)
        reviewBtn = UIButton(title: "写书评", borderWidth: 1.5, borderColor: readRed)
        //reviewBtn.addTarget(self, action: #selector(self.presentReviewWritingView), forControlEvents: .TouchUpInside)
        reviewBtn.addTarget(self, action: #selector(self.presentRateView), forControlEvents: .TouchUpInside)
        
        starReviewLabel = {
            //TODO: DO OTHER UI MODIFICATIONS
            $0.font = UIFont.boldSystemFontOfSize(20)
            return $0
        }(UILabel(text: "This is a very great book", color: .grayColor()))
        
        summaryLabel = {
            //TODO: DO OTHER UI MODIFICATIONS
            $0.numberOfLines = 0
            $0.font = UIFont.systemFontOfSize(15)
            return $0
        }(UILabel(text: book.summary, color: .grayColor()))
        
        let img = UIImage(named: "cover4")
        if img?.size.height > img?.size.width {
            coverView.image = UIImage.resizedImageKeepingRatio(img!, scaledToWidth: UIScreen.mainScreen().bounds.width / 2)
        } else {
            coverView.image = UIImage.resizedImageKeepingRatio(img!, scaledToHeight: UIScreen.mainScreen().bounds.height * 0.52 * 0.6)
        }
        
        
        let fooRGB = coverView.image?.smartAvgRGB()
        computedBGView.backgroundColor = UIColor(red: (fooRGB?.red)!, green: (fooRGB?.green)!, blue: (fooRGB?.blue)!, alpha: (fooRGB?.alpha)!)
        
        computedBGView.addSubview(coverView)
        coverView.snp_makeConstraints {
            make in
            make.center.equalTo(computedBGView.center)
        }
        
        self.addSubview(computedBGView)
        computedBGView.snp_makeConstraints {
            make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(computedBGViewHeight)
        }
        
        
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints {
            make in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(computedBGView.snp_bottom).offset(20)
        }
        
        self.addSubview(authorLabel)
        authorLabel.snp_makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(14)
        }
        
        self.addSubview(publisherLabel)
        publisherLabel.snp_makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(authorLabel.snp_bottom).offset(4)
        }
        
        self.addSubview(yearLabel)
        yearLabel.snp_makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(publisherLabel.snp_bottom).offset(4)
        }
        
        self.addSubview(favBtn)
        favBtn.snp_makeConstraints {
            make in
            make.left.equalTo(yearLabel)
            make.top.equalTo(yearLabel).offset(38)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        self.addSubview(reviewBtn)
        reviewBtn.snp_makeConstraints {
            make in
            make.top.equalTo(favBtn)
            make.right.equalTo(self.snp_right).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        self.addSubview(summaryLabel)
        summaryLabel.snp_makeConstraints {
            make in
            make.top.equalTo(favBtn.snp_bottom).offset(50)
            make.left.equalTo(favBtn)
            make.right.equalTo(reviewBtn)
        }
        
        self.snp_makeConstraints {
            make in
            make.width.equalTo(UIScreen.mainScreen().bounds.width)
            //make.height.equalTo(UIScreen.mainScreen().bounds.height + 100)
            make.bottom.equalTo(summaryLabel.snp_bottom).offset(18)
        }
    }
}

private extension UIButton {
    convenience init(title: String, borderWidth: CGFloat, borderColor: UIColor) {
        self.init()
        setTitle(title, forState: .Normal)
        setTitleColor(borderColor, forState: .Normal)
        titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        //titleLabel?.sizeToFit()
        tintColor = borderColor
    
        
        //TODO: self-sizing UIButton with Snapkit
//        frame.size = CGSize(width: ((titleLabel?.frame.width)! + 60), height: ((titleLabel?.frame.height)! + 20))
//        print((titleLabel?.frame.width)! + 50)
        //let titleSize = NSString(string: title).sizeWithAttributes(<#T##attrs: [String : AnyObject]?##[String : AnyObject]?#>)
        //sizeThatFits(CGSize(width: ((titleLabel?.frame.width)! + 50), height: ((titleLabel?.frame.height)! + 20)))
        self.layer.cornerRadius = 3
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
}


extension CoverView {
    func presentRateView() {
        let rateView = RateView(rating: 3.0)
        //self.addSubview(rateView)
        
        
//        UIViewController.currentViewController().view.addSubview(rateView)
//        rateView.snp_makeConstraints {
//            make in
//            make.height.equalTo(UIScreen.mainScreen().bounds.height)
//            make.width.equalTo(UIScreen.mainScreen().bounds.width)
//            make.top.equalTo(UIViewController.currentViewController().view)
//            make.left.equalTo(UIViewController.currentViewController().view)
//        }
        
//        UIViewController.currentViewController().navigationview.addSubview(rateView)
        UIViewController.currentViewController().navigationController?.view.addSubview(rateView)
        rateView.frame = CGRect(x: 0, y: self.frame.height, width: 0, height: self.frame.height/4)
        UIView.beginAnimations("ratingViewPopUp", context: nil)
        UIView.setAnimationDuration(0.6)
        rateView.frame = self.frame
        UIView.commitAnimations()
        
    }
    
    func assignGestures(to whichView: UIView) {
        whichView.userInteractionEnabled = true
//        
//        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.expandView))
//        pinchGestureRecognizer.scale = 1.2
//        whichView.addGestureRecognizer(pinchGestureRecognizer)
//        
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissAnimatedAndRemoveDefaults))
//        swipeUp.direction = .Up
//        
//        whichView.addGestureRecognizer(swipeUp)
        
    }
    
    func favourite() {
        //Call `favourite` method of a user
    }
    
    
}
