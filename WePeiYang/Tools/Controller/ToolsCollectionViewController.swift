//
//  ToolsCollectionViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/3/26.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import LocalAuthentication
import STPopup

private let reuseIdentifier = "Cell"

class ToolsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    typealias ToolCell = (title: String, image: UIImage)
    private let toolsData: [ToolCell] = [
        (title: "成绩", image: UIImage(named: "gpaBtn")!),
        (title: "课程表", image: UIImage(named: "classtableBtn")!),
//        (title: "图书馆", image: UIImage(named: "libBtn")!),
        (title: "失物招领", image: UIImage(named: "lfBtn")!),
        (title: "自行车", image: UIImage(named: "bicycleBtn")!),
        (title: "党建" , image: UIImage(named: "partyBtn")!),
        (title: "探索", image: UIImage(named: "msBtn")!),
        (title: "阅读", image: UIImage(named: "readBtn")!),
        (title: "黄页", image: UIImage(named: "YellowPageBtn")!),
//        (title: "图书馆", image: UIImage(named: "libBtn")!)
    ]
    
    var microserviceController: STPopupController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //3D Touch
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .Available {
                registerForPreviewingWithDelegate(self, sourceView: self.collectionView!)
            }
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationController?.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.collectionView?.alwaysBounceVertical = true
        self.jz_navigationBarBackgroundHidden = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(ToolsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolsData.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.width/4, 119)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var nibCellLoaded = false
        if !nibCellLoaded {
            let nib = UINib(nibName: "ToolsCollectionViewCell", bundle: nil)
            collectionView.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
            nibCellLoaded = true
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ToolsCollectionViewCell
        cell.iconView.image = toolsData[indexPath.row].image
        cell.titleLabel.text = toolsData[indexPath.row].title
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.showGPAController()
        case 1:
            self.showClasstableController()
//        case 2:
//            self.showLibraryController()
        case 2:
            self.showLostFoundController()
        case 3:
            self.showBicycleServiceController()
        case 4:
            self.showPartyServiceController()
        case 5:
            self.showMicroservicesController()
        case 6:
            self.showReadController()
        case 7:
            self.showYellowPageController()
//        case 8:
//            self.showLibraryController()
        default:
            return
        }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: - push tools
    
    func showGPAController() {
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
    
    func showClasstableController() {
        let classtableVC = ClasstableViewController(nibName: "ClasstableViewController", bundle: nil)
        classtableVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(classtableVC, sender: nil)
    }
    
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
        
        /*
        guard #available(iOS 9.0, *) else {
            MsgDisplay.showErrorMsg("你需要 iOS 9 或以上系统才能使用该功能，请更新系统")
            return
        }
 */
        
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
                bikeVC.hidesBottomBarWhenPushed = true
                self.navigationController?.showViewController(bikeVC, sender: nil)
            })
        }
        
        
    }
    
    func showPartyServiceController() {
        
        /*
        guard #available(iOS 9.0, *) else {
            MsgDisplay.showErrorMsg("你需要 iOS 9 或以上系统才能使用该功能，请更新系统")
            return
        }
 */
        
        let partyVC = PartyMainViewController()
        partyVC.hidesBottomBarWhenPushed = true
        
        guard NSUserDefaults.standardUserDefaults().objectForKey("studentID") != nil else {
            Applicant.sharedInstance.getStudentNumber({
                
                self.navigationController?.showViewController(partyVC, sender: nil)
            })
            return
        }
        
        self.navigationController?.showViewController(partyVC, sender: nil)
        
        //FIXME: This takes an awful lot of time and makes the main thread laggggggg
        /*Applicant.sharedInstance.getStudentNumber({
            self.navigationController?.showViewController(partyVC, sender: nil)
        })*/
        
    }
    
    func showReadController() {

        guard let _ = NSUserDefaults.standardUserDefaults().objectForKey("twtToken") else {
            MsgDisplay.showErrorMsg("你需要登录才能访问")
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            UIViewController.currentViewController().presentViewController(loginVC, animated: true, completion: nil)
            return
        }
        let readVC = ReadViewController()
        
        readVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(readVC, sender: nil)
    }
    
    func showYellowPageController() {
        let ypVC = YellowPageMainViewController()
        ypVC.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(ypVC, sender: nil)
    }
    
}
