//
//  LostFoundPostViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/15.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import FXForms
import BlocksKit

class LostFoundPostViewController: UITableViewController, FXFormControllerDelegate {
    
    var postType: Int = 0
    var formController: FXFormController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 113/255.0, green: 168/255.0, blue: 57/255.0, alpha: 1.0)
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:113/255.0 green:168/255.0 blue:57/255.0 alpha:1.0];
        
        formController = FXFormController()
        formController.tableView = self.tableView
        formController.delegate = self
        let form = LostFoundPostForm()
        form.postType = postType
        formController.form = form
        
        if postType == 0 {
            self.title = "发布丢失"
        } else {
            self.title = "发布捡到"
        }
        
        let cancelBtn = UIBarButtonItem().bk_initWithBarButtonSystemItem(.Cancel, handler: {sender in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }) as! UIBarButtonItem
        self.navigationItem.leftBarButtonItem = cancelBtn
        
        let sendBtn = UIBarButtonItem().bk_initWithTitle(NSLocalizedString("Send", comment: ""), style: .Plain, handler: {sender in
            self.postInfo()
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = sendBtn
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func postInfo() {
        let form = self.formController.form as! LostFoundPostForm
        if form.title == nil || form.title!.isEmpty || form.name == nil || form.name!.isEmpty || form.phone == nil || form.phone!.isEmpty {
            MsgDisplay.showErrorMsg("请填写完整具体内容！")
        } else {
            MsgDisplay.showLoading()
            if postType == 0 {
                // Lost
                let time = form.time == nil ? NSDate() : form.time
                let place = form.place == nil ? "" : form.place
                let content = form.content == nil ? "" : form.content
                let lostType = form.lostType == nil ? "0" : form.lostType
                let otherTag = form.otherTag == nil ? "" : form.otherTag
                twtSDK.postLostInfoWithTitle(form.title!, name: form.name!, time: time!, place: place!, phone: form.phone!, content:content! , lostType: lostType!, otherTag: otherTag!, success: {(task, responseObj) in
                    if responseObj["error_code"] as! Int == -1 {
                        MsgDisplay.showSuccessMsg("发布成功！")
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        MsgDisplay.showErrorMsg("发布失败")
                    }
                }, failure: {(task, error) in
                    MsgDisplay.showErrorMsg("发布失败\n\(error.localizedDescription)")
                })
            } else {
                let time = form.time == nil ? NSDate() : form.time
                let place = form.place == nil ? "" : form.place
                let content = form.content == nil ? "" : form.content
                let foundPic = form.foundPic == nil ? "" : form.foundPic
                twtSDK.postFoundInfoWithTitle(form.title!, name: form.name!, time: time!, place: place!, phone: form.phone!, content: content!, foundPic: foundPic!, success: {(task, responseObj) in
                    if responseObj["error_code"] as! Int == -1 {
                        MsgDisplay.showSuccessMsg("发布成功！")
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        MsgDisplay.showErrorMsg("发布失败")
                    }
                }, failure: {(task, error) in
                    MsgDisplay.showErrorMsg("发布失败\n\(error.localizedDescription)")
                })
            }
        }
    }

}
