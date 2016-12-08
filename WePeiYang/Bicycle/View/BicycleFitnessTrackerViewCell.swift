//
//  BicycleFitnessTrackerViewCell.swift
//  WePeiYang
//
//  Created by Allen X on 12/8/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import Foundation
import Charts

enum TrackerCellType {
    case Move
    case Exercise
    case Stand
}

class BicycleFitnessTrackerViewCell: UITableViewCell, ChartViewDelegate {
    
    var lineChartView: LineChartView!
    
    convenience init(cellType: TrackerCellType) {
        self.init()
        
        switch cellType {
        case .Move:
            self.textLabel?.text = "Move"
        case .Exercise:
            self.textLabel?.text = "Exercise"
        case .Stand:
            self.textLabel?.text = "Stand"
        }
        
    }
    
    
    func renderChart() {
        self.lineChartView.delegate = self
        self.lineChartView.descriptionText = ""
        self.lineChartView.noDataTextDescription = "暂无数据可显示"
        self.lineChartView.dragEnabled = true;
        
        //X-Axis Limit Line
        let llXAxis = ChartLimitLine(limit: 10.0, label: "Index 10")
        llXAxis.lineWidth = 4.0
        llXAxis.lineDashLengths = [10.0, 10.0, 0.0]
        llXAxis.labelPosition = .RightBottom
        llXAxis.valueFont = UIFont.systemFontOfSize(10.0)
        lineChartView.xAxis.addLimitLine(llXAxis)
        
        //Y-Axis Limit Line
        let ll1 = ChartLimitLine(limit: 50.0, label: "Lower Limit")
        ll1.lineWidth = 4.0
        ll1.lineDashLengths = [5.0, 5.0]
        ll1.labelPosition = .RightBottom
        ll1.valueFont = UIFont.systemFontOfSize(10.0)
        
        let ll2 = ChartLimitLine(limit: 350.0, label: "Upper Limit")
        ll2.lineWidth = 4.0
        ll2.lineDashLengths = [5.0, 5.0]
        ll2.labelPosition = .RightTop
        ll2.valueFont = UIFont.systemFontOfSize(10.0)
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaxValue = 500.0
        leftAxis.axisMinValue = 0.0
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.drawZeroLineEnabled = false;
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        lineChartView.rightAxis.enabled = false
        
        lineChartView.legend.form = .Line
        
        lineChartView.animate(xAxisDuration: 2.5, easingOption: .EaseInOutQuart)
    }
    
    func setDataCount(count: Int, range: Double) {
        var xVals: [String?] = []
        for i in 0..<count {
            xVals.append("\(i+1)")
        }
        lineChartView.data?.xVals = xVals
    }
    
    func insertData(yVals: [String?]) {
        
    }
}
