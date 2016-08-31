//
//  AllQuizViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class AllQuizViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    typealias Quiz = Courses.Study20.Quiz
    let reuseIdentifier = "quizCell"
    var quizList: [Quiz?] = Courses.Study20.courseQuizes
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        //titleLabel设置
        let titleLabel = UILabel(text: "所有题目", fontSize: 17)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = titleLabel;
        
        //NavigationBar 的背景，使用了View
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
        
        bgView.backgroundColor = partyRed
        self.view.addSubview(bgView)
        
        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
    }
    
    convenience init(quizList: [Quiz?]) {
        self.init()
        
        self.quizList = quizList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.makeUICollectionView()
        
    }
    
    func makeUICollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = UICollectionViewScrollDirection.Vertical  //滚动方向
        //layout.itemSize = CGSizeMake(screenWidth/4, 80)
        
        // 设置CollectionView
        let collectionView : UICollectionView = UICollectionView(frame: (UIApplication.sharedApplication().keyWindow?.frame)!, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(QuizCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.view .addSubview(collectionView)
        
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(quizList.count)
        return quizList.count
    }
    
    func  collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! QuizCell
        
        cell.label.text = "\(indexPath.row+1)"
        
        let aQuiz = quizList[indexPath.row]
        cell.imageView.image = aQuiz?.choosenOnesAtIndex == nil ? UIImage(named: "QuizNotDone") : UIImage(named: "QuizDone")
        
        return cell;
        
    }
    //MARK:UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: {
            if let quizTakingVC = UIViewController.currentViewController() as? QuizTakingViewController {
                //show Quiz View
                
                
            }
        })
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.width/5, 80)
    }
    
}