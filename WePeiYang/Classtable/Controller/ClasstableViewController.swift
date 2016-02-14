//
//  ClasstableViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/28.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

let CLASSTABLE_CACHE_KEY = "CLASSTABLE_CACHE"

class ClasstableViewController: UIViewController {
    
    @IBOutlet weak var classTableScrollView: UIScrollView!
    
    var dataArr = []

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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func loadClassTable() {
        if AccountManager.tokenExists() {
            if wpyCacheManager.cacheDataExistsWithKey(CLASSTABLE_CACHE_KEY) {
                wpyCacheManager.loadCacheDataWithKey(CLASSTABLE_CACHE_KEY, andBlock: {cacheData in
                    self.dataArr = ClassData.mj_objectArrayWithKeyValuesArray(cacheData)
                    self.updateView(self.view.bounds.size)
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
        MsgDisplay.showLoading()
        ClasstableDataManager.getClasstableData({data in
            MsgDisplay.dismiss()
            if data.count > 0 {
                self.dataArr = ClassData.mj_objectArrayWithKeyValuesArray(data)
                self.updateView(self.view.bounds.size)
                wpyCacheManager.saveCacheData(data, withKey: CLASSTABLE_CACHE_KEY)
            }
        }, notBinded: {
            MsgDisplay.dismiss()
            let bindTjuVC = BindTjuViewController(style: .Grouped)
            self.presentViewController(UINavigationController(rootViewController: bindTjuVC), animated: true, completion: nil)
        }, otherFailure: {errorMsg in
            MsgDisplay.showErrorMsg(errorMsg)
        })
    }
    
    private func updateView(size: CGSize) {
        
    }
    
//    private func classCellSizeWithScreenSize(screenSize: CGSize) -> CGSize {
//        
//    }
//    
//    private func contentSizeWithScreenSize(screenSize: CGSize) -> CGSize {
//        
//    }
    
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
