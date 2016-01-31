//
//  WebAppTableViewCell.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/1/31.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class WebAppTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.layer.cornerRadius = 7.0
        iconImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setObject(obj: WebAppItem) {
        titleLabel.text = obj.name
        descLabel.text = obj.desc
        iconImageView.setImageWithURL(NSURL(string: obj.iconUrl ?? "")!, placeholderImage: UIImage(named: "wpyLogo"))
    }
    
}
