//
//  YellowPageMainViewController.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class YellowPageMainViewController: UIViewController, YellowPageCellDelegate {
    
    let titles = ["1895综合服务大厅", "图书馆", "维修服务中心", "校园自行车", "学生宿舍管理中心", "天大医院"]
    let icons = ["icon-1895", "icon-library", "icon-repair", "icon-bike", "icon-building", "icon-hospital"]

    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .Grouped)

    var sections: [String] {
        return PhoneBook.shared.sections
    }
    var favorite: [ClientItem] {
        return PhoneBook.shared.favorite
    }
    
    var shouldLoadSections: [Int] = [] // contains each section which should be loaded
    var shouldLoadFavorite = false
    var shouldPop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        //self.navigationItem.title = "黄页";
        let titleLabel = UILabel(text: "黄页")
        self.title = "黄页"
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(18.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel

        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(YellowPageMainViewController.searchToggle))
        self.navigationItem.rightBarButtonItem = rightButton

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)

        tableView.snp_makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        MsgDisplay.showLoading()
        PhoneBook.shared.load({
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                MsgDisplay.dismiss()
            })
            }, failure: {
                PhoneBook.checkVersion({
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                        MsgDisplay.dismiss()
                    })
                })
        })

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.1059, green: 0.6352, blue: 0.9019, alpha: 1)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
        shouldPop = true
    }
    
    func searchToggle() {
        let searchVC = YellowPageSearchViewController()
        self.presentViewController(searchVC, animated: true, completion: nil)
    }
    
}

// delegate and dataSource

extension YellowPageMainViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! CommonClientCell
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CommonClientCell
        let detailedVC = YellowPageDetailViewController()
        detailedVC.navigationItem.title = cell.label.text
        detailedVC.models = PhoneBook.shared.getModels(with: cell.label.text!)
        shouldPop = false
        self.navigationController?.pushViewController(detailedVC, animated: true)
    }
}

extension YellowPageMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CommonClientCell", forIndexPath: indexPath) as! CommonClientCell
        // load data
        cell.load(with: titles[indexPath.row], and: icons[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 15, 5, 15)

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
}



// MARK: UITableViewDataSource
extension YellowPageMainViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 + sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if shouldLoadFavorite {
                return favorite.count+1
            } else {
                return 1
            }
        case let section where section > 1 && section < 2+sections.count:
            let n = section - 2
            if shouldLoadSections.contains(n) {
                return PhoneBook.shared.getMembers(with: sections[n]).count+1
            } else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = YellowPageCell(with: .header, name: "")
            cell.commonView.collectionView.delegate = self
            cell.commonView.collectionView.dataSource = self
            return cell
        case 1:
            if indexPath.row == 0 { // section
                let cell = YellowPageCell(with: .section, name: "我的收藏")
                cell.canUnfold = !shouldLoadFavorite
                cell.countLabel.text = "\(favorite.count)"
                return cell
            } else { // detailed item
                let cell = YellowPageCell(with: .detailed, model: favorite[indexPath.row-1])
                cell.delegate = self
                return cell
            }
        case let section where section > 1 && section < 2+sections.count:
            let n = indexPath.section - 2
            let members = PhoneBook.shared.getMembers(with: sections[n])
            
            if indexPath.row == 0 { // section
                let cell = YellowPageCell(with: .section, name: sections[n])
                cell.countLabel.text = "\(members.count)"
                if shouldLoadSections.contains(n) {
                    cell.canUnfold = false
                } else {
                    cell.canUnfold = true
                }
                return cell
            } else {
                if shouldLoadSections.contains(n) {
                    let cell = YellowPageCell(with: .item, name: members[indexPath.row-1])
                    return cell
                }
            }
            let cell = UITableViewCell()
            return cell
        default:
            // will never be executed
            let cell = UITableViewCell()
            return cell
        }

    }
    
}


// MARK: UITableViewDelegate
extension YellowPageMainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0: // header: common used
            break
        case 1: // favorite
            if indexPath.row == 0 {
                shouldLoadFavorite = !shouldLoadFavorite
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
            } else {
                // toggle phone call
                
            }
            
        case let section where section > 1 && section < 2+sections.count: //  section
            let n = indexPath.section - 2
            if indexPath.row == 0 {
                if shouldLoadSections.contains(n) {
                    // if the section is unfolded
                    shouldLoadSections = shouldLoadSections.filter { e in
                        return e != n
                    }
                } else {
                    // will unfold the section
                    shouldLoadSections.append(n)
                }
                
                // reload data
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            } else {
                // push to detailed ViewController
                let detailedVC = YellowPageDetailViewController()
                let members = PhoneBook.shared.getMembers(with: sections[n])
                detailedVC.navigationItem.title = members[indexPath.row-1]
                detailedVC.models = PhoneBook.shared.getModels(with: members[indexPath.row-1])
                shouldPop = false
                self.navigationController?.pushViewController(detailedVC, animated: true)
            }
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            // don't know why i can't just return 0
            return 0.001
        } else if section < 3 {
            return 7
        } else {
            // return 0
            return 0.001
        }
    }
  
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 2 {
            return 7
        } else {
            return 0.001
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if shouldPop {
            self.navigationController?.navigationBar.translucent = true
            self.navigationController?.navigationBar.barTintColor = nil
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
            // self.jz_navigationBarTintColor = nil
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        PhoneBook.shared.save()
    }
}
