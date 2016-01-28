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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "课程表"
        
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
        
    }
    
    private func updateView() {
        
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
