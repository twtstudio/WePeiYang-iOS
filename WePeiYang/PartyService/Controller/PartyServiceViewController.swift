//
//  PartyServiceViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class PartyServiceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Applicant.sharedInstance.getStudentNumber();
        
        //Applicant.sharedInstance.studentNumber = "3015218062"
        //Applicant.sharedInstance.getPersonalStatus()
        
        //Applicant.sharedInstance.getAcademyGrade()
        
        let button = UIButton(frame: CGRectMake(300, 300, 300, 300))
        button.setTitle("普通状态", forState:UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(),forState: .Normal)
        button.addTarget(self, action:#selector(PartyServiceViewController.test), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        log.word(PartyAPI.studentID!)/
        
    }
    
    func test() {
        Applicant.sharedInstance.testFunc()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
