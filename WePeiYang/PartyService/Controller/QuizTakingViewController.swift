//
//  QuizTakingViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/24/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

class QuizTakingViewController: UIViewController {
    var courseID: String? = nil
    var originalAnswer: [Int] = []
    var userAnswer: [Int] = []
    let bottomTabBar = UIView(color: .whiteColor())
    /*
    let lastQuiz: UIButton = {
        let foo = UIButton(title: "上一题")
        foo.titleLabel?.textColor = .whiteColor()
        foo.layer.cornerRadius = 8
        foo.backgroundColor = .redColor()
        foo.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.swipeToLastQuiz), forControlEvents: .TouchUpInside)
        return foo
    }()
    
    let nextQuiz: UIButton = {
        let foo = UIButton(title: "下一题")
        foo.titleLabel?.textColor = .whiteColor()
        foo.layer.cornerRadius = 8
        foo.backgroundColor = .redColor()
        foo.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.swipeToNextQuiz), forControlEvents: .TouchUpInside)
        return foo
    }()
    
    let allQuizes: UIButton = {
        let foo = UIButton(title: "所有题目")
        foo.titleLabel?.textColor = .whiteColor()
        foo.layer.cornerRadius = 8
        foo.backgroundColor = .redColor()
        foo.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.showAllQuizesList), forControlEvents: .TouchUpInside)
        return foo
    }()*/
    let lastQuiz = UIButton(title: "上一题")
    let nextQuiz = UIButton(title: "下一题")
    let allQuizes = UIButton(title: "所有题目")
    
    var quizList: [Courses.Study20.Quiz?] = []

    
    override func viewWillAppear(animated: Bool) {
        self.view.frame.size.width = (UIApplication.sharedApplication().keyWindow?.frame.size.width)!
        
        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        //NavigationBar 的背景，使用了View
        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
        
        bgView.backgroundColor = partyRed
        self.view.addSubview(bgView)
        
        //改变 statusBar 颜色
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        let quizSubmitBtn = UIBarButtonItem(title: "交卷", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(QuizTakingViewController.submitAnswer))
        
        self.navigationItem.setRightBarButtonItem(quizSubmitBtn, animated: true)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lastQuiz.titleLabel?.textColor = .whiteColor()
        lastQuiz.layer.cornerRadius = 8
        lastQuiz.backgroundColor = .redColor()
        lastQuiz.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.swipeToLastQuiz), forControlEvents: .TouchUpInside)
        
        nextQuiz.titleLabel?.textColor = .whiteColor()
        nextQuiz.layer.cornerRadius = 8
        nextQuiz.backgroundColor = .redColor()
        nextQuiz.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.swipeToNextQuiz), forControlEvents: .TouchUpInside)
        
        allQuizes.titleLabel?.textColor = .whiteColor()
        allQuizes.layer.cornerRadius = 8
        allQuizes.backgroundColor = .redColor()
        allQuizes.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.showAllQuizesList), forControlEvents: .TouchUpInside)
        
        computeLayout()
        
        let shadowPath = UIBezierPath(rect: bottomTabBar.bounds)
        bottomTabBar.layer.masksToBounds = false
        bottomTabBar.layer.shadowColor = UIColor.blackColor().CGColor
        bottomTabBar.layer.shadowOffset = CGSizeMake(0.0, 0.5)
        bottomTabBar.layer.shadowOpacity = 0.5
        bottomTabBar.layer.shadowPath = shadowPath.CGPath
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//SnapKit layout Computation
extension QuizTakingViewController {
    func computeLayout() {
        
        self.bottomTabBar.addSubview(lastQuiz)
        lastQuiz.snp_makeConstraints {
            make in
            make.left.equalTo(self.bottomTabBar).offset(10)
            make.centerY.equalTo(self.bottomTabBar)
            make.width.equalTo(88)
        }
        
        self.bottomTabBar.addSubview(nextQuiz)
        nextQuiz.snp_makeConstraints {
            make in
            make.right.equalTo(self.bottomTabBar).offset(-10)
            make.centerY.equalTo(self.bottomTabBar)
            make.width.equalTo(88)
        }
        
        self.bottomTabBar.addSubview(allQuizes)
        allQuizes.snp_makeConstraints {
            make in
            make.center.equalTo(self.bottomTabBar)
            make.width.equalTo(88)
        }
        
        self.view.addSubview(bottomTabBar)
        bottomTabBar.snp_makeConstraints {
            make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(60)
        }
    }
}


extension QuizTakingViewController {
    convenience init(courseID: String) {
        self.init()
        self.courseID = courseID
    }
}


//Logic Func
extension QuizTakingViewController {
    func submitAnswer() {
        Courses.Study20.submitAnswer(of: self.courseID!, answer: self.originalAnswer, userAnswer: self.userAnswer) {
            log.word("fuckers")/
        }
    }
    
    func swipeToNextQuiz() {
        
    }
    
    func swipeToLastQuiz() {
        
    }
    
    func showAllQuizesList() {
        
    }

}