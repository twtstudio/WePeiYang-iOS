//
//  UserGuideViewController.swift
//  WePeiYang
//
//  Created by Allen X on 4/29/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit
import SnapKit

let NOTIFICATION_GUIDE_DISMISSED = "NOTIFICATION_GUIDE_DISMISSED"

class UserGuideViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    private var scrollView: UIScrollView!
    private let numberOfPages = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.bounds
        scrollView = UIScrollView(frame: frame)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(numberOfPages), height: frame.size.height)

        scrollView.delegate = self
        
        for page in 3 ..< numberOfPages {
            var imageView = UIImageView()
            imageView = UIImageView(image: UIImage(named: "guide\(page + 1)"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(page), y: 0, width: frame.size.width, height: frame.size.height)
            scrollView.addSubview(imageView)
        }
        
        self.view.insertSubview(scrollView, atIndex: 0)
        startButton.layer.cornerRadius = 2.0
        startButton.alpha = 0.0
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_GUIDE_DISMISSED, object: nil)
        })
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


// MARK: - UIScrollViewDelegate
extension UserGuideViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        pageControl.currentPage = Int(offset.x / view.bounds.width)

        if pageControl.currentPage == numberOfPages - 1 {
            UIView.animateWithDuration(0.5) {
                self.startButton.alpha = 1.0
            }
        } else {
            UIView.animateWithDuration(0.2) {
                self.startButton.alpha = 0.0
            }
        }
    }
}
