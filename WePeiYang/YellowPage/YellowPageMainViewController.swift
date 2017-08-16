//
//  YellowPageMainViewController.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class YellowPageMainViewController: UIViewController {
    
    let titles = ["1895服务大厅", "图书馆", "维修服务中心", "智能自行车", "学生宿舍管理中心", "校医院"]
    let icons = ["icon-1895", "icon-library", "icon-repair", "icon-bike", "icon-building", "icon-hospital"]

    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)

    let sections = PhoneBook.shared.getSections()
    let favorite = PhoneBook.shared.getFavorite()
    
    var shouldLoadSections: [Int] = [] // contains each section which should be loaded
    var shouldLoadFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "黄页";
        // TODO: right button search
        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(YellowPageMainViewController.searchToggle))
        self.navigationItem.rightBarButtonItem = rightButton
       // TODO: color of navigation bar
        // self.navigationController?.navigationBar.tintColor = UIColor(red: 0.1059, green: 0.6352, blue: 0.9019, alpha: 1)

        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }

    }
    
    func searchToggle() {
        let searchVC = YellowPageSearchViewController()
        self.present(searchVC, animated: true, completion: {})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for fooView in (self.navigationController?.navigationBar.subviews)! {
            if fooView.isKind(of: UIVisualEffectView.self) {
                fooView.removeFromSuperview()
            }
        }
    }

    
}

// delegate and dataSource

extension YellowPageMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CommonClientCell
        
        let detailedVC = YellowPageDetailViewController()
        detailedVC.navigationItem.title = cell.label.text
        detailedVC.models = PhoneBook.shared.getModels(with: cell.label.text!)
        self.navigationController?.pushViewController(detailedVC, animated: true)

    }
}

extension YellowPageMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return models.count
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonClientCell", for: indexPath) as! CommonClientCell
        // load data
        cell.load(with: titles[indexPath.row], and: icons[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 15, 5, 15)
    }
    
    
    
}



// MARK: UITableViewDataSource
extension YellowPageMainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                return cell
            }
        case let section where section > 1 && section < 2+sections.count:
            // FIXME: dataSource
            // index in sections: [String]
            
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0: // header: common used
            break
        case 1: // favorite
            if indexPath.row == 0 {
                shouldLoadFavorite = !shouldLoadFavorite
                tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            } else {
                // toggle phone call 
                UIApplication.shared.open(URL(string: "telprompt://\(favorite[indexPath.row-1].phone)")!, options: [:], completionHandler: nil)
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
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                // push to detailed ViewController
                let detailedVC = YellowPageDetailViewController()
                let members = PhoneBook.shared.getMembers(with: sections[n])
                detailedVC.navigationItem.title = members[indexPath.row-1]
                detailedVC.models = PhoneBook.shared.getModels(with: members[indexPath.row-1])
                self.navigationController?.pushViewController(detailedVC, animated: true)
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 2 {
            return 7
        } else {
            return 0.001
        }
    }
}
