//
//  ClassDetailViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/17.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class ClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var classData: ClassData!
    var classColor: UIColor!
    @IBOutlet weak var detailTableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.contentSizeInPopup = CGSizeMake(300, 400)
        self.landscapeContentSizeInPopup = CGSizeMake(400, 260)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "详情"
        self.detailTableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return classData.arrange.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "identifier")
        }
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            switch row {
            case 0:
                cell?.textLabel?.text = "课程"
                cell?.detailTextLabel?.text = classData.courseName
            case 1:
                cell?.textLabel?.text = "教师"
                cell?.detailTextLabel?.text = classData.teacher
            case 2:
                cell?.textLabel?.text = "学院"
                cell?.detailTextLabel?.text = classData.college
            case 3:
                cell?.textLabel?.text = "分类"
                cell?.detailTextLabel?.text = classData.courseType
            case 4:
                cell?.textLabel?.text = "学分"
                cell?.detailTextLabel?.text = classData.credit
            case 5:
                cell?.textLabel?.text = "类型"
                cell?.detailTextLabel?.text = classData.courseNature
            case 6:
                cell?.textLabel?.text = "编号"
                cell?.detailTextLabel?.text = classData.courseId
            case 7:
                cell?.textLabel?.text = "班级"
                cell?.detailTextLabel?.text = classData.classId
            case 8:
                cell?.textLabel?.text = "校区"
                cell?.detailTextLabel?.text = classData.campus
            case 9:
                cell?.textLabel?.text = "时间"
                cell?.detailTextLabel?.text = "第\(classData.weekStart)周至第\(classData.weekEnd)周"
            default:
                break
            }
        } else {
            let arrange = classData.arrange[section - 1]
            switch row {
            case 0:
                cell?.textLabel?.text = "周数"
                cell?.detailTextLabel?.text = "\(arrange.week)周\(arrange.day)"
            case 1:
                cell?.textLabel?.text = "时间"
                cell?.detailTextLabel?.text = "第\(arrange.start)节至第\(arrange.end)节"
            case 2:
                cell?.textLabel?.text = "地点"
                cell?.detailTextLabel?.text = arrange.room
            default:
                break
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "基本信息"
        case 1:
            return "课程安排"
        default:
            return ""
        }
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
