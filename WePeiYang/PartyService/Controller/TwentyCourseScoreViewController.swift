//
//  TwentyCourseScoreViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class TwentyCourseScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var scoreList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Applicant.sharedInstance.get20score({
            self.scoreList = Applicant.sharedInstance.scoreOf20Course
            self.tableView.reloadData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(Applicant.sharedInstance.scoreOf20Course.count)
        return scoreList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let dict = scoreList[indexPath.row]
        let cell = ScoreTableViewCell(title: dict.objectForKey("course_name") as! String, score: dict.objectForKey("score") as! String, completeTime: dict.objectForKey("complete_time") as! String)
        
        cell.selectionStyle = .None
        //cell?.textLabel?.text = Applicant.sharedInstance.scoreOf20Course[indexPath.row].objectForKey("course_name")
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, height: 40))
        
        let titleLabel = UILabel(text: "课程名称")
        let scoreLabel = UILabel(text: "成绩")
        let timeLabel = UILabel(text: "完成时间")
        
        titleLabel.font = UIFont.boldSystemFontOfSize(13.0)
        scoreLabel.font = UIFont.boldSystemFontOfSize(13.0)
        timeLabel.font = UIFont.boldSystemFontOfSize(13.0)
        
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(timeLabel)
        
        timeLabel.snp_makeConstraints {
            make in
            make.right.equalTo(view).offset(-8)
            make.centerY.equalTo(view)
        }
        
        scoreLabel.snp_makeConstraints {
            make in
            make.right.equalTo(timeLabel.snp_left).offset(-56)
            make.centerY.equalTo(view)
        }
        
        titleLabel.snp_makeConstraints {
            make in
            make.left.equalTo(view).offset(8)
            make.centerY.equalTo(view)
            
        }
        
        return view
        
    }
}