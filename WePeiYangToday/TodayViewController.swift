//
//  TodayViewController.swift
//  WePeiYangToday
//
//  Created by 秦昱博 on 14/10/25.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var nextLabel: UILabel!
    var courseLabel: UILabel!
    var detailLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.preferredContentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 72)
        
        nextLabel = UILabel(frame: CGRectMake(0, 5, UIScreen.mainScreen().bounds.size.width - 10, 20))
        nextLabel.text = ""
        nextLabel.font = UIFont.systemFontOfSize(13.0)
        nextLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(nextLabel)
        
        courseLabel = UILabel(frame: CGRectMake(0, 30, UIScreen.mainScreen().bounds.size.width - 10, 20))
        courseLabel.text = ""
        courseLabel.font = UIFont.systemFontOfSize(17.0)
        courseLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(courseLabel)
        
        detailLabel = UILabel(frame: CGRectMake(0, 55, UIScreen.mainScreen().bounds.size.width - 10, 20))
        detailLabel.text = ""
        detailLabel.font = UIFont.systemFontOfSize(15.0)
        detailLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(detailLabel)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadClassData()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func loadClassData() {
        let userDefault = NSUserDefaults(suiteName: "group.WePeiYang")
        
        if userDefault?.objectForKey("Classtable") == nil {
            nextLabel.text = ""
            courseLabel.text = "您尚未抓取过课程表哦QAQ"
            detailLabel.text = "请进入微北洋 -> 关于 -> 抓取课程表"
        } else {
            nextLabel.text = ""
            courseLabel.text = ""
            detailLabel.text = ""
            
            let now = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitWeekday, fromDate: now)
            var weekday = components.weekday
            //var week = components.week
            //转换Cocoa weekday与twt weekday
            if weekday == 1 {
                weekday = 7
            } else {
                weekday = weekday - 1
            }
            println("\(weekday)")
            
            var currentClass = self.getCurrentClass()
            
            //测试数据
            //let thisWeek = 5
            
            let thisWeek = self.getCurrentWeek()
            println("\(thisWeek)")
            
            var thisWeekIsDanZhou: Bool //这周是不是单周
            
            if thisWeek % 2 == 0 {
                thisWeekIsDanZhou = false
            } else {
                thisWeekIsDanZhou = true
            }
            
            var classesToday = NSMutableArray()
            
            var classData = userDefault?.objectForKey("Classtable") as NSArray
            
            for classItem in classData {
                
                //安排课的
                if classItem["arrange"] as NSArray == [] {
                    continue
                } else {
                    
                    //始末周判断
                    let startEndDic = classItem["startend"] as NSDictionary
                    
                    var startStr = startEndDic["start"] as NSString
                    var endStr = startEndDic["end"] as NSString
                    
                    var startWeek = startStr.integerValue
                    var endWeek = endStr.integerValue

                    if thisWeek < startWeek || thisWeek > endWeek {
                        continue
                    } else {
                        
                        //单双周判断
                        let arrangeArr = classItem["arrange"] as NSArray
                        for singleArrange in arrangeArr {
                            if (singleArrange["weektimes"] as NSString == "单周" && thisWeekIsDanZhou == false) || (singleArrange["weektimes"] as NSString == "双周" && thisWeekIsDanZhou == true) {
                                continue
                            } else {
                                
                                //weekday判断
                                var weekDayStr = singleArrange["weekday"] as NSString
                                var weekDayInt = weekDayStr.integerValue
                                if weekday == weekDayInt {
                                    
                                    classesToday.addObject(classItem)
                                    
                                    //currentClass判断
                                    var fromStr = singleArrange["from"] as NSString
                                    var toStr = singleArrange["to"] as NSString
                                    var fromNum = fromStr.integerValue
                                    var toNum = toStr.integerValue
                                    
                                    if currentClass == 12 {
                                        
                                        //显示结束
                                        nextLabel.text = ""
                                        courseLabel.text = "您今天没有课程了"
                                        detailLabel.text = "请好好休息吧"
                                    } else {
                                        if currentClass % 2 == 0 {
                                            
                                            //currentClass是偶数，则显示下一节课
                                            
                                            if fromNum == currentClass + 1 {
                                                nextLabel.text = "第\(fromNum)节至第\(toNum)节"
                                                var courseName = classItem["coursename"] as NSString
                                                var teacher = classItem["teacher"] as NSString
                                                var room = singleArrange["room"] as NSString
                                                courseLabel.text = "\(courseName)"
                                                detailLabel.text = "\(teacher)  \(room)"
                                            } else {
                                                continue
                                            }
                                        } else {
                                            
                                            //currentClass是奇数，则显示这节课
                                            
                                            if fromNum == currentClass {
                                                nextLabel.text = "第\(fromNum)节至第\(toNum)节"
                                                var courseName = classItem["coursename"] as NSString
                                                var teacher = classItem["teacher"] as NSString
                                                var room = singleArrange["room"] as NSString
                                                courseLabel.text = "\(courseName)"
                                                detailLabel.text = "\(teacher)  \(room)"
                                            } else {
                                                continue
                                            }
                                        }
                                    }
                                } else {
                                    continue
                                }
                            }
                        }
                    }
                }
            }
            
            //要是没课的话加载最近的一节
            if courseLabel.text == "" {
                var nearestFrom = 12
                var nearestClass: AnyObject?
                var nearestArrange: AnyObject?
                
                if classesToday.count != 0 {
                    for todayClassItem in classesToday {
                        let todayArrange = todayClassItem["arrange"] as NSArray
                        for todaySingleArrange in todayArrange {
                            
                            let arrangeWeekday = todaySingleArrange["weekday"] as NSString
                            let arrangeWeekdayInt = arrangeWeekday.integerValue
                            
                            if arrangeWeekdayInt == weekday {
                                let todayFromStr = todaySingleArrange["from"] as NSString
                                let todayFromInt = todayFromStr.integerValue
                                
                                if todayFromInt <= currentClass {
                                    continue
                                } else {
                                    var deltaClass = todayFromInt - currentClass
                                    if deltaClass <= nearestFrom {
                                        nearestFrom = deltaClass
                                        nearestClass = todayClassItem
                                        nearestArrange = todaySingleArrange
                                    } else {
                                        continue
                                    }
                                }
                                
                            } else {
                                continue
                            }
                        }
                    }
                }
                
                if nearestClass != nil {
                    //显示
                    let nearestFromStr = nearestArrange!["from"] as NSString
                    let nearestToStr = nearestArrange!["to"] as NSString
                    
                    let courseName = (nearestClass! as NSDictionary)["coursename"] as NSString
                    let teacher = (nearestClass! as NSDictionary)["teacher"] as NSString
                    let room = nearestArrange!["room"] as NSString
                    nextLabel.text = "第\(nearestFromStr)节至第\(nearestToStr)节"
                    courseLabel.text = "\(courseName)"
                    detailLabel.text = "\(teacher)  \(room)"
                }
            }
            
            //还没课的话那就真没课了
            if courseLabel.text == "" {
                nextLabel.text = ""
                courseLabel.text = "暂时好像没有要上的课咯~"
                detailLabel.text = ""
            }
        }
    }
    
    //获取当前节数
    func getCurrentClass() -> NSInteger {
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond | .CalendarUnitWeekday, fromDate: now)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let weekday = components.weekday
        
        //println("\(year,month,day)")
        
        if (hour < 8) {
            return 0
        } else if (hour == 8 && minute >= 0 && minute <= 45) {
            return 1
        } else if ((hour == 8 && minute > 45) || (hour == 9 && minute <= 55)) {
            return 2
        } else if ((hour == 9 && minute > 55) || (hour == 10 && minute <= 40)) {
            return 3
        } else if ((hour == 10 && minute > 40) || hour == 11 || hour == 12 || hour == 13 || hour < 14) {
            return 4
        } else if (hour == 14 && minute >= 0 && minute <= 45) {
            return 5
        } else if ((hour == 14 && minute > 45) || (hour == 15 && minute <= 55)) {
            return 6
        } else if ((hour == 15 && minute > 55) || (hour == 16 && minute <= 40)) {
            return 7
        } else if ((hour == 16 && minute > 40) || hour == 17 || hour == 18 || hour < 19) {
            return 8
        } else if (hour == 19 && minute >= 0 && minute <= 45) {
            return 9
        } else if ((hour == 19 && minute > 45) || (hour == 20 && minute <= 55)) {
            return 10
        } else if ((hour == 20 && minute > 55) || (hour == 21 && minute <= 40)) {
            return 11
        } else {
            return 12
        }
    }
    
    func getCurrentWeek() -> NSInteger {
        //计算这是本学期第几周
        
        let calendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 2
        let now = NSDate()
        let comps = calendar.components(NSCalendarUnit.CalendarUnitWeekOfYear | .CalendarUnitYear, fromDate: now)
        let thisWeekOfYear = comps.weekOfYear
        let thisYear = comps.year
      
        let userDefault = NSUserDefaults(suiteName: "group.WePeiYang")
        var startTime = userDefault?.objectForKey("StartTime") as NSDictionary
        var startTimeStr = startTime["start"] as NSString
        //println(startTimeStr)
        if startTimeStr == "" {
            startTimeStr = "2014-09-01"
        }
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let termBeginDate = dateFormatter.dateFromString(startTimeStr)
        let termBeginComps = calendar.components(NSCalendarUnit.CalendarUnitWeekOfYear | .CalendarUnitYear, fromDate: termBeginDate!)
        let termBeginWeekOfYear = termBeginComps.weekOfYear
        let termBeginYear = termBeginComps.year
        
        if thisYear == termBeginYear {
            let thisWeek = thisWeekOfYear - termBeginWeekOfYear + 1
            return thisWeek
        } else {
            let termBeginYearLastDay = dateFormatter.dateFromString("\(termBeginYear)/12/31")
            let endOfYearComps = calendar.components(NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitWeekday, fromDate: termBeginYearLastDay!)
            let endOfYearWeekday = endOfYearComps.weekday
            let endOfYearWeek = endOfYearComps.weekOfYear
            if endOfYearWeekday == 1 {
                //年末是周日的话
                let thisWeek = endOfYearWeek - termBeginWeekOfYear + 1 + thisWeekOfYear
                return thisWeek
            } else {
                //年末不是周日的话
                let thisWeek = endOfYearWeek - termBeginWeekOfYear + thisWeekOfYear
                return thisWeek
            }
        }
        
    }
    
}
