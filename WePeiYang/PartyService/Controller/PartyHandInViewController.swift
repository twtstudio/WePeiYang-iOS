//
//  PartyHandInViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/24.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class PartyHandInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    /*
    //Handle iOS 8 fucking bug
    init(){
        super.init(nibName: "PartyHandInViewController", bundle: nil)
        //print("haha")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
    var contentList: Array<(title: String, available: Bool)> = [("递交入党申请书", false), ("递交思想汇报", false), ("递交个人小结", false), ("递交转正申请", false)]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.frame.size.width = (UIApplication.sharedApplication().keyWindow?.frame.size.width)!
        
        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        //NavigationBar 的背景，使用了View
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
        
        bgView.backgroundColor = partyRed
        self.view.addSubview(bgView)
        
        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.allowsSelection = false
        
        Applicant.sharedInstance.getPersonalStatus({
            Applicant.sharedInstance.handlePersonalStatus({
                
                guard Applicant.sharedInstance.handInHandler != nil else {
                    MsgDisplay.showErrorMsg("您没有可以递交的文件")
                    return
                }
            
                if let id = Applicant.sharedInstance.handInHandler?.objectForKey("id") as? Int {
                    switch id {
                    case 0:
                        self.contentList[0].available = true
                        break
                    case 4:
                        self.contentList[1].available = true
                        self.contentList[1].title = "递交第一季度思想汇报"
                        break
                    case 5:
                        self.contentList[1].available = true
                        self.contentList[1].title = "递交第二季度思想汇报"
                        break
                    case 6:
                        self.contentList[1].available = true
                        self.contentList[1].title = "递交第三季度思想汇报"
                        break
                    case 7:
                        self.contentList[1].available = true
                        self.contentList[1].title = "递交第四季度思想汇报"
                        break
                    case 21:
                        self.contentList[2].available = true
                        self.contentList[2].title = "递交第一季度个人小结"
                        break
                    case 22:
                        self.contentList[2].available = true
                        self.contentList[2].title = "递交第二季度个人小结"
                        break
                    case 23:
                        self.contentList[2].available = true
                        self.contentList[2].title = "递交第三季度个人小结"
                        break
                    case 24:
                        self.contentList[2].available = true
                        self.contentList[2].title = "递交第四季度个人小结"
                        break
                    case 26:
                        self.contentList[3].available = true
                        break
                    default:
                        break

                    }
                    
                    self.updateUI()
                }
                
                

            })
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateUI() {
        tableView.reloadData()
    }
    
    //Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("PartyHandInCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "PartyHandInCell")
        }
        
        cell?.textLabel?.text = contentList[indexPath.row].title
        cell?.textLabel?.textColor = contentList[indexPath.row].available ? UIColor.blackColor() : UIColor.lightGrayColor()
        
        return cell!
    }
    
    //Table View Data Soucre
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard contentList[indexPath.row].available == true else {
            MsgDisplay.showErrorMsg("您还无法\(contentList[indexPath.row].title)")
            return
        }
        
        
    }
}