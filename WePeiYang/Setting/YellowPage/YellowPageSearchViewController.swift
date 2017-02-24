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

    var history: [String] = ["记录"]
    var result: [ClientItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        searchView.backBtn.addTarget(self, action: #selector(YellowPageSearchViewController.backToggled), forControlEvents: .TouchUpInside)
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

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(YellowPageSearchViewController.hideKeyboard))
        tableView.addGestureRecognizer(tapGesture)
        
        searchView.textField.delegate = self
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
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
        
        // FIXME: all?
        searchView.textField.addTarget(self, action: #selector(YellowPageSearchViewController.textFieldTextChanged(_:)), forControlEvents: .EditingChanged)
        //searchView.textField.addTarget(self, action: #selector(textFieldTextChanged(sender:)), for: .allEditingEvents)
        tableView.sectionFooterHeight = 30

    }
    
    func hideKeyboard() {
        self.searchView.textField.resignFirstResponder()
    }
    
    func backToggled() {
        self.dismissViewControllerAnimated(true, completion: nil)
        // self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldTextChanged(sender : AnyObject) {
        // got what you want
        self.result = PhoneBook.shared.getItems(with: searchView.textField.text!)
        // and refresh the table
        self.tableView.reloadData() // 更新tableView
        
        // TODO: if not found, display not-found-view
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        if result.count == 0 {
            let cell = YellowPageSearchHistoryCell(with: history[indexPath.row])
            return cell
        } else {
            let cell = YellowPageCell(with: .detailed, model: result[indexPath.row])
            return cell
            
        }
    }
}

// MARK: UITableViewDelegate
extension YellowPageSearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        guard history.count != 0 else {
            return footerView
        }
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
        return footerView
    }
}

// MARK: UITextFieldDelegate
extension YellowPageSearchViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        tableView.reloadData()
    }
}
