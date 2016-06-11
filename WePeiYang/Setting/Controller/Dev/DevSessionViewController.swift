//
//  DevSessionViewController.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/6/2.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import SwiftyJSON
import BlocksKit

class DevSessionViewController: UIViewController {
    
    var sessionRecord: DevSessionRecord?
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var codeView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = segmentedControl
        self.navigationController?.navigationBar.topItem?.title = ""
        let shareBtn = UIBarButtonItem().bk_initWithBarButtonSystemItem(.Action, handler: { handler in
            let activityItems = [self.sessionRecord!.parameters!, self.sessionRecord!.response!]
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityController.modalPresentationStyle = .Popover
            activityController.popoverPresentationController!.permittedArrowDirections = .Any
            activityController.popoverPresentationController!.barButtonItem = self.navigationItem.rightBarButtonItem
            self.presentViewController(activityController, animated: true, completion: nil)
        }) as! UIBarButtonItem
        self.navigationItem.rightBarButtonItem = shareBtn
        
        self.showJSONCode(JSON(sessionRecord!.parameters!))
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
            self.showJSONCode(JSON(sessionRecord!.parameters!))
        } else {
            self.showJSONCode(JSON(sessionRecord!.response!))
        }
    }
    
    private func showJSONCode(json: JSON) {
        let htmlStr = "<!DOCTYPE html><html><head></head><body><link rel=\"stylesheet\" href=\"color-brewer.css\"><script src=\"highlight.js\"></script><script>hljs.initHighlightingOnLoad();</script> <pre><code class=\"JSON\">\(json)</code></pre></body></html>"
        codeView.loadHTMLString(htmlStr, baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().resourcePath!))
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
