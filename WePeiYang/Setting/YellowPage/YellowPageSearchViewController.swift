//
//  YellowPageSearchViewController.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class YellowPageSearchViewController: UIViewController {
    let searchView = SearchView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 60))
    let tableView = UITableView(frame: CGRect.zero, style: .Plain)

    var history: [String]! = nil
    var result: [ClientItem] = []
    var isSearching = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let history = NSUserDefaults.standardUserDefaults().objectForKey("YellowPageHistory") as? [String] {
            self.history = history
        } else {
            self.history = []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //searchView.backBtn.addTarget(self, action: #selector(YellowPageSearchViewController.backToggled), forControlEvents: .TouchUpInside)
        let backTapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageSearchViewController.backToggled))
        searchView.backBtn.addGestureRecognizer(backTapGesture)
        self.view.addSubview(searchView)
        searchView.textField.becomeFirstResponder()
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.top.equalTo(searchView.snp_bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageSearchViewController.hideKeyboard))
        //tableView.addGestureRecognizer(tapGesture)
        
        // searchView.textField.delegate = self
        
        
        // FIXME: all?
        searchView.textField.addTarget(self, action: #selector(YellowPageSearchViewController.textFieldTextChanged(_:)), forControlEvents: .AllEditingEvents)
        //searchView.textField.addTarget(self, action: #selector(textFieldTextChanged(sender:)), for: .allEditingEvents)
        tableView.sectionFooterHeight = 30

    }
    
    func hideKeyboard() {
        self.searchView.textField.resignFirstResponder()
//        if let text = searchView.textField.text {
//            // FIXME: Write to model singleton
//            if text != "" {
//            }
//        }
    }
    
    func backToggled() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clearTapped() {
        // FIXME: Write to model singleton
        self.history.removeAll()
        tableView.reloadData()
    }
    
    func deleteTapped(sender: UITapGestureRecognizer) {
        let view = sender.view as! WePeiYang.TappableImageView
        let cell = view.superview! as! YellowPageSearchHistoryCell
        let indexPath = tableView.indexPathForCell(cell)!
        self.history.removeAtIndex(indexPath.row)
        tableView.reloadData()
    }
    
    func textFieldTextChanged(sender : AnyObject) {
        // got what you want
        guard searchView.textField.text! != "" else {
            isSearching = false
            tableView.reloadData()
            return
        }
        
        PhoneBook.shared.getResult(with: searchView.textField.text!) { result in
            self.result = result
            self.isSearching = true
            self.tableView.reloadData()
//            dispatch_sync(dispatch_get_main_queue(), {
//                self.tableView.reloadData() // 更新tableView
//            })
        }
        // and refresh the table
        if !history.contains(searchView.textField.text!) {
            self.history.append(searchView.textField.text!)
        }
        // TODO: if not found, display not-found-view
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSUserDefaults.standardUserDefaults().setObject(self.history, forKey: "YellowPageHistory")
        searchView.textField.resignFirstResponder()

    }
}

// MARK: UITableViewDataSource
extension YellowPageSearchViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let text = searchView.textField.text else {
            return 0
        }
        if text == "" {
            return history.count
        } else {
            return result.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchView.textField.text == "" {
            let cell = YellowPageSearchHistoryCell(with: history[indexPath.row])
            let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageSearchViewController.deleteTapped(_:)))
            cell.deleteView.addGestureRecognizer(deleteTapGesture)
            return cell
        } else if self.result.count != 0 {
            let cell = YellowPageCell(with: .detailed, model: result[indexPath.row])
            return cell
        } else { // if self.result.count == 0 {
            
            // FIXME: not found view
            return YellowPageCell(with: .section, model: result[indexPath.row])
        }
    }
}

// MARK: UITableViewDelegate
extension YellowPageSearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        
        // not found
        if history.count != 0 && result.count == 0 && isSearching {
            let label = UILabel()
            // FIXME: replace hint
            label.text = "找不到啊大兄弟"
            label.font = UIFont.boldSystemFontOfSize(16)
            label.textColor = UIColor.magentaColor()
            label.sizeToFit()
            footerView.addSubview(label)
            label.snp_makeConstraints { make in
                make.centerX.equalTo(footerView)
                make.centerY.equalTo(footerView)
            }
            return footerView
        }
        
        if history.count == 0 || self.isSearching {
            return footerView
        }
//        guard history.count != 0 && !self.isSearching else {
//            return footerView
//        }
        let label = UILabel()
        label.text = "清除搜索记录"
        label.font = UIFont.boldSystemFontOfSize(16)
        label.textColor = UIColor.magentaColor()
        label.sizeToFit()
        footerView.addSubview(label)
        label.snp_makeConstraints { make in
            make.centerX.equalTo(footerView)
            make.centerY.equalTo(footerView)
        }
        // TODO: separator
        let clearTapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageSearchViewController.clearTapped))
        footerView.addGestureRecognizer(clearTapGesture)
        return footerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.searchView.textField.resignFirstResponder()
        if !isSearching {
            let text = history[indexPath.row]
            searchView.textField.text = text
            PhoneBook.shared.getResult(with: text) { result in
            self.result = result
            self.isSearching = true
            self.tableView.reloadData()
            //            dispatch_sync(dispatch_get_main_queue(), {
            //                self.tableView.reloadData() // 更新tableView
            //            })
            }
        }
    }
    
}



// MARK: UITextFieldDelegate
//extension YellowPageSearchViewController: UITextFieldDelegate {
//    
//  //  func textFieldDidEndEditing(_ textField: UITextField) {
//        //guard let text = textField.text else {
//        //    return
//        //}
//    //
//    //    tableView.reloadData()
//    //}
//}