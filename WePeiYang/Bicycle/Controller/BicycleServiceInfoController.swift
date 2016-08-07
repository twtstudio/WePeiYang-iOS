//
//  BicycleServiceInfoController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import JBChartView

class BicycleServiceInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource, JBLineChartViewDelegate, JBLineChartViewDataSource {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let data = [
        ["time":"13:00", "dist":0.5],
        ["time":"14:00", "dist":7.6],
        ["time":"15:00", "dist":2.8],
        ["time":"16:00", "dist":2.1],
        ["time":"17:00", "dist":5.0],
        ["time":"18:00", "dist":6.2],
        ["time":"19:00", "dist":7.4],
        ["time":"20:00", "dist":2.6]
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.frame.size.width = (UIApplication.sharedApplication().keyWindow?.frame.size.width)!
        
        self.tableView.bounces = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置delegate, dataSource
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //UI
        //chartViewBackground
        let background = UIImage(named: "BicyleChartBackgroundImage")
        let backgroundView = UIView(frame: CGRect(x: 8, y: 116, width: (UIApplication.sharedApplication().keyWindow?.frame.size.width)!-16, height: 220))
        backgroundView.layer.cornerRadius = 8.0
        backgroundView.backgroundColor = UIColor(patternImage: background!)
        self.view.addSubview(backgroundView)
        
        //chartView
        let chartView = JBLineChartView(frame: self.calculateChartViewFrame())
        chartView.delegate = self
        chartView.dataSource = self
        chartView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(chartView)
        chartView.reloadData()
        
        self.infoLabel.text = "\(data.last!["time"] as! String)  距离：\(data.last!["dist"] as! Double)m"
        
    }
    
    func calculateChartViewFrame() -> CGRect {
        let x = CGFloat(24)
        let y = CGFloat(132)
        let width = CGFloat((UIApplication.sharedApplication().keyWindow?.frame.size.width)!-48)
        let height = CGFloat(188)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //dataScoure of chartView
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(data.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        
        let res = data[Int(horizontalIndex)]["dist"] as! CGFloat
        return res
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 4.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 2.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, lineStyleForLineAtLineIndex lineIndex: UInt) -> JBLineChartViewLineStyle {
        return JBLineChartViewLineStyle.Dashed
    }
    
    //delegate of chartView
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        self.infoLabel.text = "\(data[Int(horizontalIndex)]["time"] as! String)  骑行距离：\(data[Int(horizontalIndex)]["dist"] as! Double)m"
    }
    
    //dataSource of tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("identifier")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "identifier")
        }
        
        if indexPath.section == 0 {
            cell!.textLabel?.text = "卡号:123123123"
            cell!.selectionStyle = .None
        } else if indexPath.section == 1 {
            cell!.textLabel?.text = "余额:16.5"
            cell!.selectionStyle = .None
        } else if indexPath.section == 2 {
            cell!.textLabel?.text = "查询记录"
        }
        
        return cell!
    }
    
    
    //delegate of tableView
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            MsgDisplay.showErrorMsg("暂时没有这个功能哦")
        }
    }
    
    
}
