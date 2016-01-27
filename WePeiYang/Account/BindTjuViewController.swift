//
//  BindTjuViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/27.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class BindTjuViewController: UIViewController {

    @IBOutlet var unameField: UITextField!
    @IBOutlet var passwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBind() {
        if unameField.text != "" && passwdField.text != "" {
            MsgDisplay.showLoading()
            AccountManager.bindTjuAccountWithTjuUserName(unameField.text, password: passwdField.text, success: {
                MsgDisplay.showSuccessMsg("办公网账号绑定成功！")
                self.dismissViewControllerAnimated(true, completion: {
                    NSNotificationCenter.defaultCenter().postNotificationName("PleaseRefresh", object: nil)
                })
            }, failure: {errorMsg in
                MsgDisplay.showErrorMsg(errorMsg)
            })
        } else {
            MsgDisplay.showErrorMsg("账号或密码不能为空")
        }
        
    }
    
    @IBAction func cancelBind() {
        self.dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName("PleaseGetBack", object: nil)
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
