//
//  GPACalculationModel.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/5.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "GPACalculationModel.h"

@implementation GPACalculationModel

+ (void)getGPACaluculationResultFromArray:(NSArray *)calculatorArray andCalculationRule:(gpaCalcRule)rule Success:(void (^)(float, NSString *))success {
    
    NSMutableArray *creditInCalc = [[NSMutableArray alloc]initWithObjects: nil];
    NSMutableArray *scoreInCalc = [[NSMutableArray alloc]initWithObjects: nil];
    for (int i = 0; i < [calculatorArray count]; i++)
    {
        NSDictionary *tmp = [calculatorArray objectAtIndex:i];
        if ([[tmp objectForKey:@"selected"] isEqualToString:@"YES"] && [[tmp objectForKey:@"score"]floatValue] <= 100)
        {
            NSNumber *credit = [NSNumber numberWithFloat:[[tmp objectForKey:@"credit"] floatValue]];
            [creditInCalc addObject:credit];
            if ([tmp objectForKey:@"score"] == [NSNull null])
            {
                [scoreInCalc addObject:@0];
            }
            else
            {
                NSNumber *score = [NSNumber numberWithFloat:[[tmp objectForKey:@"score"] floatValue]];
                [scoreInCalc addObject:score];
            }
        }
    }
    
    float sumScorexCredit = 0;
    float sumCredit = 0;
    float gpa;
    NSString *ruleStr;
    
    switch (rule) {
        case gpaCalcRuleJasso: {
            for (int j = 0; j < [scoreInCalc count]; j++) {
                float score = [[scoreInCalc objectAtIndex:j]floatValue];
                float credit = [[creditInCalc objectAtIndex:j]floatValue];
                if (score >= 80 && score <= 100)
                    score = 3;
                else if (score >= 70)
                    score = 2;
                else if (score >= 60)
                    score = 1;
                else
                    score = 0;
                sumCredit = sumCredit + credit;
                sumScorexCredit = sumScorexCredit + score * credit;
            }
            gpa = sumScorexCredit / sumCredit;
            ruleStr = @"JASSO";
            break;
        }
            
        case gpaCalcRuleStandard: {
            for (int j = 0; j < [scoreInCalc count]; j++) {
                float score = [[scoreInCalc objectAtIndex:j]floatValue];
                float credit = [[creditInCalc objectAtIndex:j]floatValue];
                
                sumCredit = sumCredit + credit;
                sumScorexCredit = sumScorexCredit + score * credit;
            }
            gpa = sumScorexCredit*4/(sumCredit*100);
            ruleStr = @"标准制";
            break;
        }
            
        case gpaCalcRuleFourPt: {
            for (int j = 0; j < [scoreInCalc count]; j++) {
                float score = [[scoreInCalc objectAtIndex:j]floatValue];
                float credit = [[creditInCalc objectAtIndex:j]floatValue];
                if (score >= 90 && score <= 100)
                    score = 4;
                else if (score >=80)
                    score = 3;
                else if (score >= 70)
                    score = 2;
                else if (score >= 60)
                    score = 1;
                else
                    score = 0;
                sumCredit = sumCredit + credit;
                sumScorexCredit = sumScorexCredit + score * credit;
            }
            gpa = sumScorexCredit / sumCredit;
            ruleStr = @"四分制";
            break;
        }
            
        case gpaCalcRuleImprovedFourPt: {
            for (int j = 0; j < [scoreInCalc count]; j++) {
                float score = [[scoreInCalc objectAtIndex:j]floatValue];
                float credit = [[creditInCalc objectAtIndex:j]floatValue];
                if (score >= 85 && score <= 100)
                    score = 4;
                else if (score >=70)
                    score = 3;
                else if (score >= 60)
                    score = 2;
                else
                    score = 0;
                sumCredit = sumCredit + credit;
                sumScorexCredit = sumScorexCredit + score * credit;
            }
            gpa = sumScorexCredit / sumCredit;
            ruleStr = @"改进四分制";
            break;
        }
            
        case gpaCalcRuleCanada: {
            for (int j = 0; j < [scoreInCalc count]; j++)
            {
                float score = [[scoreInCalc objectAtIndex:j]floatValue];
                float credit = [[creditInCalc objectAtIndex:j]floatValue];
                if (score >= 90 && score <= 100)
                    score = 4.3;
                else if (score >=85)
                    score = 4;
                else if (score >= 80)
                    score = 3.7;
                else if (score >= 75)
                    score = 3.3;
                else if (score >=70)
                    score = 3;
                else if (score >= 65)
                    score = 2.7;
                else if (score >= 60)
                    score = 2.3;
                else
                    score = 0;
                sumCredit = sumCredit + credit;
                sumScorexCredit = sumScorexCredit + score * credit;
            }
            gpa = sumScorexCredit / sumCredit;
            ruleStr = @"加拿大4.3分制";
            break;
        }
        default:
            break;
    }
    
    success(gpa, ruleStr);
}

@end
