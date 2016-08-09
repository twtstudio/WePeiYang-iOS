//
//  BicycleUserBindViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class BicycleUserBindViewController: UIViewController {
    
    @IBOutlet var IDTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func confirmButton(sender: UIButton) {
        
        guard !(IDTextField.text?.isEmpty)! else {
            MsgDisplay.showErrorMsg("身份证号不能为空")
            return
        }
        
        BicycleUser.sharedInstance.getCardlist(IDTextField.text!, doSomething: {
            let cardListVC = BicycleCardListViewController(style: .Grouped)
            self.navigationController?.pushViewController(cardListVC, animated: true)
        })
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        log.word("cancel")/
        BicycleUser.sharedInstance.bindCancel = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}