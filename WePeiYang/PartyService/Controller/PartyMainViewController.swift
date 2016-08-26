//
//  PartyMainViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/9/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit
import SnapKit

let partyRed = UIColor(colorLiteralRed: 240.0/255.0, green: 22.0/255.0, blue: 22.0/255.0, alpha: 1.0)


class PartyMainViewController: UIViewController {

    //let personalStatusButton = UIButton(title: "查看个人进度")
    
    let functionList = ["查看个人状态", "考试报名", "课程列表", "成绩查询", "递交文件"]
    /*
    let functionList = [["icon": "考试报名", "desc": "考试报名"],
                        ["icon": "课程列表", "desc": "课程列表"],
                        ["icon": "成绩查询", "desc": "成绩查询"]]
    */
    let titleLabel = UILabel(text: "党建生活", color: .whiteColor())
    let headerView = UIView(color: partyRed)
    var headerWaveView = WXWaveView()
    
    let anAvatar = UIImageView()
    
    let functionTableView = UITableView()
    
    //FIXME: 如果直接使用 Applicant.sharedInstance.realName! 会直接 found nil
    /*var aNameLabel: UILabel = {
        guard let foo = Applicant.sharedInstance.realName else {
            return UILabel(text: "获取姓名失败", color: .whiteColor())
        }
        return UILabel(text: foo, color: .whiteColor())
    }()*/
    
    var aNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //personalStatusButton.addTarget(self, action: #selector(PartyMainViewController.personalStatusButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        functionTableView.delegate = self
        functionTableView.dataSource = self
        functionTableView.tableFooterView = UIView()
        
        titleLabel.font = UIFont.boldSystemFontOfSize(20.0)
        navigationItem.titleView = titleLabel
        
        anAvatar.clipsToBounds = true
        anAvatar.image = UIImage(named: "partyAvatar")
        anAvatar.layer.cornerRadius = 44
        for subview in anAvatar.subviews {
            subview.layer.cornerRadius = 44
        }
        
        let shadowPath = UIBezierPath(rect: anAvatar.bounds)
        anAvatar.layer.shadowColor = UIColor.blackColor().CGColor
        anAvatar.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        anAvatar.layer.shadowOpacity = 0.8
        anAvatar.layer.shadowPath = shadowPath.CGPath
        anAvatar.layer.shadowRadius = 4
        
        if let foo = NSUserDefaults.standardUserDefaults().objectForKey("studentName") as? String {
            aNameLabel = UILabel(text: foo, color: .whiteColor())
        } else {
            aNameLabel = UILabel(text: "获取姓名失败", color: .whiteColor())
        }
        aNameLabel.font = UIFont.boldSystemFontOfSize(18)

        //headerView.layer.shadowOffset = CGSizeMake(0, 4);
        //headerView.layer.shadowRadius = 5;
        //headerView.layer.shadowOpacity = 0.5;
        headerView.userInteractionEnabled = true
        
        computeLayout()
        wave()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.jz_navigationBarBackgroundAlpha = 0
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        guard Applicant.sharedInstance.realName != nil else {
            //log.word("not found")/
            return
        }
    }
    
    

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: TableView Delegate Methods
extension PartyMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    //TODO: functionTableView delegate methods
    //TODO: all sorts of functions: SignUp | CourseList | ScoreInfoList | NotificationList
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return FunctionListTableViewCell(iconName: "partyBtn", desc: functionList[indexPath.row])
        //return FunctionListTableViewCell(iconName: functionList[indexPath.row]["icon"], desc: functionList[indexPath.row]["desc"])
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            let personalStatusVC = PartyPersonalStatusViewController()
            navigationController?.showViewController(personalStatusVC, sender: nil)
        }
        
        //考试报名
        if indexPath.row == 1 {
            let signupVC = PartySignUpViewController()
            navigationController?.showViewController(signupVC, sender: nil)
        }
        
        //党课学习
        if indexPath.row == 2 {
            let courseVC = PartyCoursesViewController()
            navigationController?.showViewController(courseVC, sender: nil)
        }
        
        //成绩查询
        if indexPath.row == 3 {
            let personalStatusVC = PartyScoreViewController()
            navigationController?.showViewController(personalStatusVC, sender: nil)

        }
        
        //递交文件
        if indexPath.row == 4 {
            let partyHandInVC = PartyHandInViewController(nibName: "PartyHandInViewController", bundle: nil)
            navigationController?.showViewController(partyHandInVC, sender: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, 2))
        
        return footerView
    }
}

//MARK: Snapkit Layout
extension PartyMainViewController {
    
    func computeLayout() {
        
        headerView.addSubview(anAvatar)
        anAvatar.snp_makeConstraints {
            make in
            make.centerX.equalTo(headerView)
            make.centerY.equalTo(headerView.snp_centerY).offset(20)
            make.width.height.equalTo(88)
        }
        
        
        headerView.addSubview(aNameLabel)
        aNameLabel.snp_makeConstraints {
            make in
            make.top.equalTo(anAvatar.snp_bottom).offset(12)
            make.centerX.equalTo(headerView.snp_centerX)
        }
        
        
        
        //headerView.addSubview(personalStatusButton)
        /*personalStatusButton.snp_makeConstraints {
            make in
            make.centerY.equalTo(anAvatar)
            make.left.equalTo(anAvatar.snp_right).offset(5)
        }*/
        
    
        
        view.addSubview(headerView)
        headerView.snp_makeConstraints {
            make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(aNameLabel.snp_bottom).offset(20)
        }
        
        //self.headerWaveView = WXWaveView.addToView(headerView, withFrame: CGRect(x: 0, y: headerView.bounds.height - 10, width: headerView.bounds.width, height: 10))
        
        
        //self.functionTableView.tableHeaderView = headerView
        view.addSubview(functionTableView)
        functionTableView.snp_makeConstraints{
            make in
            make.top.equalTo(headerView.snp_bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        headerView.addSubview(headerWaveView)
        headerWaveView.snp_makeConstraints {
            make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(functionTableView.snp_top).offset(-10)
            make.height.equalTo(10)
        }
        //log.any(CGRectGetHeight(functionTableView.frame))/
        
    }
}

//MARK: Button tapped functions
extension PartyMainViewController {
    /*func personalStatusButtonTapped(sender: UIButton!) {

        let personalStatusVC = PartyPersonalStatusViewController()
        navigationController?.showViewController(personalStatusVC, sender: nil)

    }*/
    
    func wave() {

        self.headerWaveView.waveColor = .whiteColor()
        self.headerWaveView.waveTime = 0.0
        self.headerWaveView.wave()
        
    }
}


// This class uses gloabl extensions  below.
/*
extension UILabel {
    convenience init(text: String, color: UIColor) {
        self.init()
        self.text = text
        textColor = color
        self.sizeToFit()
    }
}

extension UIView {
    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }
}

extension UIButton {
    convenience init(title: String) {
        self.init()
        setTitle(title, forState: .Normal)
        titleLabel?.sizeToFit()
    }
}
*/