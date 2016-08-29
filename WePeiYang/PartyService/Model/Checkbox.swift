//
//  Checkbox.swift
//  WePeiYang
//
//  Created by Allen X on 8/25/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class Checkbox: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var nameLabel = UILabel()
    var wasChosen = false
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        self.addTarget(target, action: action, forControlEvents: controlEvents)
        let tapOnLabel = UITapGestureRecognizer(target: target, action: action)
        self.nameLabel.addGestureRecognizer(tapOnLabel)
    }
    
    static func initOnlyChoiceBtns(with quizOptions: [Courses.Study20.QuizOption]) -> [Checkbox] {
            return quizOptions.flatMap({ (option: Courses.Study20.QuizOption) -> Checkbox? in
                return Checkbox(withSingleChoiceBtn: option)
            })
    }
    
    static func initMultiChoicesBtns(with quizOptions: [Courses.Study20.QuizOption]) -> [Checkbox] {
        return quizOptions.flatMap({ (option: Courses.Study20.QuizOption) -> Checkbox? in
            return Checkbox(withMultiChoicesBtn: option)
        })
    }
    
    convenience init(withSingleChoiceBtn quizOptionSingleChoice: Courses.Study20.QuizOption) {
        self.init()
        self.nameLabel = {
            let foo = UILabel(text: quizOptionSingleChoice.name, fontSize: 16)
            foo.userInteractionEnabled = true
            foo.textColor = .blackColor()
            return foo
        }()
        self.layer.cornerRadius = self.frame.width/2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.backgroundColor = .grayColor()
        self.tag = quizOptionSingleChoice.weight
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp_makeConstraints {
            make in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp_right).offset(10)
        }
        self.addTarget(self, action: #selector(Checkbox.beTapped), forControlEvents: .TouchUpInside)
    }
    
    convenience init(withMultiChoicesBtn quizOptionMultiChoices: Courses.Study20.QuizOption) {
        self.init()
        self.nameLabel = {
            let foo = UILabel(text: quizOptionMultiChoices.name, fontSize: 16)
            foo.userInteractionEnabled = true
            foo.textColor = .blackColor()
            return foo
        }()
        
        //self.layer.cornerRadius = self.frame.width/2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.backgroundColor = .grayColor()
        self.tag = quizOptionMultiChoices.weight
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp_makeConstraints {
            make in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp_right).offset(10)
        }
        self.addTarget(self, action: #selector(Checkbox.beTapped), forControlEvents: .TouchUpInside)
    }
    
    func beTapped() {
        self.wasChosen = !self.wasChosen
        if wasChosen {
            self.backgroundColor = .greenColor()
        }
    }
    

}
