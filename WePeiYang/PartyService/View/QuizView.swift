//
//  QuizView.swift
//  WePeiYang
//
//  Created by Allen X on 8/25/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//


class QuizView: UIView {
    var quizDescLabel = UILabel()
    //题目总加权
    var userSelectedWeight = 0
    var originalAnswerWeight = 0
    var hasMultipleChoices = false
    
    var optionButtons: [Checkbox] = []
    
    func didSelectOptionButton(button: Checkbox) {
        
        if !hasMultipleChoices {
            for foo in optionButtons {
                if foo != button {
                    foo.beTapped()
                }
            }
        }
    }
    
    func calculateUserAnswerWeight() -> Int {
        for foo in optionButtons {
            if foo.wasChosen {
                userSelectedWeight += foo.tag
            }
        }
        return userSelectedWeight
    }
    
    
}

extension QuizView {
    convenience init(quiz: Courses.Study20.Quiz) {
        
        self.init()
        
        if quiz.type == "0" {
            self.hasMultipleChoices = false
        } else {
            self.hasMultipleChoices = true
        }
        
        if hasMultipleChoices {
            optionButtons = Checkbox.initMultiChoicesBtns(with: quiz.options)
        } else {
            optionButtons = Checkbox.initOnlyChoiceBtns(with: quiz.options)
        }
        
        quizDescLabel = {
            let foo = UILabel(text: quiz.content, fontSize: 20)
            foo.numberOfLines = 0
            return foo
        }()
        
        self.originalAnswerWeight = (quiz.answer as? Int)!
        
        self.addSubview(quizDescLabel)
        quizDescLabel.snp_makeConstraints {
            make in
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(20)
        }
        
        self.addSubview(optionButtons[0])
        optionButtons[0].snp_makeConstraints {
            make in
            make.top.equalTo(quizDescLabel.snp_bottom).offset(16)
            make.left.equalTo(quizDescLabel)
            make.right.equalTo(quizDescLabel)
        }
        
        for i in 1..<optionButtons.count {
            self.addSubview(optionButtons[i])
            optionButtons[i].snp_makeConstraints {
                make in
                make.top.equalTo(optionButtons[i-1].snp_bottom).offset(4)
                make.left.equalTo(optionButtons[i-1])
                make.right.equalTo(optionButtons[i-1])
            }
        }
        
        
    }
    
    
}
