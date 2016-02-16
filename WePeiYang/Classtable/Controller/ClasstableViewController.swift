//
//  ClasstableViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/28.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import MJExtension
import Masonry

let CLASSTABLE_CACHE_KEY = "CLASSTABLE_CACHE"
let CLASSTABLE_COLOR_CONFIG_KEY = "CLASSTABLE_COLOR_CONFIG"
let colorArr = [UIColor.flatRedColor(), UIColor.flatOrangeColor(), UIColor.flatMagentaColor(), UIColor.flatYellowColorDark(), UIColor.flatGreenColor(), UIColor.flatSkyBlueColor(), UIColor.flatMintColor(), UIColor.flatTealColor(), UIColor.flatPinkColorDark(), UIColor.flatBlueColor(), UIColor.flatLimeColor(), UIColor.flatPurpleColor()]

class ClasstableViewController: UIViewController {
    
    @IBOutlet weak var classTableScrollView: UIScrollView!
    
    var dataArr = []
    let currentWeek = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .None
        
        self.title = "课程表"
        self.dataArr = []
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshNotificationReceived", name: "Login", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshNotificationReceived", name: "BindTju", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backNotificationReceived", name: "LoginCancelled", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backNotificationReceived", name: "BindTjuCancelled", object: nil)
        
        self.loadClassTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.updateView(size)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func loadClassTable() {
        if AccountManager.tokenExists() {
            if wpyCacheManager.cacheDataExistsWithKey(CLASSTABLE_CACHE_KEY) {
                wpyCacheManager.loadCacheDataWithKey(CLASSTABLE_CACHE_KEY, andBlock: {cacheData in
                    self.dataArr = ClassData.mj_objectArrayWithKeyValuesArray(cacheData)
                    self.updateView(UIScreen.mainScreen().bounds.size)
                }, failed: nil)
            } else {
                self.refresh()
            }
        } else {
            let loginVC = LoginViewController(nibName: nil, bundle: nil)
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    private func refresh() {
//        MsgDisplay.showLoading()
//        ClasstableDataManager.getClasstableData({data in
//            MsgDisplay.dismiss()
//            if data.count > 0 {
//                self.dataArr = ClassData.mj_objectArrayWithKeyValuesArray(data)
//                self.updateView(self.view.bounds.size)
//                wpyCacheManager.saveCacheData(data, withKey: CLASSTABLE_CACHE_KEY)
//            }
//        }, notBinded: {
//            MsgDisplay.dismiss()
//            let bindTjuVC = BindTjuViewController(style: .Grouped)
//            self.presentViewController(UINavigationController(rootViewController: bindTjuVC), animated: true, completion: nil)
//        }, otherFailure: {errorMsg in
//            MsgDisplay.showErrorMsg(errorMsg)
//        })
        
        // Load demo data
        
        let demoJson = NSBundle.mainBundle().pathForResource("class_demo", ofType: "json")
        do {
            let obj = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfFile: demoJson!)!, options: .MutableLeaves)
            let data = obj["data"]!
            dataArr = ClassData.mj_objectArrayWithKeyValuesArray(data)
            wpyCacheManager.saveCacheData(data, withKey: CLASSTABLE_CACHE_KEY)
            self.updateView(UIScreen.mainScreen().bounds.size)
        } catch {
            
        }
    }
    
    private func updateView(size: CGSize) {
        for view in classTableScrollView.subviews {
            view.removeFromSuperview()
        }
        
        let classSize = self.classCellSizeWithScreenSize(size)
        classTableScrollView.contentSize = self.contentSizeWithScreenSize(size)
        
        var colorConfig = [String: UIColor]()
        wpyCacheManager.loadCacheDataWithKey(CLASSTABLE_COLOR_CONFIG_KEY, andBlock: {obj in
            colorConfig = obj as! [String: UIColor]
//            print("\(colorConfig)")
        }, failed: nil)
        
        var colorArray = colorArr
        
        for tmpItem in dataArr {
            let tmpClass: ClassData = tmpItem as! ClassData
            
            var classBgColor: UIColor!
            if wpyCacheManager.cacheDataExistsWithKey(CLASSTABLE_COLOR_CONFIG_KEY) {
                if colorConfig[tmpClass.courseId] != nil {
                    classBgColor = colorConfig[tmpClass.courseId]
                } else {
                    classBgColor = UIColor.randomFlatColor()
                }
            } else {
                if colorArray.count > 0 {
                    classBgColor = colorArray.first
                    colorConfig[tmpClass.courseId] = classBgColor
                    colorArray.removeFirst()
                } else {
                    classBgColor = UIColor.randomFlatColor()
                    colorConfig[tmpClass.courseId] = classBgColor
                }
            }
            
            for arrange in tmpClass.arrange {
                let tmpArrange: ArrangeModel = arrange as! ArrangeModel
                let classCell = ClassCellView()
                classTableScrollView.addSubview(classCell)
                classCell.mas_makeConstraints({make in
                    make.width.mas_equalTo()(classSize.width)
                    make.height.mas_equalTo()(CGFloat(tmpArrange.end - tmpArrange.start + 1) * classSize.height)
                    make.left.mas_equalTo()(CGFloat(tmpArrange.day) * classSize.width)
                    make.top.mas_equalTo()(CGFloat(tmpArrange.start - 1) * classSize.height)
                })
                
                classCell.classLabel.text = "\(tmpClass.courseName)@\(tmpArrange.room)"
                // 针对设备宽度控制字号
                classCell.classLabel.font = UIFont.systemFontOfSize((size.width > 320) ? 12 : 10)
                classCell.backgroundColor = classBgColor
                // 考虑不在当前周数内的科目
//                if tmpClass.weekStart <= currentWeek && tmpClass.weekEnd >= currentWeek {
//                    classCell.backgroundColor = classBgColor
//                } else {
//                    classCell.backgroundColor = UIColor.flatGrayColor()
//                }
            }
        }
        
        wpyCacheManager.saveCacheData(colorConfig, withKey: CLASSTABLE_COLOR_CONFIG_KEY)
    }
    
    private func classCellSizeWithScreenSize(screenSize: CGSize) -> CGSize {
        let width = screenSize.width / 8
        // 高度的参数需要针对不同设备进行不同的控制，甚至对不同屏幕方向也要有所适配
        let height = width * 1.5
        return CGSizeMake(width, height)
    }

    private func contentSizeWithScreenSize(screenSize: CGSize) -> CGSize {
        let cellSize = self.classCellSizeWithScreenSize(screenSize)
        let contentWidth = screenSize.width
        let contentHeight = cellSize.height * 12
        return CGSizeMake(contentWidth, contentHeight)
    }
    
    // MARK: - Public Methods
    
    func refreshNotificationReceived() {
        self.refresh()
    }
    
    func backNotificationReceived() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - IBActions
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
