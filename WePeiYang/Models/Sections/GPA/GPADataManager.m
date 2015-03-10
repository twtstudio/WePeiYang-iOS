//
//  GPADataManager.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/1.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "GPADataManager.h"
#import "twtAPIs.h"
#import "JSONKit.h"

@implementation GPADataManager

+ (void)getDataWithParameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSInteger))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs GPAInquire] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([operation.responseString objectFromJSONString]);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode);
    }];
}

+ (void)autoEvaluateWithParameters:(NSDictionary *)parameters success:(void (^)())success failure:(void (^)(NSInteger))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[twtAPIs GPAAutoEvaluate] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation.response.statusCode);
    }];
}

+ (void)processGPAData:(NSDictionary *)gpaDic finishBlock:(void (^)(NSMutableArray *, float, float, NSArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *))block {
    NSMutableArray *gpaData = [[NSMutableArray alloc]initWithObjects: nil];
    
    NSArray *termsDataArr = [gpaDic objectForKey:@"terms"];
    
    for (NSDictionary *termDic in termsDataArr)
    {
        for (NSDictionary *temp in termDic)
        {
            [gpaData addObject:temp];
        }
    }
    
    float gpa = [[[gpaDic objectForKey:@"data"] objectForKey:@"gpa"] floatValue];
    float score = [[[gpaDic objectForKey:@"data"] objectForKey:@"score"] floatValue];
    
    NSMutableArray *terms = [[NSMutableArray alloc]initWithObjects: nil];
    
    for (int i = 0; i <= [gpaData count]-1; i++)
    {
        if (i == 0)
        {
            [terms addObject:[[gpaData objectAtIndex:i] objectForKey:@"term"]];
        }
        else
        {
            if (![[[gpaData objectAtIndex:i-1] objectForKey:@"term"] isEqualToString:[[gpaData objectAtIndex:i] objectForKey:@"term"]])
            {
                [terms addObject:[[gpaData objectAtIndex:i] objectForKey:@"term"]];
            }
        }
    }
    
    NSMutableArray *everyScoreArr = [[NSMutableArray alloc]initWithObjects: nil];
    NSMutableArray *everyGpaArr = [[NSMutableArray alloc]initWithObjects: nil];
    NSArray *everyDataArr = [[gpaDic objectForKey:@"data"]objectForKey:@"every"];
    for (NSDictionary *tmp in everyDataArr)
    {
        [everyScoreArr addObject:[tmp objectForKey:@"score"]];
        [everyGpaArr addObject:[tmp objectForKey:@"gpa"]];
    }
    
    NSArray *termsInGraph = [[NSArray alloc]init];
    
    if ([terms count] == 0) termsInGraph = @[@""];
    else if ([terms count] == 1) termsInGraph = @[@"大一上"];
    else if ([terms count] == 2) termsInGraph = @[@"大一上",@"大一下"];
    else if ([terms count] == 3) termsInGraph = @[@"大一上",@"大一下",@"大二上"];
    else if ([terms count] == 4) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下"];
    else if ([terms count] == 5) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下",@"大三上"];
    else if ([terms count] == 6) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下",@"大三上",@"大三下"];
    else if ([terms count] == 7) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下",@"大三上",@"大三下",@"大四上"];
    else if ([terms count] == 8) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下",@"大三上",@"大三下",@"大四上",@"大四下"];
    else if ([terms count] == 9) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下",@"大三上",@"大三下",@"大四上",@"大四下",@"大五上"];
    else if ([terms count] == 10) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下",@"大三上",@"大三下",@"大四上",@"大四下",@"大五上",@"大五下"];
    else if ([terms count] == 11) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下",@"大三上",@"大三下",@"大四上",@"大四下",@"大五上",@"大五下",@"大六上"];
    else if ([terms count] == 12) termsInGraph = @[@"大一上",@"大一下",@"大二上",@"大二下",@"大三上",@"大三下",@"大四上",@"大四下",@"大五上",@"大五下",@"大六上",@"大六下"];
    else termsInGraph = terms;
    
    NSMutableArray *newAddedSubjects = [self compareWithPreviousResultByGpaData:gpaData andTerms:terms];
    
    // block 里的参数分别是：成绩数据，当前 GPA，当前加权，显示学期数组（大一上，大一下），学期数组（13141，13142），每学期加权数组，每学期 GPA 数组，新出分科目数组
    
    block(gpaData, gpa, score, termsInGraph, terms, everyScoreArr, everyGpaArr, newAddedSubjects);
}

// 和之前查询的成绩进行比较，如果新出科目则标注小点，并保存最新查询的成绩
// 其实这里算法不科学，包含了赘余的二次遍历。不过考虑到第二次遍历的数量在5次以内，对性能的影响可以忽略不计~

+ (NSMutableArray *)compareWithPreviousResultByGpaData:(NSMutableArray *)gpaData andTerms:(NSMutableArray *)terms {
    
    NSMutableArray *newAddedSubjects = [[NSMutableArray alloc]initWithObjects: nil];
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"gpaResult"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        NSMutableDictionary *previousGPAResult = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < [terms count]; i++)
        {
            NSMutableDictionary *termDic = [[NSMutableDictionary alloc]init];
            NSString *thisTerm = [terms objectAtIndex:i];
            for (int j = 0; j < [gpaData count]; j++)
            {
                if ([[[gpaData objectAtIndex:j] objectForKey:@"term"] isEqualToString:thisTerm])
                {
                    [termDic setObject:[gpaData objectAtIndex:j] forKey:[[gpaData objectAtIndex:j] objectForKey:@"name"]];
                }
            }
            [previousGPAResult setObject:termDic forKey:thisTerm];
        }
        [previousGPAResult writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSDictionary *previousGPAResult = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
        [fileManager removeItemAtPath:plistPath error:nil];
        
        newAddedSubjects = [[NSMutableArray alloc]initWithObjects:nil, nil];
        
        NSMutableDictionary *thisTimeGPAResult = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < [terms count]; i++)
        {
            NSMutableArray *thisTermSubjects = [[NSMutableArray alloc]initWithObjects:nil, nil];
            
            NSMutableDictionary *termDic = [[NSMutableDictionary alloc]init];
            NSString *thisTerm = [terms objectAtIndex:i];
            NSDictionary *resultOfThisTermLastChecked = [previousGPAResult objectForKey:thisTerm];
            NSArray *lastSubjects = [resultOfThisTermLastChecked allKeys];
            
            for (int j = 0; j < [gpaData count]; j++)
            {
                if ([[[gpaData objectAtIndex:j] objectForKey:@"term"] isEqualToString:thisTerm])
                {
                    [termDic setObject:[gpaData objectAtIndex:j] forKey:[[gpaData objectAtIndex:j] objectForKey:@"name"]];
                    [thisTermSubjects addObject:[[gpaData objectAtIndex:j] objectForKey:@"name"]];
                }
            }
            [thisTimeGPAResult setObject:termDic forKey:thisTerm];
            
            for (int k = 0; k < [thisTermSubjects count]; k++)
            {
                BOOL subjectInLastChecked = NO;
                for (int l = 0; l < [lastSubjects count]; l++)
                {
                    if ([[thisTermSubjects objectAtIndex:k] isEqualToString:[lastSubjects objectAtIndex:l]])
                    {
                        subjectInLastChecked = YES;
                        break;
                    }
                }
                if(!subjectInLastChecked)
                {
                    [newAddedSubjects addObject:[thisTermSubjects objectAtIndex:k]];
                }
            }
        }
        [thisTimeGPAResult writeToFile:plistPath atomically:YES];
    }
    
    return newAddedSubjects;
}


@end
