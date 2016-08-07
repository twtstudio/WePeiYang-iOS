//
//  LibraryTableViewCell.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/4/26.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLibraryItem(item: LibraryDataItem) {
        self.titleLabel.text = item.title
        self.authorLabel.text = item.author
        self.publisherLabel.text = item.publisher
        self.locationLabel.text = item.location
    }
    
}
