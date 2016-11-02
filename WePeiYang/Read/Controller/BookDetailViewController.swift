//
//  ViewController.swift
//  TableView
//
//  Created by Kyrie Wei on 10/25/16.
//  Copyright © 2016 Kyrie Wei. All rights reserved.
//

import Foundation
import UIKit

class BookDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let detailTableView = UITableView()
    var currentBook: Book? = nil
    var tmpSearchView: Search? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.estimatedRowHeight = 50
        detailTableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(detailTableView)
        self.detailTableView.snp_makeConstraints {
            make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(self.view)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.jz_navigationBarBackgroundAlpha = 0
        self.jz_navigationBarBackgroundHidden = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1: return {
            guard self.currentBook != nil else {
                return 0
            }
            return self.currentBook!.status.count
        }()
            
        case 2: return {
            guard self.currentBook != nil else {
                return 0
            }
            return self.currentBook!.reviews.count
        }()
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("DetailInfoCell")
//        if cell == nil {
//            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "DetailInfoCell")
//        }
        
        if indexPath.section == 1{
            if self.currentBook!.status.count != 0 {
                if let cell = tableView.dequeueReusableCellWithIdentifier("StatusInfoCell") {
                    return cell
                }
                let cell = StatusInfoCell(status: self.currentBook!.status[indexPath.row].statusInLibrary , barcode: self.currentBook!.status[indexPath.row].barcode , location: self.currentBook!.status[indexPath.row].library, duetime: self.currentBook!.status[indexPath.row].dueTime)
                return cell
            }

        } else if indexPath.section == 2 {
            //书评
            if self.currentBook!.reviews.count != 0 {
                if let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell") {
                    return cell
                }
                let cell = ReviewCell(model: self.currentBook!.reviews[indexPath.row])
                return cell
            }
        }
            return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        if section == 0 {
        //            return 47
        //        }
        //        return 30
        switch section {
        case 0:
            return UIScreen.mainScreen().bounds.height + 100
        case 1:
            return 47
        case 2:
            return 30
        default:
            return 0
        }
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) ->CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 0
//        case 1:
//            return 50
//        default:
//            return 100
//        }
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0: return {
            guard self.currentBook != nil else {
                let foo = UIImageView(image: UIImage(named: "bookDetailPlaceholder"))
                foo.frame = CGRect(x: 0, y: -64, width: self.view.frame.width, height: self.view.frame.height)
                foo.contentMode = .ScaleAspectFit
                return foo
            }
            let headerView = CoverView(book: self.currentBook!)
            //改变 statusBar 颜色
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
            return headerView
            }()
        case 1: return {
            let headerView = UIView()
            headerView.backgroundColor = UIColor(red: 247/255.0, green:247/255.0, blue:247/255.0, alpha:1.0)
            let viewOfLabels = UIView()
            viewOfLabels.backgroundColor = .whiteColor()
            
            let headerLabel = UILabel()
            headerLabel.text = "在馆信息"
            headerLabel.font = UIFont(name: "Futura", size: 17)
            headerLabel.textColor = UIColor.lightGrayColor()
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            headerLabel.snp_makeConstraints{
                make in
                make.left.equalTo(headerView).offset(16)
                make.top.equalTo(headerView).offset(5)
            }
            
            let barcode = UILabel()
            barcode.text = "索书号"
            barcode.font = UIFont(name: "Futura", size: 14)
            barcode.textAlignment = .Center
            barcode.textColor = UIColor.lightGrayColor()
            //            headerView.addSubview(barcode)
            //            barcode.snp_makeConstraints{
            //                make in
            //                make.left.equalTo(headerView)
            //                make.right.equalTo(headerView).offset((-self.view.frame.size.width / 3) * 2)
            //                make.bottom.equalTo(headerView)
            //            }
            viewOfLabels.addSubview(barcode)
            barcode.snp_makeConstraints {
                make in
                make.top.equalTo(viewOfLabels.snp_top)
                make.bottom.equalTo(viewOfLabels.snp_bottom)
                make.left.equalTo(viewOfLabels).offset(16)
            }
            
            let locationLabel = UILabel()
            locationLabel.text = "所在馆藏地点"
            locationLabel.textAlignment = .Center
            locationLabel.font = UIFont(name: "Futura", size: 14)
            locationLabel.textColor = UIColor.lightGrayColor()
            locationLabel.backgroundColor = UIColor.whiteColor()
            //            headerView.addSubview(locationLabel)
            //            locationLabel.snp_makeConstraints{
            //                make in
            //                make.left.equalTo(barcode.snp_right)
            //                make.right.equalTo(headerView).offset(-self.view.frame.size.width / 3)
            //                make.centerY.equalTo(barcode.snp_centerY)
            //            }
            viewOfLabels.addSubview(locationLabel)
            locationLabel.snp_makeConstraints {
                make in
                make.top.equalTo(viewOfLabels.snp_top)
                make.bottom.equalTo(viewOfLabels.snp_bottom)
                make.centerX.equalTo(viewOfLabels.snp_centerX)
            }
            
            let statusLabel = UILabel()
            statusLabel.text = "在馆状态"
            statusLabel.textAlignment = .Center
            statusLabel.font = UIFont(name: "Futura", size: 14)
            statusLabel.textColor = UIColor.lightGrayColor()
            statusLabel.backgroundColor = UIColor.whiteColor()
            //            headerView.addSubview(statusLabel)
            //            statusLabel.snp_makeConstraints{
            //                make in
            //                make.left.equalTo(locationLabel.snp_right)
            //                make.right.equalTo(headerView)
            //                make.centerY.equalTo(barcode.snp_centerY)
            //            }
            viewOfLabels.addSubview(statusLabel)
            statusLabel.snp_makeConstraints {
                make in
                make.top.equalTo(viewOfLabels.snp_top)
                make.bottom.equalTo(viewOfLabels.snp_bottom)
                make.right.equalTo(viewOfLabels.snp_right).offset(-16)
            }
            
            headerView.addSubview(viewOfLabels)
            viewOfLabels.snp_makeConstraints {
                make in
                make.left.right.equalTo(headerView)
                make.top.equalTo(headerLabel.snp_bottom).offset(8)
                
            }
            
            return headerView
            
            }()
        case 2: return {
            let headerView = UIView()
            headerView.backgroundColor = UIColor(red: 247/255.0, green:247/255.0, blue:247/255.0, alpha:1.0)
            
            let headerLabel2 = UILabel()
            headerLabel2.text = "全部书评"
            headerLabel2.font = UIFont(name: "Futura", size: 17)
            headerLabel2.textColor = UIColor.lightGrayColor()
            headerView.addSubview(headerLabel2)
            headerLabel2.snp_makeConstraints{
                make in
                make.left.equalTo(headerView).offset(16)
                make.top.equalTo(headerView).offset(5)
            }
            return headerView
            }()
        default:
            return nil
        }
    }
    
    
}

extension BookDetailViewController {
    convenience init(bookID: String) {
        self.init()
        //TODO: FIX THE CRASH WHEN NO DATA WAS FETCHED
        Librarian.getBookDetail(ofID: bookID) {
            book in
            self.currentBook = book
            self.navigationController?.navigationBarHidden = false
            self.detailTableView.reloadData()
        }
    }
    
    convenience init(bookID: String, tmpSearchView: Search) {
        self.init()
        //TODO: FIX THE CRASH WHEN NO DATA WAS FETCHED
        Librarian.getBookDetail(ofID: bookID) {
            book in
            self.currentBook = book
            self.tmpSearchView = tmpSearchView
            self.navigationController?.navigationBarHidden = false
            self.detailTableView.reloadData()
        }
    }
    
    convenience init(book: Book) {
        self.init()
        self.currentBook = book
    }
}
