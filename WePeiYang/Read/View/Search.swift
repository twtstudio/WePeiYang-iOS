//
//  Search.swift
//  YouTube
//
//  Created by Haik Aslanyan on 7/4/16.
//  Copyright © 2016 Haik Aslanyan. All rights reserved.
//

@objc protocol SearchDelegate {
    func hideSearchView(status : Bool)
}

import UIKit

class Search: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var result: [Book] = []
    //MARK: Properties
    let statusView: UIView = {
        let st = UIView.init(frame: UIApplication.sharedApplication().statusBarFrame)
        st.backgroundColor = UIColor.blackColor()
        st.alpha = 0.15
        return st
    }()
    
    lazy var searchView: UIView = {
       let sv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 68))
        sv.backgroundColor = UIColor.whiteColor()
        sv.alpha = 0
        return sv
    }()
    lazy var backgroundView: UIView = {
        let bv = UIView.init(frame: self.frame)
        bv.backgroundColor = UIColor.blackColor()
        bv.alpha = 0
        return bv
    }()
    lazy var backButton: UIButton = {
       let bb = UIButton.init(frame: CGRect.init(x: 0, y: 20, width: 48, height: 48))
        bb.setBackgroundImage(UIImage.init(named: "back"), forState: [])
        bb.addTarget(self, action: #selector(Search.dismiss), forControlEvents: .TouchUpInside)
        return bb
    }()
    lazy var searchField: UITextField = {
        let sf = UITextField.init(frame: CGRect.init(x: 48, y: 20, width: self.frame.width - 50, height: 48))
        sf.placeholder = "查询书籍在馆记录"
        sf.autocapitalizationType = .None
        // sf.keyboardAppearance = UIKeyboardAppearance.Dark
        return sf
    }()
    lazy var tableView: UITableView = {
        let tv: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 68, width: self.frame.width, height: self.frame.height - 68))
        return tv
    }()
    var items = [String]()
    
    var delegate:SearchDelegate?
    
    //MARK: Methods
    func customization()  {
        self.addSubview(self.backgroundView)
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(Search.dismiss)))
        self.addSubview(self.searchView)
        self.searchView.addSubview(self.searchField)
        self.searchView.addSubview(self.backButton)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.searchField.delegate = self
        self.addSubview(self.statusView)
        self.addSubview(self.tableView)
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func animate()  {
        UIView.animateWithDuration(0.2, animations: {
            self.backgroundView.alpha = 0.5
            self.searchView.alpha = 1
            self.searchField.becomeFirstResponder()
        })
    }
    
    func  dismiss()  {
        self.searchField.text = ""
        self.items.removeAll()
        self.tableView.removeFromSuperview()
        UIView.animateWithDuration(0.2, animations: {
            self.backgroundView.alpha = 0
            self.searchView.alpha = 0
            self.searchField.resignFirstResponder()
            }, completion: {(Bool) in
                self.delegate?.hideSearchView(true)
        })
    }
    
    //MARK: TextField Delegates
//    func textField(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if (self.searchField.text == "" || self.searchField.text == nil) {
//            self.items = []
//            self.tableView.removeFromSuperview()
//        } else{
//         //   let _  = URLSession.shared.dataTask(with: requestSuggestionsURL(text: self.searchField.text!), completionHandler: { (data, response, error) in
//                if error == nil {
//                    do {
//                        let json  = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
//                        self.items = json[1] as! [String]
//                        DispatchQueue.main.async(execute: {
//                            if self.items.count > 0  {
//                                self.addSubview(self.tableView)
//                            } else {
//                                self.tableView.removeFromSuperview()
//                            }
//                            self.tableView.reloadData()
//                        })
//                    } catch _ {
//                        print("Something wrong happened")
//                    }
//                } else {
//                    print("error downloading suggestions")
//                }
//            }).resume()
//        }
//        return true
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        dismiss()
//        return true
//    }
    
    //MARK: TableView Delegates and Datasources
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let book = Book()
        let book = Book(ISBN: "dsf")
//        book.author = "郑渊洁"
//        book.publisher = "什么出版社"
//        book.rate = 9.0
//        book.year = 1990
//        book.title = "舒克与贝塔"
        let cell = SearchResultCell(model: book)
        cell.cover.setImageWithURL(NSURL(string: "https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=379841942,1689731392&fm=58")!)
        return cell
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchField.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: Inits
   override init(frame: CGRect) {
        super.init(frame: frame)
        customization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

