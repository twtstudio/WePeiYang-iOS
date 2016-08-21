//
//  PartySignUpViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/18/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class PartySignUpViewController: UIViewController {
    
    var tableView: UITableView!
    let bgView = UIView(color: partyRed)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        
        self.view.frame.size.width = (UIApplication.sharedApplication().keyWindow?.frame.size.width)!
        
        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        //NavigationBar 的背景，使用了View
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;

        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        //改变背景颜色
        view.backgroundColor = UIColor(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ApplicantTest.ApplicantEntry.getStatus {
            ApplicantTest.AcademyEntry.getStatus {
                log.any(ApplicantTest.ApplicantEntry.status)/
                log.any(ApplicantTest.ApplicantEntry.message)/
                log.any(ApplicantTest.AcademyEntry.status)/
                log.any(ApplicantTest.AcademyEntry.message)/
                self.tableView.reloadData()
            }
        }
        computeLayout()
        
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

extension PartySignUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = SignUpTableViewCell(status: ApplicantTest.ApplicantEntry.status, message: ApplicantTest.ApplicantEntry.message, testIdentifier: 0)
                return cell
        case 1:
            let cell = SignUpTableViewCell(status: ApplicantTest.AcademyEntry.status, message: ApplicantTest.AcademyEntry.message, testIdentifier: 1)
                return cell

        case 2:
            let cell = UITableViewCell()
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
            
        }
        

    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "结业考试"
        case 1:
            return "院级积极分子党校"
        case 2:
            return "预备党员党校"
        default:
            return nil
        }
    }
    
    /*
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }*/
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, height: 5))
        
        return footerView
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

}

extension PartySignUpViewController {
    
    func computeLayout() {
        
        self.view.addSubview(bgView)
        bgView.snp_makeConstraints {
            make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp_top).offset((self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
        }
        
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            make in
            make.top.equalTo(bgView.snp_bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
}

extension PartySignUpViewController {
    
    func signUp(forTest identifier: String) {
        log.word(identifier)/
    }
}
