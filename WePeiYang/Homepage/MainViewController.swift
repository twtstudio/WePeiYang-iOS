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
import MJRefresh
import LocalAuthentication
import STPopup

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeCarouselCellDelegate, HomeToolsCellDelegate {
    
    @IBOutlet var mainTableView: UITableView!
    
    var carouselArr = []
    var campusArr = []
    var announceArr = []
    var lostArr: [LostFoundItem] = []
    var foundArr: [LostFoundItem] = []
    
    var microserviceController: STPopupController!

    override func viewDidLoad() {
        super.viewDidLoad()
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("eventsWatched")
        self.checkGuide()
        //self.checkSpecialEvents()
        
        
        //YuePeiYang
//        Librarian.getBookDetail(ofID: "747522") { (book) in
//            log.obj(book)/
//            log.word("sdfsd")/
//        }
//        
//        Librarian.searchBook(withString: "swift") {
//            reviews in
//            log.any(reviews)/
//        }
        
        if UIApplication.sharedApplication().keyWindow?.rootViewController != self.navigationController?.tabBarController {
            UIApplication.sharedApplication().keyWindow?.rootViewController = self.navigationController?.tabBarController
        }
        
        self.navigationController?.view.backgroundColor = UIColor.whiteColor()
        self.jz_navigationBarBackgroundHidden = false
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        self.mainTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getData()
        })
        
        //原来这句话注释掉是因为这里消耗比较大，如果在下面操纵 main thread 任务会很卡
        //self.mainTableView.mj_header.beginRefreshing()
        //换成 withCompletionBlock 之后可以在 refresh 完成之后开始 checkSpecialEvents 这样消耗性能的任务
        self.mainTableView.mj_header.beginRefreshingWithCompletionBlock {
            
            guard let app = UIApplication.sharedApplication().delegate as? AppDelegate else {
                return
            }
            
            if app.specialEventsShouldShow == true {
                
                // self.checkSpecialEvents()
            }

        }
        
        if !AccountManager.tokenExists() && SolaFoundationKit.topViewController() == self {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.guideDismissNotificationReceived), name: NOTIFICATION_GUIDE_DISMISSED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.loginDismissedNotificationReceived), name: NOTIFICATION_LOGIN_DISMISSED, object: nil)
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
        if mainTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) != nil {
            (mainTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! HomeCarouselCell).scrollView.contentSize = CGSizeMake(size.width * 5, size.width*2/3)
        }
    }
    
    // Private
    
    private func getData() {
        HomeDataManager.getHomeDataWithClosure({(isCached, _carouselArr, _campusArr, _announceArr, _lostArr, _foundArr) in
            self.carouselArr = _carouselArr
            self.campusArr = _campusArr
            self.announceArr = _announceArr
            self.lostArr = _lostArr
            self.foundArr = _foundArr
            
            self.mainTableView.reloadData()
            if isCached == false {
                self.mainTableView.mj_header.endRefreshing()
            }
        }, failure: {(error, description) in
            MsgDisplay.showErrorMsg(description)
            self.mainTableView.mj_header.endRefreshing()
        })
    }
    
    private func checkGuide() {
        let infoDic = NSBundle.mainBundle().infoDictionary
        let currentAppVersion = infoDic!["CFBundleShortVersionString"] as! String
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let appVersion = userDefaults.stringForKey("appVersion")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if appVersion == nil || appVersion != currentAppVersion {
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            let guide = storyboard.instantiateViewControllerWithIdentifier("guide") as! UserGuideViewController
            self.presentViewController(guide, animated: false, completion: nil)
        }
    }
    
    func guideDismissNotificationReceived() {
        if !AccountManager.tokenExists() {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.presentViewController(loginVC, animated: true, completion: nil)
        } else {
//            self.checkSpecialEvents()
        }
    }
    
    func loginDismissedNotificationReceived() {
        guard let app = UIApplication.sharedApplication().delegate as? AppDelegate else {
            return
        }
        
        if app.specialEventsShouldShow == true {
            
            // self.checkSpecialEvents()
            //log.word("fuckers")/
        }
    }
    
    // TABLE VIEW DATA SOURCE
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Header
        case 1:
            return 1 // Functions
        case 2:
            return 0 // Weather
        case 3:
            return campusArr.count // News
        case 4:
            return announceArr.count // Announcements
        case 5:
            return lostArr.count
        case 6:
            return foundArr.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        let width = self.view.bounds.size.width
        switch section {
        case 0:
            return width*2/3
        case 1, 2:
            return 120
        case 5, 6:
            return 132
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
                toolsCell = nib![0] as? HomeToolsCell
            }
            toolsCell?.selectionStyle = .None
            toolsCell?.delegate = self
            return toolsCell!
        case 2:
            var weatherCell = tableView.dequeueReusableCellWithIdentifier("weatheridentifier") as? HomeWeatherCell
            if weatherCell == nil {
                let nib = NSBundle.mainBundle().loadNibNamed("HomeWeatherCell", owner: self, options: nil)
                weatherCell = nib![0] as? HomeWeatherCell
            }
            weatherCell?.selectionStyle = .None
            return weatherCell!
        case 3, 4:
            var newsCell = tableView.dequeueReusableCellWithIdentifier("identifier") as? HomeNewsTableViewCell
            if newsCell == nil {
                let nib = NSBundle.mainBundle().loadNibNamed("HomeNewsTableViewCell", owner: self, options: nil)
                newsCell = nib![0] as? HomeNewsTableViewCell
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
        case 5, 6:
            var lfCell = tableView.dequeueReusableCellWithIdentifier("lfIdentifier") as? LostFoundTableViewCell
            if lfCell == nil {
                let nib = NSBundle.mainBundle().loadNibNamed("LostFoundTableViewCell", owner: self, options: nil)
                lfCell = nib![0] as? LostFoundTableViewCell
            }
            if section == 5 {
                lfCell?.setLostFoundItem(lostArr[row], type: 0)
            }
            if section == 6 {
                lfCell?.setLostFoundItem(foundArr[row], type: 1)
            }
            return lfCell!
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
        case 5:
            return "丢失"
        case 6:
            return "捡到"
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
        case 5:
            self.showLostFoundDetail("\(lostArr[row].index)", type: "0")
        case 6:
            self.showLostFoundDetail("\(foundArr[row].index)", type: "1")
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
    
    // TOOLS CELL DELEGATE
    
    func toolsTappedAtIndex(index: Int) {
        switch index {
        case 0:
            self.showGPAController()
        case 1:
            self.showBicycleServiceController()
        case 2:
            self.showClasstableController()
        case 3:
            self.showReadController()
        default:
            break
        }
    }
    
    // PRESENT VIEW CONTROLLERS
    
    func showGPAController() {
        print("Prepare to enter")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gpaVC = storyboard.instantiateViewControllerWithIdentifier("GPATableViewController") as! GPATableViewController
        gpaVC.hidesBottomBarWhenPushed = true
        
        let userDefaults = NSUserDefaults()
        let touchIdEnabled = userDefaults.boolForKey("touchIdEnabled")
        if (touchIdEnabled) {
            let authContext = LAContext()
            var error: NSError?
            guard authContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
                return
            }
            authContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "GPA这种东西才不给你看", reply: {(success, error) in
                if success {
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
    
    func showNewsController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsVC = storyboard.instantiateViewControllerWithIdentifier("NewsViewController") as! NewsViewController
        newsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(newsVC, sender: nil)
    }
    
    func showClasstableController() {
        let classtableVC = ClasstableViewController(nibName: "ClasstableViewController", bundle: nil)
        classtableVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(classtableVC, sender: nil)
    }
    
//    func showSettingsController() {
//        let settingsVC = SettingViewController(style: .Grouped)
//        settingsVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.showViewController(settingsVC, sender: nil)
//    }
    
    func showLibraryController() {
        let libVC = LibraryViewController(nibName: "LibraryViewController", bundle: nil)
        libVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(libVC, sender: nil)
    }
    
    func showLostFoundController() {
        let lfVC = LostFoundViewController()
        lfVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(lfVC, sender: nil)
    }
    
    func showLostFoundDetail(index: String, type: String) {
        let detail = LostFoundDetailViewController(style: .Grouped)
        detail.index = index
        detail.type = type
        detail.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(detail, sender: nil)
    }
    
    func showMicroservicesController() {
        let msVC = MicroservicesTableViewController(style: .Plain)
//        msVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.showViewController(msVC, sender: nil)
        microserviceController = STPopupController(rootViewController: msVC)
        microserviceController.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        microserviceController.backgroundView.addGestureRecognizer((UITapGestureRecognizer().bk_initWithHandler({ (recognizer, state, point) in
            self.microserviceController.dismiss()
        }) as! UIGestureRecognizer))
        microserviceController.containerView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        microserviceController.containerView.layer.shadowOpacity = 0.5
        microserviceController.containerView.layer.shadowRadius = 20.0
        microserviceController.containerView.clipsToBounds = false
        microserviceController.containerView.layer.cornerRadius = 5.0
        microserviceController.presentInViewController(self)
    }

    
    func showBicycleServiceController() {
        
        let bikeVC = BicycleServiceViewController()
        //log.word(NSUserDefaults.standardUserDefaults().objectForKey("twtToken") as! String)/
        
        if NSUserDefaults.standardUserDefaults().objectForKey("twtToken") == nil {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.presentViewController(loginVC, animated: true, completion: nil)
        } else {
            //坑：让后面能自动弹出要求绑定，但是做法不太科学，应改为 Notification
            BicycleUser.sharedInstance.bindCancel = false
            /*
             if NSUserDefaults.standardUserDefaults().valueForKey("BicycleToken") != nil {
             
             let BicycleExpire = NSUserDefaults.standardUserDefaults().valueForKey("BicycleExpire") as? Int
             let now = NSDate()
             let timeInterval: NSTimeInterval = now.timeIntervalSince1970
             let timeStamp = Int(timeInterval)
             if timeStamp <= BicycleExpire {
             //隐藏tabbar
             bikeVC.hidesBottomBarWhenPushed = true;
             self.navigationController?.showViewController(bikeVC, sender: nil)
             } else {
             BicycleUser.sharedInstance.auth({
             //隐藏tabbar
             bikeVC.hidesBottomBarWhenPushed = true;
             self.navigationController?.showViewController(bikeVC, sender: nil)
             })
             }
             
             } else {
             }*/
            BicycleUser.sharedInstance.auth({
                //隐藏tabbar
                bikeVC.hidesBottomBarWhenPushed = true;
                self.navigationController?.showViewController(bikeVC, sender: nil)
            })
        }
        
        
    }
    
    func showReadController() {
        guard let _ = NSUserDefaults.standardUserDefaults().objectForKey("twtToken") else {
            MsgDisplay.showErrorMsg("你需要登录才能访问")
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            UIViewController.currentViewController().presentViewController(loginVC, animated: true, completion: nil)
            return
        }
        let readVC = ReadViewController()
        readVC.hidesBottomBarWhenPushed = true;
        self.navigationController?.showViewController(readVC, sender: nil)
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

//MARK: Special Events Displaying
extension MainViewController: UIViewControllerTransitioningDelegate {
    private func checkSpecialEvents() {
        
        guard NSUserDefaults.standardUserDefaults().objectForKey("eventsWatched") == nil else {
            //log.word("GODFUCKERS")/
            return
        }
        
        let blurEffect = UIBlurEffect(style: .Light)
        let frostedView = UIVisualEffectView(effect: blurEffect)
        //self.navigationController?.view.addSubview(frostedView)
        self.tabBarController?.view.addSubview(frostedView)
        frostedView.snp_makeConstraints {
            make in
            make.top.equalTo((self.navigationController?.view)!).offset(-UIApplication.sharedApplication().statusBarFrame.height)
            make.left.equalTo(self.view)
            make.bottom.equalTo((self.tabBarController?.view)!)
            make.right.equalTo(self.view)
        }
        
        let notInterestedLabel = UILabel(text: "下次再看？往上滑！", fontSize: 20)
        notInterestedLabel.textColor = .grayColor()
        frostedView.addSubview(notInterestedLabel)
        notInterestedLabel.snp_makeConstraints {
            make in
            make.centerX.equalTo(frostedView)
            make.bottom.equalTo(frostedView).offset(-26)
        }
        
        //Add Special Events View
        let specialVC = SpecialEventsViewController(address: "http://coder.twtstudio.com/hr")
        specialVC.transitioningDelegate = self
        specialVC.modalPresentationStyle = .Custom

        navigationController?.presentViewController(specialVC, animated: true, completion: nil)
    }
    
    
    //Animator Delegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
    
}

