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
    func showSettingsController();
}

class SidebarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sideTableView: UITableView!
    var headerView: UIView!
    var logHeaderView: UIView!
    var nameLabel: UILabel!
    
    var delegate: SidebarDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sideTableView.delegate = self
        sideTableView.dataSource = self
        
        headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 260))
        headerView.backgroundColor = UIColor.flatBlueColorDark()
        let avatarView = UIImageView(image: UIImage(named: "thumbIcon"))
        headerView.addSubview(avatarView)
        avatarView.mas_makeConstraints({make in
            make.top.equalTo()(self.headerView).offset()(70)
            make.width.equalTo()(120)
            make.height.equalTo()(120)
            make.centerX.equalTo()(self.headerView).offset()(-45)
        })
        avatarView.layer.cornerRadius = 60
        avatarView.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey(ID_SAVE_KEY)
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor.whiteColor()
        headerView.addSubview(nameLabel)
        nameLabel.mas_makeConstraints({make in
            make.top.equalTo()(avatarView).offset()(140)
            make.centerX.equalTo()(avatarView)
            make.width.equalTo()(240)
        })
        
        logHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 260))
        let logBtn = UIButton(type: .System)
        logBtn.setTitle("登录", forState: .Normal)
        logBtn.bk_addEventHandler({handler in
            let loginVC = LoginViewController(nibName: nil, bundle: nil)
            self.presentViewController(loginVC, animated: true, completion: nil)
        }, forControlEvents: .TouchUpInside)
        logHeaderView.addSubview(logBtn)
        logBtn.mas_makeConstraints({make in
            make.center.equalTo()(self.logHeaderView)
            make.width.equalTo()(160)
            make.height.equalTo()(80)
        })
        
        sideTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView() {
        sideTableView.reloadData()
        nameLabel.text = NSUserDefaults.standardUserDefaults().stringForKey(ID_SAVE_KEY)
    }
    
    // TABLE VIEW
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if AccountManager.tokenExists() {
            return headerView
        } else {
            return logHeaderView
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 260
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        let row = indexPath.row
        switch row {
        case 0:
            cell.textLabel?.text = "新闻"
            cell.imageView?.image = UIImage(named: "newsTab")
        case 1:
            cell.textLabel?.text = "成绩"
            cell.imageView?.image = UIImage(named: "gpaTab")
        case 2:
            cell.textLabel?.text = "图书馆"
            cell.imageView?.image = UIImage(named: "libTab")
        case 3:
            cell.textLabel?.text = "设置"
            cell.imageView?.image = UIImage(named: "settingTab")
        default:
            break
        }
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
        case 3:
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
