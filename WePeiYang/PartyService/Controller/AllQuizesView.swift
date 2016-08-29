//
//  AllQuizesView.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/29.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation


class AllQuizesView: UIView {
    
    var QuizeList: Array<Quiz>
    let Labels = [UILabel]()
    
    convenience init(Quizes: [Quiz]) {
        self.init()
        
        self.QuizList = QuizList
        
        
        
    }
    
    func initUI() {
        
        for i in 0..<QuizeList.count {
            Labels[i] =
        }
        
    }
    
    
}