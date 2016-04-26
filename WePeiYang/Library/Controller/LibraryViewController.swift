//
//  LibraryViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ObjectMapper
import MJRefresh
import DZNEmptyDataSet
import BlocksKit

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIScrollViewAccessibilityDelegate {
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var resultData: [LibraryDataItem] = []
    var currentPage = 1
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.jz_navigationBarBackgroundAlpha = 0.0
        self.navigationController?.navigationBar.tintColor = UIColor(red: 22/255.0, green: 151/255.0, blue: 166/255.0, alpha: 1.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.title = "图书馆"
        self.navigationItem.titleView = searchTextField
        self.navigationItem.rightBarButtonItem = UIBarButtonItem().bk_initWithBarButtonSystemItem(.Bookmarks, handler: { handler in
            
        }) as? UIBarButtonItem
//        resultTableView.tableHeaderView = {
//            let view = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 120))
//            view.backgroundColor = UIColor(red: 22/255.0, green: 151/255.0, blue: 166/255.0, alpha: 1.0)
//            return view
//        }()
        resultTableView.registerNib(UINib(nibName: "LibraryTableViewCell", bundle: nil), forCellReuseIdentifier: "libCellIdentifier")
        resultTableView.rowHeight = UITableViewAutomaticDimension
        resultTableView.estimatedRowHeight = 98.0
        resultTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.nextPage()
        })
        resultTableView.mj_footer.automaticallyHidden = true
        resultTableView.emptyDataSetSource = self
        resultTableView.emptyDataSetDelegate = self
        resultTableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.jz_navigationBarBackgroundAlpha = 1.0
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - Methods
    
    @IBAction func search(sender: AnyObject) {
        currentPage = 1
        self.fetchData()
    }
    
    private func nextPage() {
        currentPage = currentPage + 1
        print("Current Page: \(currentPage)")
        self.fetchData()
    }
    
    private func fetchData() {
        if self.searchTextField.text!.isEmpty {
            MsgDisplay.showErrorMsg("请输入搜索关键字")
        } else {
            MsgDisplay.showLoading()
            LibraryDataManager.searchLibrary(searchTextField.text!, page: currentPage, success: { data in
                if self.currentPage == 1 {
                    self.resultData = data
                    self.resultTableView.reloadData()
                    if data.count > 0 {
                        self.resultTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                        MsgDisplay.dismiss()
                    } else {
                        MsgDisplay.showErrorMsg("未找到符合关键字的搜索结果")
                    }
                } else {
                    if data.count > 0 {
                        self.resultData.appendContentsOf(data)
                        self.resultTableView.reloadData()
                        MsgDisplay.dismiss()
                    } else {
                        MsgDisplay.showErrorMsg("已到最后一页")
                        self.currentPage = self.currentPage - 1
                    }
                }
                self.resultTableView.mj_footer.endRefreshing()
            }, failure: { errorMsg in
                MsgDisplay.showErrorMsg(errorMsg)
                self.resultTableView.mj_footer.endRefreshing()
            })
        }
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("libCellIdentifier") as! LibraryTableViewCell
        cell.setLibraryItem(resultData[indexPath.row])
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let addToFavAction = UITableViewRowAction(style: .Default, title: "添加到收藏", handler: { (action, indexPath) in
            print(self.resultData[indexPath.row].title)
            tableView.setEditing(false, animated: true)
        })
        addToFavAction.backgroundColor = UIColor.flatSkyBlueColor()
        return [addToFavAction]
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - Empty Data Set Source
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return nil
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "暂无内容"
        let attr = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        return NSAttributedString(string: text, attributes: attr)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "请从搜索栏开始搜索书目"
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = .ByWordWrapping
        para.alignment = .Center
        let attr = [
            NSFontAttributeName: UIFont.systemFontOfSize(14.0),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: para
        ]
        return NSAttributedString(string: text, attributes: attr)
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
