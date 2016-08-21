//
//  PartyComplainViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/16.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class PartyComplainViewController: UIViewController {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var contentField: UITextView!
    var testID: String?
    var testType: String?
    
    convenience init(ID: String, type: String) {
        self.init()
        
        self.testID = ID
        self.testType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(PartyComplainViewController.complain))
        
        self.navigationItem.rightBarButtonItem = doneButton
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
    
    func complain() {
        
        guard !(titleField.text?.isEmpty)! else {
            MsgDisplay.showErrorMsg("标题不能为空")
            return
        }
        
        guard !(contentField.text?.isEmpty)! else {
            MsgDisplay.showErrorMsg("内容不能为空")
            return
        }
        
        Applicant.sharedInstance.complain(testID!, testType: testType!, title: titleField.text!, content: contentField.text!, doSomething: {
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
}