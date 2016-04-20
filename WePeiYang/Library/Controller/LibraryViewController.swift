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

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var resultData: [LibraryDataItem] = []
    var currentPage = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.jz_navigationBarBackgroundAlpha = 0.0
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = ""
        self.automaticallyAdjustsScrollViewInsets = false
        
        resultTableView.tableHeaderView = {
            let view = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 230))
            view.backgroundColor = UIColor.flatBlueColor()
            return view
        }()
        resultTableView.rowHeight = UITableViewAutomaticDimension
        resultTableView.estimatedRowHeight = 44.0
        resultTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.nextPage()
        })
        resultTableView.mj_footer.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.jz_navigationBarBackgroundAlpha = 1.0
    }
    
    // MARK: - Methods
    
    @IBAction func search(sender: AnyObject) {
        currentPage = 0
        self.fetchData()
    }
    
    private func nextPage() {
        currentPage = currentPage + 1
        print("Current Page: \(currentPage)")
        self.fetchData()
    }
    
    private func fetchData() {
        LibraryDataManager.searchLibrary(searchTextField.text!, page: currentPage, success: { data in
            if self.searchTextField.text!.isEmpty {
                MsgDisplay.showErrorMsg("请输入搜索关键字")
            } else {
                if self.currentPage == 0 {
                    self.resultData = data
                    self.resultTableView.reloadData()
                    if data.count > 0 {
                        self.resultTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                    }
                    self.resultTableView.mj_footer.hidden = false
                } else {
                    if data.count > 0 {
                        self.resultData.appendContentsOf(data)
                        self.resultTableView.reloadData()
                    } else {
                        MsgDisplay.showErrorMsg("已到最后一页")
                        self.currentPage = self.currentPage - 1
                    }
                }
                self.resultTableView.mj_footer.endRefreshing()
            }
        }, failure: { errorMsg in
            MsgDisplay.showErrorMsg(errorMsg)
            self.resultTableView.mj_footer.endRefreshing()
        })
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("libIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "libIdentifier")
        }
        cell!.textLabel!.text = resultData[indexPath.row].title
        return cell!
    }
    
    // MARK: - Table View Delegate
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
