//
//  MainViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/5.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import BlocksKit
import JZNavigationExtension
import RESideMenu
import MJRefresh
import LocalAuthentication

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeCarouselCellDelegate, SidebarDelegate {
    
    @IBOutlet var mainTableView: UITableView!
    
    var carouselArr = []
    var campusArr = []
    var announceArr = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "微北洋"
        mainTableView.dataSource = self
        mainTableView.delegate = self
        let sidebar = self.sideMenuViewController.leftMenuViewController as! SidebarViewController
        sidebar.delegate = self
        
        let menuBtn = UIBarButtonItem().bk_initWithImage(UIImage(named: "menu"), style: .Plain, handler: {handler in
            self.sideMenuViewController.presentLeftMenuViewController()
        }) as! UIBarButtonItem
        self.navigationItem.leftBarButtonItem = menuBtn
        
        self.mainTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getData()
        })
        self.getData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = self.view.tintColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        mainTableView.reloadData()
        (mainTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! HomeCarouselCell).scrollView.contentSize = CGSizeMake(size.width * 5, size.width*2/3)
    }
    
    // Private
    
    private func getData() {
        HomeDataManager.getHomeDataWithClosure({(_carouselArr, _campusArr, _announceArr) in
            self.carouselArr = _carouselArr
            self.campusArr = _campusArr
            self.announceArr = _announceArr
            
            self.mainTableView.reloadData()
            self.mainTableView.mj_header.endRefreshing()
        }, failure: {(error, description) in
            
        })
    }
    
    private func showGPA() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gpaVC = storyboard.instantiateViewControllerWithIdentifier("GPATableViewController") as! GPATableViewController
        
        let userDefaults = NSUserDefaults()
        let touchIdEnabled = userDefaults.boolForKey("touchIdEnabled")
        if (touchIdEnabled) {
            let authContext = LAContext()
            var error: NSError?
            guard authContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
                return
            }
            authContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "GPA信息要求指纹验证", reply: {(success, error) in
                if success {
                    print("SUCCESS")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.navigationController?.showViewController(gpaVC, sender: nil)
                    })
                } else {
                    MsgDisplay.showErrorMsg("指纹验证失败")
                }
            })
        } else {
            self.navigationController?.showViewController(gpaVC, sender: nil)
        }
    }
    
    private func showNews() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsVC = storyboard.instantiateViewControllerWithIdentifier("NewsViewController") as! NewsViewController
        self.navigationController?.showViewController(newsVC, sender: nil)
    }
    
    private func showSettings() {
        let settingsVC = SettingViewController(style: .Grouped)
        self.navigationController?.showViewController(settingsVC, sender: nil)
    }
    
    // TABLE VIEW DATA SOURCE
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Header
        case 1:
            return 1 // Functions
        case 2:
            return 1 // Weather
        case 3:
            return campusArr.count // News
        case 4:
            return announceArr.count // Announcements
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
//        let row = indexPath.row
        let width = self.view.bounds.size.width
        switch section {
        case 0:
            return width*2/3
        case 1, 2:
            return 120
        default:
            return 64
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            let carouselCell = HomeCarouselCell(style: .Default, reuseIdentifier: "carouidentifier")
            carouselCell.delegate = self
            if carouselArr.count > 0 {
                carouselCell.setArrayObject(carouselArr as! [NewsData])
            }
            carouselCell.selectionStyle = .None
            return carouselCell
        case 1:
            var toolsCell = tableView.dequeueReusableCellWithIdentifier("toolidentifier") as? HomeToolsCell
            if toolsCell == nil {
                let nib = NSBundle.mainBundle().loadNibNamed("HomeToolsCell", owner: self, options: nil)
                toolsCell = nib[0] as? HomeToolsCell
            }
            toolsCell?.selectionStyle = .None
            return toolsCell!
        case 2:
            var weatherCell = tableView.dequeueReusableCellWithIdentifier("weatheridentifier") as? HomeWeatherCell
            if weatherCell == nil {
                let nib = NSBundle.mainBundle().loadNibNamed("HomeWeatherCell", owner: self, options: nil)
                weatherCell = nib[0] as? HomeWeatherCell
            }
            weatherCell?.selectionStyle = .None
            return weatherCell!
        case 3, 4:
            var newsCell = tableView.dequeueReusableCellWithIdentifier("identifier") as? HomeNewsTableViewCell
            if newsCell == nil {
                let nib = NSBundle.mainBundle().loadNibNamed("HomeNewsTableViewCell", owner: self, options: nil)
                newsCell = nib[0] as? HomeNewsTableViewCell
            }
            if section == 3 {
                if campusArr.count > 0 {
                    newsCell!.setObject(campusArr[row] as! NewsData)
                }
            }
            if section == 4 {
                if announceArr.count > 0 {
                    newsCell!.setObject(announceArr[row] as! NewsData)
                }
            }
            return newsCell!
        default:
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 3:
            return "新闻"
        case 4:
            return "公告"
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 3:
            self.goToContent(campusArr[row] as! NewsData)
        case 4:
            self.goToContent(announceArr[row] as! NewsData)
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // HOME CAROUSEL DELEGATE
    
    func goToContent(content: NewsData) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contentVC = storyboard.instantiateViewControllerWithIdentifier("NewsContentViewController") as! NewsContentViewController
        contentVC.newsData = content
        self.navigationController?.showViewController(contentVC, sender: nil)
    }
    
    // SIDE BAR DELEGATE
    
    func showGPAController() {
        self.showGPA()
    }
    
    func showNewsController() {
        self.showNews()
    }
    
    func showSettingsController() {
        self.showSettings()
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