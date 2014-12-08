//
//  SplashViewController.swift
//  WePeiYang
//
//  Created by 秦昱博 on 14/12/8.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var imgView: UIImageView!
    
    var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        navigationBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64))
        let navigationItem = UINavigationItem(title: "谨贺新年")
        
        let dismissBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissSelf")
        
        let shareBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareImage")
        
        navigationBar.pushNavigationItem(navigationItem, animated: true)
        navigationItem.setLeftBarButtonItem(dismissBtn, animated: true)
        navigationItem.setRightBarButtonItem(shareBtn, animated: true)
        
        navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationBar.tintColor = UIColor.whiteColor()
        
        self.view.addSubview(navigationBar)
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        self.view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareImage() {
        
        var launchImg = imgView.image!
        var activityItems = [launchImg]
        var activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        var hideAnim = POPBasicAnimation(propertyNamed: kPOPLayerPosition)
        var point = navigationBar.center
        if point.y == 32 {
            hideAnim.toValue = NSValue(CGPoint: CGPointMake(point.x, -32))
        } else {
            hideAnim.toValue = NSValue(CGPoint: CGPointMake(point.x, 32))
        }
        navigationBar.pop_addAnimation(hideAnim, forKey: "hide")
        
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
