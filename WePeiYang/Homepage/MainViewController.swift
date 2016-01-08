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

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeCarouselCellDelegate {
    
    @IBOutlet var mainTableView: UITableView!
    
    var carouselArr = []
    var campusArr = []
    var announceArr = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "微北洋"
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        let menuBtn = UIBarButtonItem().bk_initWithImage(UIImage(named: "menu"), style: .Plain, handler: {handler in
            self.sideMenuViewController.presentLeftMenuViewController()
        }) as! UIBarButtonItem
        self.navigationItem.leftBarButtonItem = menuBtn
        
        self.mainTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getData()
        })
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        mainTableView.reloadData()
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
            return 3 // News
        case 4:
            return 3 // Announcements
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
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
            let carouselCell = HomeCarouselCell(style: .Default, reuseIdentifier: "identifier")
            carouselCell.delegate = self
            if carouselArr.count > 0 {
                carouselCell.setArrayObject(carouselArr as! [HomeCellData])
            }
            return carouselCell
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
    
    // HOME CAROUSEL DELEGATE
    
    func goToContent(content: HomeCellData) {
        let newsData = NewsData()
        newsData.index = content.index
        newsData.subject = content.subject
        newsData.pic = content.pic
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contentVC = storyboard.instantiateViewControllerWithIdentifier("NewsContentViewController") as! NewsContentViewController
        contentVC.newsData = newsData
        self.navigationController?.showViewController(contentVC, sender: nil)
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
