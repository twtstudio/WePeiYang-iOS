//
//  CourseTableViewCell.swift
//  WePeiYang
//
//  Created by Allen X on 8/16/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CourseTableViewCell {
    convenience init(course: Courses.Study20.Study20Course) {

        self.init()
        
        let nameLabel = UILabel(text: course.courseName)
        let tapToSeeDetailLabel = UILabel(text: "查看详情")
        nameLabel.font = UIFont.boldSystemFontOfSize(14.0)
        tapToSeeDetailLabel.font = UIFont.boldSystemFontOfSize(14.0)
        //TODO: nameLabel self-sizing
        
        
        contentView.addSubview(tapToSeeDetailLabel)
        tapToSeeDetailLabel.snp_makeConstraints {
            make in
            make.right.equalTo(contentView).offset(-14)
            make.centerY.equalTo(contentView)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints {
            make in
            make.left.equalTo(contentView).offset(14)
            make.centerY.equalTo(contentView)
            make.right.lessThanOrEqualTo(tapToSeeDetailLabel.snp_left).offset(-20)
        }
    }
}