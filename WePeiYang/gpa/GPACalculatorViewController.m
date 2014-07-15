//
//  GPACalculatorViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-1-28.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "GPACalculatorViewController.h"
#import "UIButton+Bootstrap.h"

@interface GPACalculatorViewController ()

@end

@implementation GPACalculatorViewController

{
    /*
    NSMutableArray *namesArray;
    NSMutableArray *termsArray;
    NSMutableArray *scoresArray;
    NSMutableArray *creditsArray;
     */
    NSMutableArray *calculatorArray;
}

@synthesize tableView;
//@synthesize calculateBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //[calculateBtn primaryStyle];
    
    UIBarButtonItem *calcJasso = [[UIBarButtonItem alloc]initWithTitle:@"JASSO" style:UIBarButtonItemStylePlain target:self action:@selector(calcGpaWithJasso)];
    UIBarButtonItem *calcStandard = [[UIBarButtonItem alloc]initWithTitle:@"标准" style:UIBarButtonItemStylePlain target:self action:@selector(calcGpaWithStandard)];
    UIBarButtonItem *calcFourPt = [[UIBarButtonItem alloc]initWithTitle:@"四分制" style:UIBarButtonItemStylePlain target:self action:@selector(calcGpaWithFourPt)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *arr = @[calcJasso, flexItem, calcStandard, flexItem, calcFourPt];
    [self setToolbarItems:arr animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    //scoresArray = [[NSMutableArray alloc]initWithArray:[data shareInstance].scoresArray];
    //namesArray = [[NSMutableArray alloc]initWithArray:[data shareInstance].namesArray];
    //creditsArray = [[NSMutableArray alloc]initWithArray:[data shareInstance].creditsArray];
    //termsArray = [[NSMutableArray alloc]initWithArray:[data shareInstance].termsArray];
    
    NSArray *gpaData = [data shareInstance].gpaDataArray;
    
    calculatorArray = [[NSMutableArray alloc]initWithObjects: nil];
    for (int i = 0; i < [gpaData count]; i++)
    {
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        NSDictionary *gpaTmp = [gpaData objectAtIndex:i];
        [tmp setValue:[gpaTmp objectForKey:@"score"] forKey:@"score"];
        [tmp setValue:[gpaTmp objectForKey:@"name"] forKey:@"name"];
        [tmp setValue:[gpaTmp objectForKey:@"credit"] forKey:@"credit"];
        [tmp setValue:[gpaTmp objectForKey:@"term"] forKey:@"term"];
        //[tmp setValue:[scoresArray objectAtIndex:i] forKey:@"score"];
        //[tmp setValue:[namesArray objectAtIndex:i] forKey:@"name"];
        //[tmp setValue:[creditsArray objectAtIndex:i] forKey:@"credit"];
        //[tmp setValue:[termsArray objectAtIndex:i] forKey:@"term"];
        if ([[tmp objectForKey:@"score"] floatValue] <= 100)
        {
            [tmp setValue:@"YES" forKey:@"selected"];
        }
        else
        {
            [tmp setValue:@"NO" forKey:@"selected"];
        }
        [calculatorArray addObject:tmp];
        
        //用来去除过去重复的科目 这里有Bug
        for (NSDictionary *prevDic in calculatorArray)
        {
            if ([[prevDic objectForKey:@"name"] isEqualToString:[tmp objectForKey:@"name"]])
            {
                NSLog([prevDic objectForKey:@"name"]);
                float prevScore = [[prevDic objectForKey:@"score"] floatValue];
                float thisScore = [[tmp objectForKey:@"score"] floatValue];
                if (prevScore <= thisScore)
                {
                    [calculatorArray removeObject:prevDic];
                    break;
                }
                else
                {
                    [calculatorArray removeObject:tmp];
                    break;
                }
            }
        }
    }
}

- (void)calcGpaWithJasso
{
    [self calculateGPAwithCalcRule:gpaCalcRuleJasso];
}

- (void)calcGpaWithStandard
{
    [self calculateGPAwithCalcRule:gpaCalcRuleStandard];
}

- (void)calcGpaWithFourPt
{
    [self calculateGPAwithCalcRule:gpaCalcRuleFourPt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    NSString *sectionTerm = [[data shareInstance].term objectAtIndex:section];
    int i = 0;
    for (NSDictionary *tmp in calculatorArray)
    {
        if ([[tmp objectForKey:@"term"]isEqualToString:sectionTerm])
        {
            i++;
        }
    }
    return i;
     */
    return [calculatorArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    //NSUInteger section = [indexPath section];
    
    NSDictionary *tmp = [calculatorArray objectAtIndex:row];
    NSString *name = [tmp objectForKey:@"name"];
    NSString *credit = [tmp objectForKey:@"credit"];
    NSString *score = [tmp objectForKey:@"score"];
    NSString *selected = [tmp objectForKey:@"selected"];
    //NSString *term = [tmp objectForKey:@"term"];
    NSString *cellStr = [NSString stringWithFormat:@"%@, %@学分, %@",name,credit,score];
    cell.textLabel.text = cellStr;
    if ([selected  isEqual: @"YES"])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = [indexPath row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        NSMutableDictionary *tmp = [calculatorArray objectAtIndex:row];
        [tmp setValue:@"NO" forKey:@"selected"];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSMutableDictionary *tmp = [calculatorArray objectAtIndex:row];
        [tmp setValue:@"YES" forKey:@"selected"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)calculateGPAwithCalcRule:(gpaCalcRule)rule
{
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
    NSString *alertStr;
    
    switch (rule) {
        case gpaCalcRuleJasso:
        {
            for (int j = 0; j < [scoreInCalc count]; j++)
            {
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
            alertStr = [[NSString alloc]initWithFormat:@"您的GPA为%.3f\n（按照JASSO计算规则）",gpa];
            break;
        }
        case gpaCalcRuleStandard:
        {
            for (int j = 0; j < [scoreInCalc count]; j++)
            {
                float score = [[scoreInCalc objectAtIndex:j]floatValue];
                float credit = [[creditInCalc objectAtIndex:j]floatValue];
                
                sumCredit = sumCredit + credit;
                sumScorexCredit = sumScorexCredit + score * credit;
            }
            gpa = sumScorexCredit*4/(sumCredit*100);
            alertStr = [[NSString alloc]initWithFormat:@"您的GPA为%.3f\n（按照标准计算规则）",gpa];
            break;
        }
        case gpaCalcRuleFourPt:
        {
            for (int j = 0; j < [scoreInCalc count]; j++)
            {
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
            alertStr = [[NSString alloc]initWithFormat:@"您的GPA为%.3f\n（按照四分制计算规则）",gpa];
            break;
        }
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"GPA计算" message:alertStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择希望计入GPA的科目";
}

/*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[data shareInstance].term count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[data shareInstance].term objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
 */

@end
