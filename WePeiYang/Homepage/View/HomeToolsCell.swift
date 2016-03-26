//
//  HomeToolsCell.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit
import ChameleonFramework
import BlocksKit

@objc protocol HomeToolsCellDelegate {
    optional func toolsTappedAtIndex(index: Int)
}

class HomeToolsCell: UITableViewCell {
    
    @IBOutlet weak var firstGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var secondGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var thirdGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var secondImgView: UIImageView!
    @IBOutlet weak var thirdImgView: UIImageView!
    
    var delegate: HomeToolsCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstImgView.tintColor = UIColor.flatTealColor()
        firstImgView.image = UIImage(named: "newsBtn")?.imageWithRenderingMode(.AlwaysTemplate)
        
        secondImgView.tintColor = UIColor.flatPinkColorDark()
        secondImgView.image = UIImage(named: "gpaBtn")?.imageWithRenderingMode(.AlwaysTemplate)
        
        thirdImgView.tintColor = UIColor.flatSkyBlueColor()
        thirdImgView.image = UIImage(named: "classtableTab")?.imageWithRenderingMode(.AlwaysTemplate)
        
        firstGestureRecognizer.addTarget(self, action: #selector(HomeToolsCell.gestureHandler(_:)))
        secondGestureRecognizer.addTarget(self, action: #selector(HomeToolsCell.gestureHandler(_:)))
        thirdGestureRecognizer.addTarget(self, action: #selector(HomeToolsCell.gestureHandler(_:)))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func gestureHandler(recognizer: UITapGestureRecognizer) {
        let view = recognizer.view
        delegate.toolsTappedAtIndex!(view!.tag)
    }
    
}
