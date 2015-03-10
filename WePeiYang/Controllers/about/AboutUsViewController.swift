//
//  AboutUsViewController.swift
//  WePeiYang
//
//  Created by 秦昱博 on 14/12/8.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController, UIGestureRecognizerDelegate, UIAlertViewDelegate {
    
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var logoView: UIImageView!
    
    var timesThatTheLogoWasTouches: NSInteger!
    var secureAlert: UIAlertView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timesThatTheLogoWasTouches = 0
        
        //self.navigationController!.interactivePopGestureRecognizer.delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.versionLabel.text = "微北洋 \(data.shareInstance().appVersion)"
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64))
        let navigationItem = UINavigationItem(title: "关于我们")
        
        let backIconPath:NSString! = NSBundle.mainBundle().pathForResource("backForNav@2x", ofType: "png")
        let backBarBtn = UIBarButtonItem(image: UIImage(contentsOfFile: backIconPath), style: UIBarButtonItemStyle.Plain, target: self, action: "backToHome")
        navigationBar.pushNavigationItem(navigationItem, animated: true)
        navigationItem.setLeftBarButtonItem(backBarBtn, animated: true)
        
        self.view.addSubview(navigationBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func backToHome() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func eggEvent() {
        timesThatTheLogoWasTouches = timesThatTheLogoWasTouches + 1
        if timesThatTheLogoWasTouches == 10 {
            self.openDevKit()
            timesThatTheLogoWasTouches = 0
        }
    }
    
    func openDevKit() {
        secureAlert = UIAlertView(title: "安全验证", message: "输入密码", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
        secureAlert.alertViewStyle = .SecureTextInput
        secureAlert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == secureAlert {
            var secureField = alertView.textFieldAtIndex(0)
            let key = twtSecretKeys.getDevKey()
            if buttonIndex == 1 {
                let password = secureField!.text
                if password == key {
                    let devVC = DevViewController(nibName: "DevViewController", bundle: nil)
                    self.presentViewController(devVC, animated: true, completion: nil)
                } else {
                    let failAlert = UIAlertView(title: "Failed", message: "Wrong Password", delegate: self, cancelButtonTitle: "OK")
                    failAlert.show()
                }
            }
        }
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
