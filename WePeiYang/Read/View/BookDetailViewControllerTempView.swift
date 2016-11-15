//
//  BookDetailViewControllerTempView.swift
//  WePeiYang
//
//  Created by Allen X on 11/3/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import Foundation

class BookDetailViewControllerTempView: UIView {
    override func willRemoveSubview(subview: UIView) {
        if subview.isKindOfClass(RateView) || subview.isKindOfClass(UIVisualEffectView) {
            UIViewController.currentViewController().navigationItem.setHidesBackButton(false, animated: true)
        }
    }
}