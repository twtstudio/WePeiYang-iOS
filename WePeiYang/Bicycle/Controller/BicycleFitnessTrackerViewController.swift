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
    
    var tableView: UITableView!
    var calorieLabel: UILabel!
    var standingHourLabel: UILabel!
    var exerciseTimeLabel: UILabel!
    
    var frostBGView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blackColor()

        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = bicycleGreen
        
        //NavigationBar 的背景，使用了View
        var bounds = self.navigationController?.navigationBar.bounds as CGRect!
        bounds.offsetInPlace(dx: 0.0, dy: -20.0)
        bounds.size.height = bounds.height + 20.0
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.navigationController?.navigationBar.addSubview(visualEffectView)
        self.navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
        
        tableView = UITableView()
        tableView.backgroundColor = .blackColor()
        
        //Eliminate the empty cells
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        getActivitySummary()

        computeLayout()
        
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
        healthRingView.setActivitySummary(healthSummary, animated: true)
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Calories Burnt"
            cell.textLabel?.textColor = .whiteColor()
        case 1:
            cell.textLabel?.text = "Exercise Time"
            cell.textLabel?.textColor = .whiteColor()
        case 2:
            cell.textLabel?.text = "Standing Hour"
            cell.textLabel?.textColor = .whiteColor()
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
        headerView.addSubview(healthRingView)
        healthRingView.snp_makeConstraints {
            make in
            make.top.equalTo(headerView).offset(30)
            make.left.equalTo(headerView).offset(40)
            make.right.equalTo(headerView).offset(-40)
            make.height.equalTo(headerView.frame.width - 80)
        }
        
        return headerView
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
