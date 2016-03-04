//
//  SidebarViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/5.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol SidebarDelegate {
    func showGPAController();
    func showNewsController();
    func showLibraryController();
    func showClasstableController();
    func showLostFoundController();
    func showMicroservicesController();
    func showSettingsController();
}

class SidebarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sideTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    var userHeaderView: UIView!
    var logHeaderView: UIView!
    var avatarView: UIImageView!
    var nameLabel: UILabel!
    
    var delegate: SidebarDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sideTableView.delegate = self
        sideTableView.dataSource = self
        
        let centerXOffset = CGFloat(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone ? 45 : 145)
        
        userHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 260))
        userHeaderView.backgroundColor = UIColor.flatSkyBlueColor()
        headerView.addSubview(userHeaderView)
        
        let img = UIImage(named: "accountIcon")?.imageWithRenderingMode(.AlwaysTemplate)
        avatarView = UIImageView(image: img)
        avatarView.tintColor = UIColor.whiteColor()
        userHeaderView.addSubview(avatarView)
        avatarView.mas_makeConstraints({make in
            make.top.equalTo()(self.headerView).offset()(70)
            make.width.equalTo()(120)
            make.height.equalTo()(120)
            make.centerX.equalTo()(self.headerView).offset()(-centerXOffset)
        })
        avatarView.layer.cornerRadius = 60
        avatarView.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey(ID_SAVE_KEY)
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor.whiteColor()
        userHeaderView.addSubview(nameLabel)
        nameLabel.mas_makeConstraints({make in
            make.top.equalTo()(self.avatarView).offset()(140)
            make.centerX.equalTo()(self.avatarView)
            make.width.equalTo()(240)
        })
        
        logHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 260))
        logHeaderView.backgroundColor = UIColor.flatSkyBlueColor()
        headerView.addSubview(logHeaderView)
        let logBtn = UIButton(type: .System)
        logBtn.setTitle("登录", forState: .Normal)
        logBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        logBtn.bk_addEventHandler({handler in
            let loginVC = LoginViewController(nibName: nil, bundle: nil)
            self.presentViewController(loginVC, animated: true, completion: nil)
        }, forControlEvents: .TouchUpInside)
        logHeaderView.addSubview(logBtn)
        logBtn.mas_makeConstraints({make in
            make.centerX.equalTo()(self.headerView).offset()(-centerXOffset)
            make.centerY.equalTo()(self.headerView).offset()
            make.width.equalTo()(130)
            make.height.equalTo()(46)
        })
        logBtn.backgroundColor = UIColor.clearColor()
        logBtn.layer.borderColor = UIColor.whiteColor().CGColor
        logBtn.layer.borderWidth = 1.0
        logBtn.layer.cornerRadius = 7.0
        logBtn.clipsToBounds = true
        
        self.updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView() {
        if AccountManager.tokenExists() {
            logHeaderView.alpha = 0
            userHeaderView.alpha = 1
        } else {
            logHeaderView.alpha = 1
            userHeaderView.alpha = 0
        }
        nameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey(ID_SAVE_KEY)
    }
    
    // TABLE VIEW
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        let row = indexPath.row
        switch row {
        case 0:
            cell.textLabel?.text = "新闻"
            cell.imageView?.image = UIImage(named: "newsTab")?.imageWithRenderingMode(.AlwaysTemplate)
        case 1:
            cell.textLabel?.text = "成绩"
            cell.imageView?.image = UIImage(named: "gpaTab")?.imageWithRenderingMode(.AlwaysTemplate)
//        case 2:
//            cell.textLabel?.text = "图书馆"
//            cell.imageView?.image = UIImage(named: "libTab")?.imageWithRenderingMode(.AlwaysTemplate)
        case 2:
            cell.textLabel?.text = "课程表"
            cell.imageView?.image = UIImage(named: "classtableTab")?.imageWithRenderingMode(.AlwaysTemplate)
        case 3:
            cell.textLabel?.text = "失物招领"
            cell.imageView?.image = UIImage(named: "lfTab")?.imageWithRenderingMode(.AlwaysTemplate)
        case 4:
            cell.textLabel?.text = "实验室"
            cell.imageView?.image = UIImage(named: "msTab")?.imageWithRenderingMode(.AlwaysTemplate)
        case 5:
            cell.textLabel?.text = "设置"
            cell.imageView?.image = UIImage(named: "settingTab")?.imageWithRenderingMode(.AlwaysTemplate)
        default:
            break
        }
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.imageView?.tintColor = UIColor.darkGrayColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.sideMenuViewController.hideMenuViewController()
        switch row {
        case 0:
            delegate.showNewsController()
        case 1:
            delegate.showGPAController()
        case 2:
//            delegate.showLibraryController()
            delegate.showClasstableController()
        case 3:
            delegate.showLostFoundController()
        case 4:
            delegate.showMicroservicesController()
        case 5:
            delegate.showSettingsController()
        default:
            break
        }
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
