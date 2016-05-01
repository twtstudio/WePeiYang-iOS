//
//  LostFoundTableViewCell.swift
//  WePeiYang
//
//  Created by Qin Yubo on 16/3/31.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class LostFoundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLostFoundItem(obj: LostFoundItem, type: Int) {
        nameLabel.text = obj.name
        titleLabel.text = obj.title
        placeLabel.text = obj.place
        timeLabel.text = obj.time
        phoneLabel.text = obj.phone
        if type == 0 {
            // lost
            /*
             'lost_type' => [
             '0' => '其它，用户自定义',
             '1' => '银行卡',
             '2' => '饭卡&身份证',
             '3' => '钥匙',
             '4' => '书包',
             '5' => '电脑包',
             '6' => '手表&饰品',
             '7' => 'U盘&硬盘',
             '8' => '水杯',
             '9' => '书',
             '10' => '手机'
             ],
             */
            switch obj.lostType {
            case 0:
                picImageView.image = UIImage(named: "lf_item_lostDefault")
            case 1:
                picImageView.image = UIImage(named: "lf_item_card")
            case 2:
                picImageView.image = UIImage(named: "lf_item_idcard")
            case 3:
                picImageView.image = UIImage(named: "lf_item_key")
            case 4:
                picImageView.image = UIImage(named: "lf_item_schoolbag")
            case 5:
                picImageView.image = UIImage(named: "lf_item_pcbag")
            case 6:
                picImageView.image = UIImage(named: "lf_item_watch")
            case 7:
                picImageView.image = UIImage(named: "lf_item_udisk")
            case 8:
                picImageView.image = UIImage(named: "lf_item_cup")
            case 9:
                picImageView.image = UIImage(named: "lf_item_book")
            case 10:
                picImageView.image = UIImage(named: "lf_item_phone")
            default:
                break
            }
        } else {
            picImageView.setImageWithURL(NSURL(string: obj.foundPic)!, placeholderImage: UIImage(named: "lf_item_foundDefault"))
        }
    }
    
}
