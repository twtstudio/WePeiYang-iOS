//
//  NewsViewTableViewController+UIViewControllerPreviewing.swift
//  WePeiYang
//
//  Created by Allen X on 12/7/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//


extension NewsTableViewController: UIViewControllerPreviewingDelegate {
    public func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location), let cell = tableView.cellForRowAtIndexPath(indexPath) else {
                return nil
        }
        
        let newsContentViewController = NewsContentViewController()
        newsContentViewController.newsData = self.dataArr[indexPath.row] as! NewsData
        
        newsContentViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        } else {
            // Fallback on earlier versions
        }
        
        return newsContentViewController
    }
    
    public func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}