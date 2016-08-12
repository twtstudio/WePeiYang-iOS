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
        self.navigationController?.navigationBar.tintColor = nil
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        BicycleUser.sharedInstance.bindCancel = true
        
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
}