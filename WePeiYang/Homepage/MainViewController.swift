//
//  MainViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/5.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import MK
import BlocksKit
import JZNavigationExtension

class MainViewController: UIViewController {
    
    @IBOutlet var mainScrollView: UIScrollView!
    let navigationBarView: NavigationBarView = NavigationBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""

        // Do any additional setup after loading the view.
        navigationBarView.backgroundColor = UIColor(red: 28/255, green: 66/255, blue: 95/255, alpha: 1.0)
        navigationBarView.statusBarStyle = .LightContent
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "微北洋"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = UIFont.systemFontOfSize(20)
        navigationBarView.titleLabel = titleLabel
        navigationBarView.titleLabelInset.left = 64
        navigationBarView.titleLabelInset.top = 16
        
        // Menu button.
        let menuImg: UIImage? = UIImage(named: "menu")
        let menuBtn: FlatButton = FlatButton()
        menuBtn.pulseColor = MaterialColor.white
        menuBtn.pulseFill = true
        menuBtn.pulseScale = false
        menuBtn.setImage(menuImg, forState: .Normal)
        menuBtn.setImage(menuImg, forState: .Highlighted)
        menuBtn.bk_addEventHandler({handler in
            self.sideNavigationViewController?.setSideViewWidth(self.view.frame.width - 80, hidden: true, animated: true)
            self.sideNavigationViewController?.toggle()
        }, forControlEvents: .TouchUpInside)
        
        // Add buttons to left side.
        navigationBarView.leftButtons = [menuBtn]
        
        // To support orientation changes, use MaterialLayout.
        view.addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
        MaterialLayout.height(view, child: navigationBarView, height: 70)
        
        self.initializeScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarView.statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
//        self.viewWillDisappear(animated)
//        self.navigationController?.navigationBarHidden = false
    }
    
    
    func initializeScrollView() {
        let img: UIImage? = UIImage(named: "gpaBtn")
        let button: FabButton = FabButton(frame: CGRectMake(20, 20, 120, 120))
        button.setImage(img, forState: .Normal)
        button.setImage(img, forState: .Highlighted)
        button.shape = .Circle
        button.depth = .Depth1
        button.backgroundColor = UIColor.clearColor()
        button.bk_addEventHandler({handler in
            print("Hello")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gpaController = storyboard.instantiateViewControllerWithIdentifier("GPATableViewController") as! GPATableViewController
            self.navigationController?.showViewController(gpaController, sender: nil)
        }, forControlEvents: .TouchUpInside)
        
        self.mainScrollView.addSubview(button)
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
