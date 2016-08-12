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

    let personalStatusButton = UIButton()
    
    let functionList = ["考试报名", "课程列表", "成绩查询"]
    
    let titleLabel = UILabel(text: "党建生活", color: .whiteColor())
    let aTable = UITableView()
    //let headerView = UIView()
    let headerView = UIView(color: partyRed)
    let anAvatar = UIView()
    
    let functionTableView = UITableView()
    
    //FIXME: 如果直接使用 Applicant.sharedInstance.realName! 会直接 found nil
    var aName: String {
        guard let foo = Applicant.sharedInstance.realName else {
            return "获取姓名失败"
        }
        return foo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalStatusButton.addTarget(self, action: #selector(PartyMainViewController.personalStatusButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        functionTableView.delegate = self
        functionTableView.dataSource = self
        
        //TEST: API test
        var course = Courses.Study20.Study20Course(courseID: "42", courseName: "FUCK", courseDetails: [nil], courseScore: nil)
        course.getCourseDetail(of: course.courseID, and: {
            print("hello")
        })
        
        
        titleLabel.font = UIFont.boldSystemFontOfSize(20.0)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        let aNameLabel = UILabel(text: aName, color: .whiteColor())
        aNameLabel.font = UIFont.boldSystemFontOfSize(18)
        
        anAvatar.layer.cornerRadius = 44
        anAvatar.backgroundColor = UIColor.yellowColor()
        
        headerView.addSubview(anAvatar)
        headerView.addSubview(aNameLabel)
        anAvatar.snp_makeConstraints {
            make in
            make.centerX.equalTo(headerView)
            make.centerY.equalTo(headerView.snp_centerY).offset(20)
            make.width.height.equalTo(88)
        }
        aNameLabel.snp_makeConstraints {
            make in
            make.top.equalTo(anAvatar.snp_bottom).offset(12)
            make.centerX.equalTo(headerView.snp_centerX)
        }
 
        headerView.layer.shadowOffset = CGSizeMake(0, 4);
        headerView.layer.shadowRadius = 5;
        headerView.layer.shadowOpacity = 0.5;
        
        view.addSubview(headerView)
        view.addSubview(functionTableView)
        
        headerView.snp_makeConstraints {
            make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(aNameLabel.snp_bottom).offset(20)
        }
        functionTableView.snp_makeConstraints{
            make in
            make.top.equalTo(headerView.snp_bottom).offset(10)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            
        }
        
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


//MARK: TableView Delegate Methods
extension PartyMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    //TODO: functionTableView delegate methods
    //TODO: all sorts of functions: SignUp | CourseList | ScoreInfoList | NotificationList
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return functionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return FunctionListTableViewCell(iconName: "partyBtn", desc: functionList[indexPath.row])
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

//MARK: Button tapped functions
extension PartyMainViewController {
    func personalStatusButtonTapped(sender: UIButton!) {
        
        //uncomment this after you create the PersonalStatusViewController
        /*
        let personalStatusVC = PersonalStatusViewController()
        navigationController?.showViewController(personalStatusVC, sender: nil)
        */
    }
}

// This class uses gloabl extensions below.
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
*/