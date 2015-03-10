//
//  StudySearchViewController.swift
//  WePeiYang
//
//  Created by 秦昱博 on 14/10/8.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit

class StudySearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIPickerViewAccessibilityDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var studysearchPickerView:UIPickerView!
    @IBOutlet weak var searchResultTableView:UITableView!
    @IBOutlet weak var backgroundImg: UIView!
    
    var searchResultArray = NSMutableArray()
    var daySelected = 0
    var startTimeArr = Array<String>()
    var endTimeArr = Array<String>()
    var buildingsArr = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // self.navigationController!.interactivePopGestureRecognizer.delegate = self
        
        self.searchResultTableView.backgroundColor = UIColor.clearColor()
        self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.backgroundImg.backgroundColor = UIColor(red: 0/255, green: 127/255, blue: 191/255, alpha: 1.0)
        UIButton.appearance().tintColor = UIColor.whiteColor()
        UISegmentedControl.appearance().tintColor = UIColor.whiteColor()
        
        startTimeArr = ["08:00", "08:30", "09:00", "09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00"]
        endTimeArr = startTimeArr
        buildingsArr = ["04楼","05楼","08楼","12楼","15楼","19楼","23楼","24楼","26楼A区","26楼B区","西阶"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleControls(sender:AnyObject) {
        daySelected = sender.selectedSegmentIndex
        self.searchResultArray.removeAllObjects()
        self.searchResultTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    @IBAction func backToHome() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func studySearch() {
        
        MsgDisplay.showLoading()
        
        let startTimeSelected = studysearchPickerView.selectedRowInComponent(0) as Int
        let endTimeSelected = studysearchPickerView.selectedRowInComponent(1) as Int
        let buildingSelected = buildingsArr[studysearchPickerView.selectedRowInComponent(2)] as String
        
        if (startTimeSelected >= endTimeSelected) {
            self.searchResultArray.removeAllObjects()
            self.searchResultTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            MsgDisplay.showErrorMsg("您的时间选择有点错误哦~")
            
        } else {
            var timeConvertResult = self.convertTimeWithStartTime(startTimeSelected, endTimeSelected: endTimeSelected)
            var buildingConvertResult = self.convertBuildingStringWith(buildingSelected)
            
            if (searchResultArray.count>0) {
                searchResultArray.removeAllObjects()
            }
            
            let url = twtAPIs.studySearch()
            let parameters = ["day":daySelected, "class":timeConvertResult, "building":buildingConvertResult, "platform":"ios", "version":data.shareInstance().appVersion]
            
            var manager = AFHTTPRequestOperationManager()
            manager.POST(url, parameters: parameters, success: {
                (AFHTTPRequestOperation operation, AnyObject responseObject) in
                MsgDisplay.dismiss()
                self.processReceivedData(responseObject as NSArray)
                
            }, failure: {
                (AFHTTPRequestOperation operation, NSError error) in
                MsgDisplay.showErrorMsg("加载失败")
            })
            
        }
    }
    
    
    func processReceivedData(dic: NSArray) {
        var convertData = dic as NSArray
        if (convertData.count > 0) {
            for temp in convertData {
                searchResultArray.addObject(temp["room"] as NSString)
                //println(temp["room"] as NSString)
            }
            self.searchResultTableView.hidden = false
            self.searchResultTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            self.searchResultTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                    
                    
        } else {
            
            self.searchResultArray.removeAllObjects()
            self.searchResultArray.addObject("")
            self.searchResultArray.addObject("暂无可用自习室_(:з」∠)_")
            self.searchResultTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }

    }

    func convertTimeWithStartTime(startTimeSelected:Int, endTimeSelected:Int) -> String {
        var timeConvertTo = ""
        var startStudy:Int
        var endStudy:Int
        
        if(startTimeSelected < 3) {
            startStudy = 1
        } else if(startTimeSelected >= 3 && startTimeSelected < 12) {
            startStudy = 2
        } else if(startTimeSelected >= 12 && startTimeSelected < 15) {
            startStudy = 3
        } else if(startTimeSelected >= 15 && startTimeSelected < 22) {
            startStudy = 4
        } else if(startTimeSelected >= 22 && startTimeSelected < 27) {
            startStudy = 5
        } else {
            startStudy = 6
        }
        
        if(endTimeSelected <= 3) {
            endStudy = 1
        } else if(endTimeSelected > 3 && endTimeSelected <= 12) {
            endStudy = 2
        } else if(endTimeSelected > 12 && endTimeSelected <= 15) {
            endStudy = 3
        } else if(endTimeSelected > 15 && endTimeSelected <= 22) {
            endStudy = 4
        } else if(endTimeSelected > 22 && endTimeSelected <= 27) {
            endStudy = 5
        } else {
            endStudy = 6
        }
        
        var studyContinued = "\(endStudy - startStudy + 1)"
        timeConvertTo = "\(startStudy)"+studyContinued
        return timeConvertTo
    }
    
    func convertBuildingStringWith(buildingSelected:String) -> String {
        var stringConvertTo = ""
        
        if (buildingSelected == "04楼") {
            stringConvertTo = "0022"
        } else if (buildingSelected == "05楼") {
            stringConvertTo = "1048"
        } else if (buildingSelected == "08楼") {
            stringConvertTo = "0045"
        } else if (buildingSelected == "12楼") {
            stringConvertTo = "0026"
        } else if (buildingSelected == "15楼") {
            stringConvertTo = "0024"
        } else if (buildingSelected == "19楼") {
            stringConvertTo = "0032"
        } else if (buildingSelected == "23楼") {
            stringConvertTo = "0015"
        } else if (buildingSelected == "24楼") {
            stringConvertTo = "1042"
        } else if (buildingSelected == "26楼A区") {
            stringConvertTo = "1084"
        } else if (buildingSelected == "26楼B区") {
            stringConvertTo = "1085"
        } else if (buildingSelected == "西阶") {
            stringConvertTo = "0028"
        }
        
        return stringConvertTo
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(component) {
        case 0:
            return startTimeArr.count
        case 1:
            return endTimeArr.count
        case 2:
            return buildingsArr.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var label = UILabel()
        switch(component) {
        case 0:
            label.text = startTimeArr[row] as String
        case 1:
            label.text = endTimeArr[row] as String
        case 2:
            label.text = buildingsArr[row] as String
        default:
            label.text = ""
        }
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        return label
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var firstSelectedRow = pickerView.selectedRowInComponent(0)
        var secondSelectedRow = pickerView.selectedRowInComponent(1)
        if (component == 0) {
            var secondRow:Int
            if (row >= secondSelectedRow) {
                if (row == startTimeArr.count - 1) {
                    secondRow = row
                } else {
                    secondRow = row + 1
                }
            } else {
                secondRow = secondSelectedRow
            }
            pickerView.selectRow(secondRow, inComponent: 1, animated: true)
        } else if (component == 1) {
            var firstRow:Int
            if (row <= firstSelectedRow) {
                if (row == 0) {
                    firstRow = 0
                } else {
                    firstRow = row - 1
                }
            } else {
                firstRow = firstSelectedRow
            }
            pickerView.selectRow(firstRow, inComponent: 0, animated: true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuseIdentifier")
        }
        cell!.textLabel!.text = searchResultArray[indexPath.row] as? String
        cell!.backgroundColor = UIColor.clearColor()
        return cell!
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
