//
//  HomeNewsTableViewCell.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class HomeNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setObject(obj: NewsData) {
        titleLabel.text = obj.subject
        imgView.setImageWithURL(NSURL(string: obj.pic ?? "")!, placeholderImage: UIImage(named: "twtLogo"))
    }
    
}
