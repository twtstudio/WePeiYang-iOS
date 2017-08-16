//
//  ClasstableViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/28.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import SnapKit
import STPopup
import DateTools
import ObjectMapper
import SwiftyJSON

let CLASSTABLE_CACHE_KEY = "CLASSTABLE_CACHE"
let CLASSTABLE_COLOR_CONFIG_KEY = "CLASSTABLE_COLOR_CONFIG"
let CLASSTABLE_TERM_START_KEY = "CLASSTABLE_TERM_START"
let colorArr = [UIColor.flatRedColor(), UIColor.flatOrangeColor(), UIColor.flatMagentaColor(), UIColor.flatGreenColor(), UIColor.flatSkyBlueColor(), UIColor.flatMintColor(), UIColor.flatTealColor(), UIColor.flatPinkColorDark(), UIColor.flatBlueColor(), UIColor.flatLimeColor(), UIColor.flatPurpleColor(), UIColor.flatYellowColorDark(), UIColor.flatWatermelonColorDark(), UIColor.flatCoffeeColor()]

class ClasstableViewController: UIViewController, ClassCellViewDelegate {
    
    @IBOutlet weak var classTableScrollView: UIScrollView!
    
    var dataArr: [ClassData] = []
    var detailController: STPopupController!
    var currentWeek = 0
    var classCellsNotAround: [ClassCellView] = []
    var classCellsAround: [ClassCellView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .None
        let refreshBtn = UIBarButtonItem().bk_initWithBarButtonSystemItem(.Refresh, handler: {sender in
            self.refresh()
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = refreshBtn
        
        self.title = "课程表"
        self.dataArr = []
        self.currentWeek = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClasstableViewController.refreshNotificationReceived), name: NOTIFICATION_LOGIN_SUCCESSED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClasstableViewController.refreshNotificationReceived), name: NOTIFICATION_BINDTJU_SUCCESSED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClasstableViewController.backNotificationReceived), name: NOTIFICATION_LOGIN_CANCELLED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClasstableViewController.backNotificationReceived), name: NOTIFICATION_BINDTJU_CANCELLED, object: nil)
        
        self.loadClassTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 152/255.0, blue: 0, alpha: 1.0)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.updateView(size)
    }
    
    override func viewDidLayoutSubviews() {
        
        updateViewWithClassesNotAround(UIScreen.mainScreen().bounds.size)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func updateViewWithClassesNotAround(size: CGSize) {
        let classSize = self.classCellSizeWithScreenSize(size)
        
        guard !classCellsNotAround.isEmpty else {
            return
        }
        
        
        
        

        /*for classCellNotAround in classCellsNotAround {
            var fooArr: [ClassCellView] = []
            for classCellAround in classCellsAround {
                
                    for arrangeNotAround in (classCellNotAround.classData?.arrange)! {
                        for arrangeAround in (classCellAround.classData?.arrange)! {
                            if !(arrangeAround.day == arrangeNotAround.day && arrangeAround.start == arrangeNotAround.start) {
                                classTableScrollView.addSubview(classCellNotAround)
                                classCellNotAround.snp_makeConstraints {
                                    make in
                                    make.width.equalTo(classSize.width)
                                    make.height.equalTo(CGFloat(arrangeNotAround.end - arrangeNotAround.start + 1) * classSize.height)
                                    make.left.equalTo(CGFloat(arrangeNotAround.day) * classSize.width)
                                    make.top.equalTo(CGFloat(arrangeNotAround.start - 1) * classSize.height)
                                }
                            }
                        }
                    }
                
            }
            
        }*/
        /*for i in 0..<classCellsNotAround.count {
            for j in 0..<classCellsAround.count {
                for l in 0..<classCellsNotAround[i].classData!.arrange.count {
                    for m in 0..<classCellsAround[j].classData!.arrange.count {
                        let arrangeAround = classCellsAround[j].classData!.arrange[m]
                        let arrangeNotAround = classCellsNotAround[i].classData!.arrange[l]
                        if !(arrangeAround.day == arrangeNotAround.day && arrangeAround.start == arrangeNotAround.start) {
                            classTableScrollView.addSubview(classCellsNotAround[i])
                            classCellsNotAround[i].snp_makeConstraints {
                                make in
                                make.width.equalTo(classSize.width)
                                make.height.equalTo(CGFloat(arrangeNotAround.end - arrangeNotAround.start + 1) * classSize.height)
                                make.left.equalTo(CGFloat(arrangeNotAround.day) * classSize.width)
                                make.top.equalTo(CGFloat(arrangeNotAround.start - 1) * classSize.height)
                            }
                        }
                    }
                }
            }
        }*/
    }
    
    private func loadClassTable() {
        if AccountManager.tokenExists() {
            wpyCacheManager.loadGroupCacheDataWithKey(CLASSTABLE_TERM_START_KEY, andBlock: {termStart in
                if termStart != nil {
                    let startDate = NSDate(timeIntervalSince1970: Double(termStart as! Int))
                    //log.obj(startDate)/
                    self.currentWeek = NSDate().weeksFrom(startDate) + 1
                    self.title = "第 \(self.currentWeek) 周"
                } else {
                    self.refresh()
                }
            })
            wpyCacheManager.loadGroupCacheDataWithKey(CLASSTABLE_CACHE_KEY, andBlock: {data in
                if data != nil {
                    self.dataArr = Mapper<ClassData>().mapArray(data)!
                    self.updateView(UIScreen.mainScreen().bounds.size)
                } else {
                    self.refresh()
                }
            })
        } else {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    private func refresh() {
        MsgDisplay.showLoading()
        ClasstableDataManager.getClasstableData({(data, termStart) in
            MsgDisplay.dismiss()
            wpyCacheManager.removeCacheDataForKey(CLASSTABLE_COLOR_CONFIG_KEY)
            self.dataArr = Mapper<ClassData>().mapArray(data)!
            //log.any(JSON(data))/
            self.updateView(self.view.bounds.size)
            wpyCacheManager.saveGroupCacheData(data, withKey: CLASSTABLE_CACHE_KEY)
            wpyCacheManager.saveGroupCacheData(termStart, withKey: CLASSTABLE_TERM_START_KEY)
            let startDate = NSDate(timeIntervalSince1970: Double(termStart))
            self.currentWeek = NSDate().weeksFrom(startDate) + 1
            self.title = "第 \(self.currentWeek) 周"
        }, notBinded: {
            MsgDisplay.dismiss()
            let bindTjuVC = BindTjuViewController(style: .Grouped)
            self.presentViewController(UINavigationController(rootViewController: bindTjuVC), animated: true, completion: nil)
        }, otherFailure: {errorMsg in
            MsgDisplay.showErrorMsg(errorMsg)
        })
    }
    
    private func updateView(size: CGSize) {
        for view in classTableScrollView.subviews {
            view.removeFromSuperview()
        }
        
        let classSize = self.classCellSizeWithScreenSize(size)
        classTableScrollView.contentSize = self.contentSizeWithScreenSize(size)
        
        for i in 0...11 {
            let classNumberCell = ClassCellView()
            classNumberCell.classLabel.text = " \(i+1) "
            classNumberCell.classLabel.sizeToFit()
            classNumberCell.backgroundColor = UIColor.clearColor()
            classNumberCell.classLabel.textColor = UIColor.lightGrayColor()
            classNumberCell.classLabel.font = UIFont.systemFontOfSize(UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 16 : (size.width > 320) ? 12 : 10)
            classTableScrollView.addSubview(classNumberCell)
            classNumberCell.snp_makeConstraints(closure: { make in
                make.top.equalTo(CGFloat(i) * classSize.height)
                make.left.equalTo(0)
                //make.width.equalTo(classSize.width)
                make.height.equalTo(classSize.height)
            })
        }
        
        var colorConfig = [String: UIColor]()
        wpyCacheManager.loadCacheDataWithKey(CLASSTABLE_COLOR_CONFIG_KEY, andBlock: {obj in
            colorConfig = obj as! [String: UIColor]
        }, failed: nil)
        
        var colorArray = colorArr
        
        for tmpClass in dataArr {
            var classBgColor: UIColor!
            if wpyCacheManager.cacheDataExistsWithKey(CLASSTABLE_COLOR_CONFIG_KEY) {
                //log.word("fuckin entered")/
                if colorConfig[tmpClass.courseId] != nil {
                    classBgColor = colorConfig[tmpClass.courseId]
                    //log.any("fucking entered if \(classBgColor)")/
                } else {
                    classBgColor = UIColor.randomFlatColor()
                    //log.any("fucking entered else \(classBgColor)")/
                }
            } else {
                if colorArray.count <= 0 {
                    colorArray = colorArr
                }
                classBgColor = colorArray.first

                colorConfig[tmpClass.courseId] = classBgColor
                colorArray.removeFirst()
            }
            
            for tmpArrange in tmpClass.arrange {
                let classCell = ClassCellView()
                classCell.classData = tmpClass
                classCell.classLabel.text = "\(tmpClass.courseName)@\(tmpArrange.room)"
                // 针对设备宽度控制字号
                classCell.classLabel.font = UIFont.systemFontOfSize(UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 16 : (size.width > 320) ? 12 : 10)
                classCell.delegate = self
                
                classCell.alpha = 0.7
                let gap: CGFloat = 2
                classCell.layer.cornerRadius = gap+2
                
                if Int(tmpClass.weekStart) <= currentWeek && Int(tmpClass.weekEnd) >= currentWeek {
                    classCellsAround.append(classCell)
                    
                    classTableScrollView.addSubview(classCell)
                    classCell.snp_makeConstraints {
                        make in
                        make.width.equalTo(classSize.width-gap)
                        make.height.equalTo(CGFloat(tmpArrange.end - tmpArrange.start + 1) * classSize.height-gap)
                        make.left.equalTo(CGFloat(tmpArrange.day-1) * classSize.width+22.5)
                        make.top.equalTo(CGFloat(tmpArrange.start - 1) * classSize.height)
                    }
                    if (tmpArrange.week == "单双周") || (currentWeek % 2 == 0 && tmpArrange.week == "双周") || (currentWeek % 2 == 1 && tmpArrange.week == "单周") {
                        classCell.backgroundColor = classBgColor
                    } else {
//                        classCell.alpha = 0.3
//                        classCell.backgroundColor = UIColor.flatGrayColor()
//                        classCell.classLabel.textColor = UIColor.darkGrayColor()
                        classCell.removeFromSuperview()
                    }
                } else {
                    
                    classCell.classLabel.font = UIFont.systemFontOfSize(UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 16 : (size.width > 320) ? 12 : 10)
                    classCell.delegate = self
                    classCell.backgroundColor = .flatWhiteColor()
                    classCell.classLabel.textColor = .flatGrayColorDark()
                    classCellsNotAround.append(classCell)
                    for foo in classTableScrollView.subviews {
                        if foo.isKindOfClass(ClassCellView) {
                            //log.any(foo.frame)/
                        }
                    }
                }
            }
            
            
            /*for tmpArrange in tmpClass.arrange {
                let classCell = ClassCellView()
                classTableScrollView.addSubview(classCell)
                classCell.classData = tmpClass
                classCell.snp_makeConstraints(closure: { make in
                    make.width.equalTo(classSize.width)
                    make.height.equalTo(CGFloat(tmpArrange.end - tmpArrange.start + 1) * classSize.height)
                    make.left.equalTo(CGFloat(tmpArrange.day) * classSize.width)
                    make.top.equalTo(CGFloat(tmpArrange.start - 1) * classSize.height)
                })
                
                classCell.classLabel.text = "\(tmpClass.courseName)@\(tmpArrange.room)"
                // 针对设备宽度控制字号
                classCell.classLabel.font = UIFont.systemFontOfSize(UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 16 : (size.width > 320) ? 12 : 10)
                classCell.delegate = self
                // 考虑不在当前周数内的科目
                if Int(tmpClass.weekStart) <= currentWeek && Int(tmpClass.weekEnd) >= currentWeek {
                    // 单双周判断
                    // MARK: - WARNING 单双周可能有课不一样
                    if (tmpArrange.week == "单双周") || (currentWeek % 2 == 0 && tmpArrange.week == "双周") || (currentWeek % 2 == 1 && tmpArrange.week == "单周") {
                        classCell.backgroundColor = classBgColor
                    } else {
//                        classCell.backgroundColor = UIColor.flatWhiteColor()
//                        classCell.classLabel.textColor = UIColor.flatGrayColorDark()
                        classCell.removeFromSuperview()
                    }
                } else {
                    classCell.backgroundColor = UIColor.flatWhiteColor()
                    classCell.classLabel.textColor = UIColor.flatGrayColorDark()
                }
            }*/
        }
        
        wpyCacheManager.saveCacheData(colorConfig, withKey: CLASSTABLE_COLOR_CONFIG_KEY)
    }
    
    private func classCellSizeWithScreenSize(screenSize: CGSize) -> CGSize {
        let width = (screenSize.width - 22.5)/7
        // 高度的参数需要针对不同设备进行不同的控制，甚至对不同屏幕方向也要有所适配
        var height: CGFloat = 0
        if screenSize.width <= 320 {
            height = width * 1.4
        } else if screenSize.width <= 414 {
            height = width * 1.1
        } else if screenSize.width <= 768 {
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                height = width * 0.35
            } else {
                height = width * 0.7
            }
        } else if screenSize.width <= 1024 {
            height = width * 0.5
        } else {
            height = width * 0.3
        }
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
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func cellViewTouched(cellView: ClassCellView) {
//        print("\(cellView.classData!.courseName) : \(cellView.frame)")
        
        let classDetailController = ClassDetailViewController(nibName: "ClassDetailViewController", bundle: nil)
        classDetailController.classData = cellView.classData!
        classDetailController.classColor = cellView.backgroundColor
        detailController = STPopupController(rootViewController: classDetailController)
        let blurEffect = UIBlurEffect(style: .Dark)
        detailController.backgroundView = UIVisualEffectView(effect: blurEffect)
        detailController.backgroundView.addGestureRecognizer((UITapGestureRecognizer().bk_initWithHandler({(recognizer, state, point) in
            self.detailController.dismiss()
        }) as! UITapGestureRecognizer))
        detailController.presentInViewController(self)
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
