//
//  GPAViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-10.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "GPAViewController.h"
#import "GPALoginViewController.h"
#import "data.h"
#import "GPACalculatorViewController.h"
#import "GPATableCell.h"
#import "gpaHeaderView.h"
#import "UIButton+Bootstrap.h"
#import "twtLoginViewController.h"
#import "MsgDisplay.h"
#import "GPADataManager.h"
#import "WePeiYang-Swift.h"
#import "wpyDeviceStatus.h"
#import "wpyCacheManager.h"

@interface GPAViewController ()

@end

@implementation GPAViewController

{
    NSString *username;
    NSString *password;
    
    NSMutableArray *gpaData;
    
    NSMutableArray *newAddedSubjects;
    
    float gpa;
    float score;
    NSMutableArray *everyScoreArr;
    NSMutableArray *everyGpaArr;
    
    NSMutableArray *dataInTable;
    NSArray *termsInGraph;
    
    NSMutableArray *terms;
    
    UIAlertView *errorAlert;
    
    CGRect frame; //tableHeaderView.frame
    
    UIColor *gpaTintColor;
    
    gpaHeaderView *gpaHeader;
    
    //Instances
    NSInteger gpaHeaderViewHeight;
    
    NSInteger lastSelected; // 图表里上一个选择的节点的index
    BOOL graphIsTouched; // 图表当前被摸着
}

@synthesize resultTableView;
@synthesize moreBtn;
@synthesize backBtn;
@synthesize loginBtn;
@synthesize noLoginLabel;
@synthesize noLoginImg;

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
    
    //INSTANCES
    gpaHeaderViewHeight = 150;

    self.title = @"GPA查询";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    graphIsTouched = NO;
    
    gpaTintColor = [UIColor colorWithRed:255/255.0f green:85/255.0f blue:95/255.0f alpha:1.0f];
    [[UIButton appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    gpaData = [[NSMutableArray alloc]initWithObjects: nil];
    dataInTable = [[NSMutableArray alloc]initWithObjects: nil];
    
    newAddedSubjects = [[NSMutableArray alloc]initWithObjects:nil, nil];
    
    [loginBtn primaryStyle];
    
    gpaHeader = [[gpaHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, gpaHeaderViewHeight)];
    
    [dataInTable removeAllObjects];
    [self checkLoginStatus];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[data shareInstance].gpaLoginStatus isEqualToString:@"Changed"])
    {
        self.loginBtn.userInteractionEnabled = NO;
        [self checkLoginStatus];
    }
}

- (void)checkLoginStatus {
    [gpaData removeAllObjects];
    [dataInTable removeAllObjects];
    [everyScoreArr removeAllObjects];
    [everyGpaArr removeAllObjects];
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath]) {
        [self setLoginView];
    } else {
        NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                     @"token":[data shareInstance].userToken,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        
        [MsgDisplay showLoading];
        
        [GPADataManager getDataWithParameters:parameters success:^(id responseObject) {
            //Successful
            [self setNormalView];
            [self processGpaData:responseObject];
            [MsgDisplay dismiss];
        } failure:^(NSInteger statusCode, NSString *errStr) {
            [MsgDisplay dismiss];
            [self processErrorWithStatusCode:statusCode andErrorString:errStr];
        }];
    }
}

// Set Views

- (void)setNormalView {
    loginBtn.userInteractionEnabled = YES;
    [moreBtn setHidden:NO];
    [resultTableView setHidden:NO];
    [loginBtn setHidden:YES];
    [noLoginLabel setHidden:YES];
    [noLoginImg setHidden:YES];
    [data shareInstance].gpaLoginStatus = @"";
    backBtn.tintColor = [UIColor whiteColor];
}

