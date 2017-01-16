//
//  CourseAppraiseViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 2017/1/13.
//  Copyright © 2017年 Qin Yubo. All rights reserved.
//

import Foundation
import SnapKit

class CourseAppraiseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CourseAppraiseCellDelegate {
    
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .Grouped)
    let identifier = "appraise"
    let questionArray = ["总体评价——综合考虑您认为该老师的教学如何？",
                         "教学态度——为人师表、备课认真、教学有激情、热爱学生等。",
                         "教学内容——内容充实，设计合理，结合学科前沿，重点突出，思路清晰等。",
                         "教学方法与手段——采用启发式、互动式教学，教材选用得当，多媒体或板书运用合理，作业批改与答疑认真等。",
                         "教学效果——通过教学，学生对课堂知识的掌握情况",
                         "意见或建议——为了进一步提高教师的授课效果，您认为教师需要改进的地方是：(限50字)"]
    
    var note = ""
    var shouldLoadDetail = false
    var data: GPAClassData?
    var GPASession: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(data?.evaluate)
        //初始化课程数据
        guard let dict = data?.evaluate as? Dictionary<String, AnyObject>,
        let lesson_id = dict["lesson_id"] as? String,
        let union_id = dict["union_id"] as? String,
        let course_id = dict["course_id"] as? String,
        let term = dict["term"] as? String
            else {
                MsgDisplay.showErrorMsg("获取课程信息失败")
                return
        }
        print("yay")
         CourseAppraiseManager.shared.setInfo(lesson_id, union_id: union_id, course_id: course_id, term: term, GPASession: GPASession!)
        
        //View
        self.navigationItem.title = "评价";
        let rightButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(finishEvaluate))
        self.navigationItem.rightBarButtonItem = rightButton
        
        view.addSubview(tableView)
        tableView.snp_makeConstraints {
            make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        registerForKeyboardNotifications()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("handleTap:")))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: tableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if shouldLoadDetail {
                return 5
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = CourseAppraiseCell(title: questionArray[0], style: .main, id: 4)
            cell.delegate = self
            return cell
        } else {
            switch indexPath.row {
            case 0:
                let cell = CourseAppraiseCell(title: questionArray[1], style: .normal, id: 0)
                return cell
            case 1:
                let cell = CourseAppraiseCell(title: questionArray[2], style: .normal, id: 1)
                return cell
            case 2:
                let cell = CourseAppraiseCell(title: questionArray[3], style: .normal, id: 2)
                return cell
            case 3:
                let cell = CourseAppraiseCell(title: questionArray[4], style: .normal, id: 3)
                return cell
            case 4:
                let cell = CourseAppraiseCell(title: questionArray[5], style: .edit, id: 5)
                return cell
            default:
                let cell = CourseAppraiseCell()
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            switch indexPath.row {
            case 2:
                return 128
            case 4:
                return 216
            default:
                return 100
            }
        }
    }
    
    //MARK: tableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //MARK: CourseAppraiseCellDelegate
    func loadDetail() {
        if shouldLoadDetail == false {
            shouldLoadDetail = true
            CourseAppraiseManager.shared.detailAppraiseEnabled = true
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Middle)
        }
    }
    
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func finishEvaluate() {
        CourseAppraiseManager.shared.submit({
            self.navigationController?.popViewControllerAnimated(true)
            // fetch data and refresh chartView
            NSNotificationCenter.defaultCenter().postNotificationName("NOTIFICATION_APPRAISE_SUCCESSED", object: nil)
        })
    }
        
    func keyboardWillShow(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.frame.origin.y = -keyboardHeight
        })
    }
        
    func keyboardWillHide(notification:NSNotification) {
        UIView.animateWithDuration(0.5, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        tableView.endEditing(true)
    }
    
}
