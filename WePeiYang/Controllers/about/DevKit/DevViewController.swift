//
//  DevViewController.swift
//  WePeiYang
//
//  Created by 秦昱博 on 14/12/3.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

import UIKit

class DevViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var devTableView: UITableView!
    @IBOutlet var consoleTextView: UITextView!
    
    let listArr = ["ID", "Token", "GPA Raw Data", "Class Raw Data", "Inject ID & Token"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64))
        let navigationItem = UINavigationItem(title: "WPY Dev Kit")
        navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationBar.tintColor = UIColor.whiteColor()
        
        let backBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissDevKit")
        navigationItem.setRightBarButtonItem(backBarBtn, animated: true)
        
        let copyBarBtn = UIBarButtonItem(title: "复制", style: UIBarButtonItemStyle.Plain, target: self, action: "copyConsole")
        navigationItem.setLeftBarButtonItem(copyBarBtn, animated: true)
        
        navigationBar.pushNavigationItem(navigationItem, animated: true)
        self.view.addSubview(navigationBar)
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func dismissDevKit() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func copyConsole() {
        var consoleStr = consoleTextView.text
        var pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = consoleStr
        MsgDisplay.showSuccessMsg("控制台输出复制成功")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "reuseIdentifier") as UITableViewCell!
        var row = indexPath.row
        cell.textLabel!.text = listArr[row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var row = indexPath.row
        switch row {
        case 0:
            self.getUserID()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case 1:
            self.getUserToken()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case 2:
            self.getGPARawData()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case 3:
            self.getClassRawData()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case 4:
            self.injectIdAndToken()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        default:
            break
        }
    }
    
    func getUserID() {
        var idStr = data.shareInstance().userId
        consoleTextView.text = idStr
    }
    
    func getUserToken() {
        var tokenStr = data.shareInstance().userToken
        consoleTextView.text = tokenStr
    }
    
    func getGPARawData() {
        var manager = AFHTTPRequestOperationManager()
        var url = twtAPIs.GPAInquire()
        var parameters = ["id": data.shareInstance().userId,
            "token": data.shareInstance().userToken,
            "platform": "ios",
            "version": data.shareInstance().appVersion]
        manager.POST(url, parameters: parameters, success: {
            (operation, responseObject) in
            self.consoleTextView.text = "\(responseObject)"
        }, failure: {
            (operation, error) in
            self.consoleTextView.text = "\(error)"
        })
    }
    
    func getClassRawData() {
        var manager = AFHTTPRequestOperationManager()
        let url = "http://push-mobile.twtapps.net/classtable"
        let parameters = ["id": data.shareInstance().userId, "token": data.shareInstance().userToken, "platform":"ios", "version":data.shareInstance().appVersion]
        manager.GET(url, parameters: parameters, success: {
            (operation, responseObj) in
            self.consoleTextView.text = "\(responseObj)"
            }, failure: {
                (operation, error) in
                self.consoleTextView.text = "\(error)"
        })
    }
    
    func injectIdAndToken() {
        var injectController = UIAlertController(title: "Injection", message: "Inject ID and Token(only for developers)", preferredStyle: .Alert)
        injectController.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder = "id"
        })
        injectController.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder = "token"
        })
        var injectAction = UIAlertAction(title: "Inject", style: .Destructive, handler: {
            (alertAction) in
            let idField = injectController.textFields![0] as! UITextField
            let tokenField = injectController.textFields![1] as! UITextField
            
            let id = idField.text
            let token = tokenField.text
            
            data.shareInstance().userId = id
            data.shareInstance().userToken = token
            
            MsgDisplay.showSuccessMsg("Injection Success")
        })
        var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        injectController.addAction(cancelAction)
        injectController.addAction(injectAction)
        self.presentViewController(injectController, animated: true, completion: nil)
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