- (void)setLoginView {
    [moreBtn setHidden:YES];
    [resultTableView setHidden:YES];
    [noLoginLabel setHidden:NO];
    [loginBtn setHidden:NO];
    [noLoginImg setHidden:NO];
    [noLoginLabel setText:@"您尚未登录天外天账号"];
    [loginBtn setTitle:@"点击这里登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    backBtn.tintColor = gpaTintColor;
}

- (void)setBindView {
    [moreBtn setHidden:YES];
    [resultTableView setHidden:YES];
    [noLoginLabel setHidden:NO];
    [loginBtn setHidden:NO];
    [noLoginImg setHidden:NO];
    [noLoginLabel setText:@"您尚未绑定办公网账号"];
    loginBtn.userInteractionEnabled = YES;
    [loginBtn setTitle:@"点击这里绑定" forState:UIControlStateNormal];
    [loginBtn removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(bindTju) forControlEvents:UIControlEventTouchUpInside];
}

// For Log In

- (void)login
{
    twtLoginViewController *login = [[twtLoginViewController alloc]initWithNibName:nil bundle:nil];
    [login setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:login animated:YES completion:^{
        login.loginType = twtLoginTypeGPA;
    }];
}

- (void)processErrorWithStatusCode:(NSInteger)statusCode andErrorString:(NSString *)errStr {
    backBtn.tintColor = gpaTintColor;
    switch (statusCode) {
        case 401:
            [MsgDisplay showErrorMsg:@"验证出错\n请重新登录"];
            [self setLoginView];
            [wpyCacheManager removeCacheDataForKey:@"gpaCache"];
            break;
            
        case 403:
            [self setBindView];
            [wpyCacheManager removeCacheDataForKey:@"gpaCache"];
            break;
            
        default:
            [MsgDisplay showErrorMsg:errStr];
            if ([gpaData count] == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
    }
}

- (void)bindTju {
    GPALoginViewController *gpaLogin = [[GPALoginViewController alloc]initWithNibName:nil bundle:nil];
    [gpaLogin setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:gpaLogin animated:YES completion:nil];
}

// For Action Sheet
    
- (IBAction)openActionSheet:(id)sender {
    wpyActionSheet *actionSheet = [[wpyActionSheet alloc]initWithTitle:@"更多操作"];
    
    [actionSheet addButtonWithTitle:@"一键评价" image:nil type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self oneKeyToEvaluate];
    }];
    
    [actionSheet addButtonWithTitle:@"分享 GPA" image:nil type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self shareGPA];
    }];
    
    [actionSheet addButtonWithTitle:@"GPA 计算器" image:nil type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self pushGPACalculator];
    }];
    
    [actionSheet show];
}

// For Data Processing

- (void)processGpaData:(NSDictionary *)gpaDic {
    
    [GPADataManager processGPAData:gpaDic finishBlock:^(NSMutableArray *_gpaData, float _gpa, float _score, NSArray *_termsInGraph, NSMutableArray *_terms, NSMutableArray *_everyScoreArr, NSMutableArray *_everyGpaArr, NSMutableArray *_newAddedSubjects) {
        gpaData = _gpaData;
        gpa = _gpa;
        score = _score;
        termsInGraph = _termsInGraph;
        terms = _terms;
        everyScoreArr = _everyScoreArr;
        everyGpaArr = _everyGpaArr;
        newAddedSubjects = _newAddedSubjects;
    }];
    
    gpaHeader.gpaLabel.text = [NSString stringWithFormat:@"%.2f", gpa];
    gpaHeader.scoreLabel.text = [NSString stringWithFormat:@"%.2f", score];
    
    gpaHeader.termLabel.text = @"";
    
    //初始化图表
    
    JBLineChartView *lineChart = [[JBLineChartView alloc]initWithFrame:CGRectMake(20, gpaHeaderViewHeight+20, [UIScreen mainScreen].bounds.size.width - 40, 130)];
    lineChart.dataSource = self;
    lineChart.delegate = self;
    lineChart.backgroundColor = [UIColor whiteColor];
    lineChart.state = JBChartViewStateCollapsed; // 先收起ChartView
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, gpaHeaderViewHeight+164)];
    [headerView addSubview:gpaHeader];
    [headerView addSubview:lineChart];
    headerView.backgroundColor = [UIColor whiteColor];
    
    resultTableView.tableHeaderView = headerView;
    [self selectPointForIndex:[terms count]-1 withRowAnimation:UITableViewRowAnimationAutomatic];
    lastSelected = [terms count] - 1;
    
    [lineChart reloadData];
    [lineChart setState:JBChartViewStateExpanded animated:YES]; // 之后动画展开
}

