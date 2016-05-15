//
//  LoginViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ChameleonFramework
import pop

let NOTIFICATION_LOGIN_CANCELLED = "NOTIFICATION_LOGIN_CANCELLED"
let NOTIFICATION_LOGIN_SUCCESSED = "NOTIFICATION_LOGIN_SUCCESSED"

class LoginViewController: UIViewController {
    
    @IBOutlet weak var unameField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!

    /*
    override var nibName: String? {
        return "\(self.dynamicType)"
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginBtn.layer.cornerRadius = 7.0
        loginBtn.clipsToBounds = true
        loginBtn.backgroundColor = UIColor.flatSkyBlueColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow() {
        if self.view.frame.size.height <= 568 {
            let viewAnim = POPBasicAnimation(propertyNamed: kPOPLayerPosition)
            let point = self.view.center
            let halfHeight = 0.5*UIScreen.mainScreen().bounds.size.height
            let upHeight = self.view.frame.size.height > 480 ? 66 : 150
            viewAnim.toValue = NSValue(CGPoint: CGPointMake(point.x, CGFloat(halfHeight) - CGFloat(upHeight)))
            self.view.layer.pop_addAnimation(viewAnim, forKey: "viewAnimation")
        }
    }
    
    func keyboardWillHide() {
        if self.view.frame.size.height <= 568 {
            let viewAnim = POPBasicAnimation(propertyNamed: kPOPLayerPosition)
            let point = self.view.center
            let halfHeight = 0.5*UIScreen.mainScreen().bounds.size.height
            viewAnim.toValue = NSValue(CGPoint: CGPointMake(point.x, CGFloat(halfHeight)))
            self.view.layer.pop_addAnimation(viewAnim, forKey: "viewAnimation")
        }
    }
    
    @IBAction func submitLogin() {
        if unameField.text != "" && passwdField.text != "" {
            MsgDisplay.showLoading()
            AccountManager.getTokenWithTwtUserName(unameField.text, password: passwdField.text, success: {
                MsgDisplay.showSuccessMsg("登录成功！")
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_LOGIN_SUCCESSED, object: nil)
                self.dismissViewControllerAnimated(true, completion: {
                    
                })
            }, failure: {errorMsg in
                MsgDisplay.showErrorMsg(errorMsg)
            })
        } else {
            MsgDisplay.showErrorMsg("账号或密码不能为空")
        }
        
    }
    
    @IBAction func cancelLogin() {
        self.dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_LOGIN_CANCELLED, object: nil)
        })
    }
    
    @IBAction func nextField() {
        unameField.resignFirstResponder()
        passwdField.becomeFirstResponder()
    }
    
    @IBAction func backgroundTapped() {
        unameField.resignFirstResponder()
        passwdField.resignFirstResponder()
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
