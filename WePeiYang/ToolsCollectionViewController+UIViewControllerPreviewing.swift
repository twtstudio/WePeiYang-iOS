//
//  ToolsCollectionViewController+UIViewControllerPreviewing.swift
//  WePeiYang
//
//  Created by Allen X on 12/7/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

extension ToolsCollectionViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView?.indexPathForItemAtPoint(location), cell = collectionView?.cellForItemAtIndexPath(indexPath) else {
            return nil
        }
        
        // Set the source rect to the cell frame, so surrounding elements are blurred.
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        } else {
            // Fallback on earlier versions
        }
        
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gpaVC = storyboard.instantiateViewControllerWithIdentifier("GPATableViewController") as! GPATableViewController
            return gpaVC
        case 1:
            let classtableVC = ClasstableViewController(nibName: "ClasstableViewController", bundle: nil)
            classtableVC.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            return classtableVC
        case 2:
            let lfVC = LostFoundViewController()
            lfVC.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            return lfVC
        case 3:
            let bikeVC = BicycleServiceViewController()
            bikeVC.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            return bikeVC
        case 4:
            let partyVC = PartyMainViewController()
            partyVC.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            return partyVC
        case 6:
            let readVC = ReadViewController()
            readVC.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            return readVC
        default:
            return nil
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        viewControllerToCommit.hidesBottomBarWhenPushed = true
        self.navigationController?.showViewController(viewControllerToCommit, sender: nil)
    }
}
