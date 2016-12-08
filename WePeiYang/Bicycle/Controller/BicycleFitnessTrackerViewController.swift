//
//  BicycleFitnessTrackerViewController.swift
//  WePeiYang
//
//  Created by Allen X on 12/8/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit
import HealthKitUI


@available(iOS 9.3, *)
class BicycleFitnessTrackerViewController: UIViewController {
    let healthRingView = HKActivityRingView()
    let healthSummary = HKActivitySummary()
    
    let MoveColor = UIColor(colorLiteralRed: 231.0/255.0, green: 23.0/255.0, blue: 61.0/255.0, alpha: 1)
    let ExerciseColor = UIColor(colorLiteralRed: 98/255.0, green: 228/255.0, blue: 42/255.0, alpha: 1)
    let StandColor = UIColor(colorLiteralRed: 34/255.0, green: 207/255.0, blue: 218/255.0, alpha: 1)
    
    var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //NavigationBar 的背景，使用了View
        var bounds = self.navigationController?.navigationBar.bounds as CGRect!
        bounds.offsetInPlace(dx: 0.0, dy: -20.0)
        bounds.size.height = bounds.height + 20.0
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        //If this is not set to false, the back button won't work
        visualEffectView.userInteractionEnabled = false
        self.navigationController?.navigationBar.addSubview(visualEffectView)
        
        //If visualEffectView does not get sent back, it'll cover "back" label
        self.navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for fooView in (self.navigationController?.navigationBar.subviews)! {
            if fooView.isKindOfClass(UIVisualEffectView) {
                fooView.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blackColor()

        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = UIColor(colorLiteralRed: 39.0/255.0, green: 174.0/255.0, blue: 27.0/255.0, alpha: 1)
        
        
        
        tableView = UITableView()
        tableView.backgroundColor = .blackColor()
        tableView.separatorStyle = .None
        
        
        //Eliminate the empty cells
        tableView.tableFooterView = UIView(color: .clearColor())
        tableView.delegate = self
        tableView.dataSource = self
        
        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        getActivitySummary()

        computeLayout()
        
        healthRingView.setActivitySummary(healthSummary, animated: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getActivitySummary() {
        
        //Should create a query to access Health Store
        
        healthSummary.activeEnergyBurned = HKQuantity(unit: HKUnit.calorieUnit(), doubleValue: 300.0)
        healthSummary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.calorieUnit(), doubleValue: 400.0)
        healthSummary.appleStandHours = HKQuantity(unit: HKUnit.countUnit(), doubleValue: 10)
        healthSummary.appleStandHoursGoal = HKQuantity(unit: HKUnit.countUnit(), doubleValue: 12)
        healthSummary.appleExerciseTime = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: 45)
        healthSummary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minuteUnit(), doubleValue: 55)
//        healthRingView.backgroundColor = .whiteColor()
//        healthRingView.setActivitySummary(healthSummary, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


@available(iOS 9.3, *)
extension BicycleFitnessTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return (UIApplication.sharedApplication().keyWindow?.frame.size.width)!
        }
        return 4
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Move"
            cell.textLabel?.textColor = MoveColor
        case 1:
            cell.textLabel?.text = "Exercise"
            cell.textLabel?.textColor = ExerciseColor
        case 2:
            cell.textLabel?.text = "Stand"
            cell.textLabel?.textColor = StandColor
        default:
            break
        }
        cell.contentView.backgroundColor = .blackColor()
        cell.selectionStyle = .None
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section != 0 {
            let headerView = UIView(frame: CGRectMake(0, 0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, 4))
            headerView.backgroundColor = UIColor.clearColor()
            return headerView
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, height: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!))
        
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM, dd, YYYY"
        let dateString = dateFormatter.stringFromDate(currentDate)
        let timeLabel = UILabel(text: dateString, color: .whiteColor())
        
        
        headerView.addSubview(timeLabel)
        timeLabel.snp_makeConstraints {
            make in
            make.centerX.equalTo(headerView)
            make.top.equalTo(headerView).offset(15)
        }
        
        headerView.addSubview(healthRingView)
        healthRingView.snp_makeConstraints {
            make in
            make.top.equalTo(timeLabel.snp_bottom).offset(15)
            make.left.equalTo(headerView).offset(40)
            make.right.equalTo(headerView).offset(-40)
            make.height.equalTo(headerView.frame.width - 80)
        }

        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(color: .clearColor())
    }

}


@available(iOS 9.3, *)
extension BicycleFitnessTrackerViewController {
    func computeLayout() {
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints {
            make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
}
