//
//  SignUpTableViewCell.swift
//  WePeiYang
//
//  Created by Allen X on 8/19/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func signUp(sender: UIButton!) {
        
        switch sender.tag {
            
        case 0:
            ApplicantTest.ApplicantEntry.signUp(forID: (ApplicantTest.ApplicantEntry.testInfo?.id)!) {
                sender.refreshViewForState()
            }
        case 1:
            ApplicantTest.AcademyEntry.signUp(forID: (ApplicantTest.AcademyEntry.testInfo?.id)!) {
                sender.refreshViewForState()
            }
        default:
            log.word("cool")/
        }
        log.word("entered func")/
    }
    

}


extension SignUpTableViewCell {
    convenience init(status: Int?, message: String?, testIdentifier: Int) {
        self.init()
        let signUpBtn = UIButton(status: status, identifier: testIdentifier)
        //signUpBtn.bindToFunc()
        
        if status == 1 {
            signUpBtn.addTarget(self, action: #selector(SignUpTableViewCell.signUp(_:)), forControlEvents: .TouchUpInside)
        }
        let msgLabel = UILabel(text: message)
        msgLabel.numberOfLines = 0
        
        contentView.addSubview(signUpBtn)
        signUpBtn.snp_makeConstraints {
            make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(16)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(msgLabel)
        msgLabel.snp_makeConstraints {
            make in
            make.centerY.equalTo(signUpBtn)
            make.right.equalTo(contentView).offset(-16)
            make.left.equalTo(signUpBtn.snp_right).offset(50)
            //make.width.equalTo(220)
        }
    }
}


private extension UIButton {
    
    convenience init(status: Int?, identifier: Int) {
        self.init()
        if status != nil && status != 0 {
            backgroundColor = .greenColor()
        } else {
            backgroundColor = .lightGrayColor()
        }
        
        layer.cornerRadius = 8
        setTitle("报名", forState: .Normal)
        titleLabel?.textColor = .whiteColor()
        tag = identifier
        //titleLabel?.sizeToFit()
    
    }
    
    func refreshViewForState() {
        
        var status: Int? = nil
        
        switch self.tag {
        case 0:
            status = ApplicantTest.ApplicantEntry.status!
        case 1:
            status = ApplicantTest.AcademyEntry.status!
            
        default:
            status = 0
            
        }
        
        if status != nil && status != 0 {
            backgroundColor = .greenColor()
        } else {
            backgroundColor = .lightGrayColor()
        }
    }
    
}