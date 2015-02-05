//
//  GPACalculationModel.h
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/5.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    gpaCalcRuleJasso,
    gpaCalcRuleStandard,
    gpaCalcRuleFourPt,
    gpaCalcRuleImprovedFourPt,
    gpaCalcRuleCanada,
} gpaCalcRule;

@interface GPACalculationModel : NSObject

+ (void)getGPACaluculationResultFromArray:(NSArray *)calculatorArray andCalculationRule:(gpaCalcRule)rule Success:(void(^)(float gpa, NSString *ruleStr))success;

@end
