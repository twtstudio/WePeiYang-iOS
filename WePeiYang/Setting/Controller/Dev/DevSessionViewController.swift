//
//  DevSessionViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/6/2.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class DevSessionViewController: UIViewController {
    
    var sessionRecord: DevSessionRecord?
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = segmentedControl
        textView.text = "\(sessionRecord?.parameters)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    @IBAction func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            textView.text = "\(sessionRecord!.parameters!)"
        } else {
            textView.text = "\(sessionRecord!.response!)"
        }
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