- (void)oneKeyToEvaluate {
    NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                 @"token":[data shareInstance].userToken,
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    [GPADataManager autoEvaluateWithParameters:parameters success:^(){
        [MsgDisplay showSuccessMsg:@"一键评价成功！"];
        [self checkLoginStatus];
    } failure:^(NSInteger statusCode, NSString *errStr) {
        switch (statusCode) {
            case 403:
                [MsgDisplay showErrorMsg:@"没有可以评价的科目。"];
                break;
                
            default:
                [MsgDisplay showErrorMsg:[NSString stringWithFormat:@"无法一键评价 T^T\n%@", errStr]];
                break;
        }
    }];
    
}

// UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"SimpleTableCell";
    GPATableCell *cell = (GPATableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GPATableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    NSDictionary *temp = [dataInTable objectAtIndex:row];
    cell.nameCellLabel.text = [temp objectForKey:@"name"];
    cell.addedSubjectMarkImgView.hidden = YES;
    if ([newAddedSubjects count] != 0)
    {
        for (int i = 0; i < [newAddedSubjects count]; i++)
        {
            if ([[[dataInTable objectAtIndex:row] objectForKey:@"name"] isEqualToString:[newAddedSubjects objectAtIndex:i]])
            {
                cell.addedSubjectMarkImgView.hidden = NO;
                break;
            }
        }
    }
    if ([[temp objectForKey:@"score"] floatValue] != -1)
    {
        cell.scoreCellLabel.text = [NSString stringWithFormat:@"%.0f",[[temp objectForKey:@"score"] floatValue]];
    }
    else
    {
        cell.scoreCellLabel.text = @"未评价";
    }
    cell.creditCellLabel.text = [temp objectForKey:@"credit"];
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == errorAlert)
    {
        GPALoginViewController *login = [[GPALoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// For Term Selection

- (void) selectPointForIndex:(NSInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    [dataInTable removeAllObjects];
    
    NSString *termSelectedStr = [terms objectAtIndex:index];
    
    for (int i = 0; i < [gpaData count]; i++)
    {
        if ([[[gpaData objectAtIndex:i] objectForKey:@"term"] isEqualToString:termSelectedStr])
        {
            [dataInTable addObject:[gpaData objectAtIndex:i]];
        }
    }
    
    [resultTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:rowAnimation];
}

- (IBAction)backToHomeBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareGPA {
    
    UIImage *screenShot = [wpyDeviceStatus captureScreen];
    NSString *bannerPath = [[NSBundle mainBundle] pathForResource:@"Banner@2x" ofType:@".png"];
    UIImage *banner = [UIImage imageWithContentsOfFile:bannerPath];
    CGSize screenShotSize = [screenShot size];
    CGSize bannerSize = [banner size];
    CGSize finalSize = CGSizeMake(screenShotSize.width, screenShotSize.height+bannerSize.height);
    UIGraphicsBeginImageContext(finalSize);
    [screenShot drawInRect:CGRectMake(0, 0, screenShotSize.width, screenShotSize.height)];
    [banner drawInRect:CGRectMake(0, screenShotSize.height, bannerSize.width, bannerSize.height)];
    UIImage *shareImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSArray *activityItems = @[shareImg];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (void)pushGPACalculator
{
    GPACalculatorViewController *gpaCalculator = [[GPACalculatorViewController alloc]initWithNibName:nil bundle:nil];
    gpaCalculator.gpaData = gpaData;
    [self.navigationController pushViewController:gpaCalculator animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offsetY = [scrollView contentOffset].y;
    //NSLog([NSString stringWithFormat:@"%f",offsetY]);
    gpaHeader.alpha = 1-offsetY/150;
    backBtn.tintColor = [UIColor colorWithRed:255/255.0f green:(-2*offsetY+255)/255.0f blue:(-1.8824*offsetY+255)/255.0f alpha:1.0f];
    moreBtn.tintColor = [UIColor colorWithRed:255/255.0f green:(-2*offsetY+255)/255.0f blue:(-1.8824*offsetY+255)/255.0f alpha:1.0f];
    
    if (offsetY < 0) {
        resultTableView.backgroundColor = gpaTintColor;
    } else {
        resultTableView.backgroundColor = [UIColor whiteColor];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// JBLineChartViewDelegate

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return 1; // number of lines in chart
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return terms.count; // number of values for a line
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return [everyScoreArr[horizontalIndex] floatValue];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [UIColor colorWithRed:255/255.0f green:94/255.0f blue:115/255.0f alpha:1.0f]; // color of line in chart
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex {
    return 4.0; // width of line in chart
}

/*
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return 5.0; // width of line dot in chart
}*/

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex {
    return JBLineChartViewLineStyleSolid; // style of line in chart
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [UIColor colorWithRed:255/255.0f green:94/255.0f blue:115/255.0f alpha:1.0f]; // color of selection view
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView {
    return 24.0; // width of selection view
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [UIColor colorWithRed:255/255.0f green:201/255.0f blue:201/255.0f alpha:1.0f]; // color of selected line
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex {
    return YES;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    if (horizontalIndex == lastSelected) {
        return [UIColor colorWithRed:0/255.0f green:144/255.0f blue:255/255.0f alpha:1.0f];
    } else {
        return [UIColor colorWithRed:255/255.0f green:94/255.0f blue:115/255.0f alpha:1.0f];
    }
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return [UIColor colorWithRed:255/255.0f green:201/255.0f blue:201/255.0f alpha:1.0f];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex {
    return NO; // 是否平滑图表
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint {
    // Update view
    self.resultTableView.scrollEnabled = NO;
    
    // 不该每次执行都更新，但是第一次要更新
    if (graphIsTouched == NO) {
        //NSLog(@"terms update");
        dispatch_async(dispatch_get_main_queue(), ^{
            gpaHeader.gpaLabel.text = [NSString stringWithFormat:@"%.2f", [everyGpaArr[horizontalIndex] floatValue]];
            gpaHeader.scoreLabel.text = [NSString stringWithFormat:@"%.2f", [everyScoreArr[horizontalIndex] floatValue]];
            gpaHeader.termLabel.text = [termsInGraph objectAtIndex:horizontalIndex];
        });
        
        graphIsTouched = YES;
    }
    
    if (horizontalIndex != lastSelected) {
        
        if (horizontalIndex > lastSelected) {
            [self selectPointForIndex:horizontalIndex withRowAnimation:UITableViewRowAnimationLeft];
        } else {
            [self selectPointForIndex:horizontalIndex withRowAnimation:UITableViewRowAnimationRight];
        }
        //NSLog(@"terms update");
        dispatch_async(dispatch_get_main_queue(), ^{
            gpaHeader.gpaLabel.text = [NSString stringWithFormat:@"%.2f", [everyGpaArr[horizontalIndex] floatValue]];
            gpaHeader.scoreLabel.text = [NSString stringWithFormat:@"%.2f", [everyScoreArr[horizontalIndex] floatValue]];
            gpaHeader.termLabel.text = [termsInGraph objectAtIndex:horizontalIndex];
        });
        
        lastSelected = horizontalIndex;
    }
    
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView {
    // Update view
    self.resultTableView.scrollEnabled = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        gpaHeader.gpaLabel.text = [NSString stringWithFormat:@"%.2f", gpa];
        gpaHeader.scoreLabel.text = [NSString stringWithFormat:@"%.2f", score];
        gpaHeader.termLabel.text = @"";
    });
    graphIsTouched = NO;
}

@end
