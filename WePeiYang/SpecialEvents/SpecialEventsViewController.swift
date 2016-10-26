//
//  SpecialEventsViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/20/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit
import pop

let smallPhoneWidth: CGFloat = 320
let phoneWidth = UIApplication.sharedApplication().keyWindow?.frame.size.width

class SpecialEventsViewController: WebAppViewController {

    var saveForLaterBtn: UIButton!
    var notInterestedBtn: UIButton!
    
    var diveIntoDetailBtn: UIButton!
    
    //下次再看
    func dismissAnimatedAndRemoveDefaults() {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("eventsWatched")
        
        self.dismissViewControllerAnimated(true) {
            for fooView in (UIViewController.currentViewController().tabBarController?.view.subviews)! {
                if fooView.isKindOfClass(UIVisualEffectView) {
                    fooView.removeFromSuperview()
                }
            }
        }
        
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
        app?.specialEventsShouldShow = false
        
    }
    
    //不感兴趣
    func dismissAnimated() {
        self.dismissViewControllerAnimated(true) {
            for fooView in (UIViewController.currentViewController().tabBarController?.view.subviews)! {
                if fooView.isKindOfClass(UIVisualEffectView) {
                    fooView.removeFromSuperview()
                }
            }
        }
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
        app?.specialEventsShouldShow = false
    }
    
    
    func expandView() {
        
        let h = UIScreen.mainScreen().bounds.size.height
        let w = UIScreen.mainScreen().bounds.size.width
        
        let expandAnim = POPSpringAnimation(propertyNamed: kPOPViewBounds)
        expandAnim.toValue = NSValue(CGRect: CGRect(x: 0, y: 0, width: w, height: h))
        expandAnim.springBounciness = 10
        expandAnim.completionBlock = {
            (_, _) in
            for fooView in self.view.subviews {
                if fooView.isKindOfClass(UIImageView) {
                    fooView.removeFromSuperview()
                }
            }
        }
        
        self.view.addSubview(saveForLaterBtn)
        saveForLaterBtn.snp_makeConstraints {
            make in
            make.left.equalTo(self.view).offset(20)
            make.bottom.equalTo(self.view).offset(-20)
            make.width.equalTo(100)
        }
        
        self.view.addSubview(notInterestedBtn)
        notInterestedBtn.snp_makeConstraints {
            make in
            make.bottom.equalTo(self.view).offset(-20)
            make.right.equalTo(self.view).offset(-20)
            make.width.equalTo(100)
        }
        
        let deRoundCornoerAnim = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius)
        let newCornerRadius: NSNumber = 0
        deRoundCornoerAnim.toValue = newCornerRadius
        
        //expandAnim.springSpeed =
        self.view.pop_addAnimation(expandAnim, forKey: "expandAnim")
        self.view.layer.pop_addAnimation(deRoundCornoerAnim, forKey: "deRound")
        for fooView in self.view.subviews {
            
            if !fooView.isKindOfClass(UIButton) {
                fooView.layer.pop_addAnimation(deRoundCornoerAnim, forKey: "deRound")
            }
            
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSUserDefaults.standardUserDefaults().setObject("1", forKey: "eventsWatched")
        
        diveIntoDetailBtn = UIButton(title: "我要报名", borderWidth: 2.0, borderColor: .whiteColor())
        diveIntoDetailBtn.addTarget(self, action: #selector(self.expandView), forControlEvents: .TouchUpInside)
        
        
        
        saveForLaterBtn = UIButton(title: "下次再看", borderWidth: 2.0, borderColor: .whiteColor())
        saveForLaterBtn.addTarget(self, action: #selector(self.dismissAnimatedAndRemoveDefaults), forControlEvents: .TouchUpInside)
        
        notInterestedBtn = UIButton(title: "不再提醒", borderWidth: 2.0, borderColor: .whiteColor())
        notInterestedBtn.addTarget(self, action: #selector(self.dismissAnimated), forControlEvents: .TouchUpInside)

        view.layer.cornerRadius = 8
        for subview in view.subviews {
            subview.layer.cornerRadius = 8
        }
        
        let flyerView = UIImageView()
        flyerView.clipsToBounds = true
        flyerView.layer.cornerRadius = 8
        let flyerImg = UIImage(named: "specialEventsFlyer")
        flyerView.image = flyerImg
        flyerView.contentMode = .ScaleAspectFill
        
        
        self.view.addSubview(flyerView)
        flyerView.snp_makeConstraints {
            make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        if phoneWidth <= smallPhoneWidth {
            
            flyerView.addSubview(diveIntoDetailBtn)
            diveIntoDetailBtn.snp_makeConstraints {
                make in
                make.bottom.equalTo(flyerView).offset(-40)
                make.right.equalTo(flyerView).offset(-10)
                make.width.equalTo(90)
            }
            
            flyerView.addSubview(notInterestedBtn)
            notInterestedBtn.snp_makeConstraints {
                make in
                make.bottom.equalTo(flyerView).offset(-40)
                make.left.equalTo(flyerView).offset(10)
                make.width.equalTo(90)
            }
            
        } else {
            flyerView.addSubview(diveIntoDetailBtn)
            diveIntoDetailBtn.snp_makeConstraints {
                make in
                make.right.equalTo(flyerView).offset(-20)
                make.bottom.equalTo(flyerView).offset(-40)
                make.width.equalTo(100)
            }
            
            /*self.view.addSubview(saveForLaterBtn)
             saveForLaterBtn.snp_makeConstraints {
             make in
             make.bottom.equalTo(flyerView).offset(-40)
             make.left.equalTo(flyerView).offset(20)
             make.width.equalTo(100)
             }*/
            flyerView.addSubview(notInterestedBtn)
            notInterestedBtn.snp_makeConstraints {
                make in
                make.bottom.equalTo(flyerView).offset(-40)
                make.left.equalTo(flyerView).offset(20)
                make.width.equalTo(100)
            }
        }

        
        assignGestures(to: flyerView)
        //log.any(view.subviews)/
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


/*
extension SpecialEventsViewController {
    
    
    func computeLayout() {
        navigator = UIView(color: .blackColor())
        self.view.addSubview(navigator)
        navigator.snp_makeConstraints {
            make in
            make.top.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(44)
        }
        
        self.view.snp_makeConstraints {
            make in
            make.height.equalTo(self.view.frame.size.height - 44)
        }
        
        navigator.addSubview(saveForLaterBtn)
        saveForLaterBtn.snp_makeConstraints {
            make in
            make.top.equalTo(navigator).offset(20)
            make.left.equalTo(navigator).offset(20)
            make.width.equalTo(100)
        }
        
        navigator.addSubview(notInterestedBtn)
        notInterestedBtn.snp_makeConstraints {
            make in
            make.top.equalTo(navigator).offset(20)
            make.right.equalTo(navigator).offset(-20)
            make.width.equalTo(100)
        }
    }
}*/

private extension SpecialEventsViewController {
    
    func assignGestures(to whichView: UIView) {
        whichView.userInteractionEnabled = true
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.expandView))
        pinchGestureRecognizer.scale = 1.2
        whichView.addGestureRecognizer(pinchGestureRecognizer)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissAnimatedAndRemoveDefaults))
        swipeUp.direction = .Up
        whichView.addGestureRecognizer(swipeUp)
        
    }

}

private extension UIButton {
    convenience init(title: String, borderWidth: CGFloat, borderColor: UIColor) {
        self.init()
        setTitle(title, forState: .Normal)
        titleLabel?.sizeToFit()
        self.layer.cornerRadius = 8
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
}
