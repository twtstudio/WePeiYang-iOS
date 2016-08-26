//
//  HandInDetailViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class HandInDetailViewController: UIViewController {
    
    
    @IBOutlet var contentTextView: UITextView!
    
    @IBOutlet var titleTextField: UITextField!

    var type: Int?
    convenience init(type: Int) {
        self.init(nibName: "HandInDetailViewController", bundle: nil)
        
        self.type = type
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(HandInDetailViewController.submit))
        
        self.navigationItem.rightBarButtonItem = doneButton
        
        contentTextView.text = NSUserDefaults.standardUserDefaults().objectForKey("PartyHandInContentText") as? String
        titleTextField.text = NSUserDefaults.standardUserDefaults().objectForKey("PartyHandInTitleText") as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.frame.size.width = (UIApplication.sharedApplication().keyWindow?.frame.size.width)!
        
        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        //NavigationBar 的背景，使用了View
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
        
        bgView.backgroundColor = partyRed
        self.view.addSubview(bgView)
        
        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    func submit() {
        
        guard !(titleTextField.text?.isEmpty)! else {
            MsgDisplay.showErrorMsg("标题不能为空")
            return
        }
        
        guard !(contentTextView.text?.isEmpty)! else {
            MsgDisplay.showErrorMsg("内容不能为空")
            return
        }
        
        Applicant.sharedInstance.handIn(titleTextField.text!, content: contentTextView.text!, fileType: type!, doSomething: {
            //print("dooooo!")
            self.navigationController?.popViewControllerAnimated(true)
        })
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //FIXME: use database!
        NSUserDefaults.standardUserDefaults().setObject(titleTextField.text, forKey: "PartyHandInTitleText")
        NSUserDefaults.standardUserDefaults().setObject(contentTextView.text, forKey: "PartyHandInContentText")
        super.viewWillDisappear(animated)
    }
    

}