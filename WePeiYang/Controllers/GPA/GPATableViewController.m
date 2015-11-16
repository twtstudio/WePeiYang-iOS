//
//  GPATableViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/8.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "GPATableViewController.h"
#import "Chameleon.h"
#import "JZNavigationExtension.h"
#import "PNChart.h"
#import "MJExtension.h"
#import "twtSDK.h"
#import "GPAData.h"
#import "GPAClassData.h"
#import "GPAStat.h"
#import "GPATableViewCell.h"

@interface GPATableViewController ()<UIScrollViewAccessibilityDelegate>

@end

@implementation GPATableViewController {
    NSArray *dataArr;
    NSMutableArray *chartDataArr;
    NSInteger currentTerm;
    GPAStat *stat;
    
    BOOL graphIsTouched;
    NSInteger lastSelected;
}

@synthesize headerView;
@synthesize chartView;
@synthesize gpaLabel;
@synthesize scoreLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBarBackgroundAlpha = 0.0;
    self.clearsSelectionOnViewWillAppear = YES;
    headerView.backgroundColor = [UIColor flatPinkColorDark];
    dataArr = [[NSArray alloc] init];
    chartDataArr = [[NSMutableArray alloc] init];
    stat = [[GPAStat alloc] init];
    currentTerm = 0;
    graphIsTouched = NO;
    lastSelected = 0;
    
    [headerView addSubview:({
        CGFloat biggerValue = (self.view.frame.size.height > self.view.frame.size.width) ? self.view.frame.size.height : self.view.frame.size.width;
        UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, -biggerValue, biggerValue, biggerValue)];
        barBgView.backgroundColor = [UIColor flatPinkColorDark];
        barBgView;
    })];
    
    chartView.dataSource = self;
    chartView.delegate = self;
    chartView.state = JBChartViewStateCollapsed;
    
    gpaLabel.text = @"";
    scoreLabel.text = @"";
    
    [self getGPAData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - Private methods

- (void)getGPAData {
    [twtSDK getGpaWithTjuUsername:@"3012209017" password:@"tjuiai429r" success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject[@"error_code"] isEqual: @-1]) {
            dataArr = [GPAData mj_objectArrayWithKeyValuesArray:(responseObject[@"data"])[@"data"]];
            stat = [GPAStat mj_objectWithKeyValues:(responseObject[@"data"])[@"stat"]];
            [self updateView];
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    } userCanceledCaptcha:^() {
        
    }];
}

- (void)selectPointForIndex:(NSInteger)index withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    currentTerm = index;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:rowAnimation];
}

- (void)updateView {
    gpaLabel.text = stat.gpa;
    scoreLabel.text = stat.score;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    for (GPAData *data in dataArr) {
        [chartDataArr addObject:[NSNumber numberWithDouble:[data.score doubleValue]]];
    }
    [chartView reloadData];
    [chartView setState:JBChartViewStateExpanded animated:YES];
}

#pragma mark - JBChartView data source

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return chartDataArr.count;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return [chartDataArr[horizontalIndex] floatValue];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex {
    return YES;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [UIColor colorWithWhite:1.0 alpha:0.4]; // color of line in chart
}

//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return [UIColor colorWithWhite:1.0 alpha:0.5]; // color of area under line in chart
//}

//- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex {
//    return ...; // width of line in chart
//}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [UIColor whiteColor]; // color of selection view
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView {
    return 18.0; // width of selection view
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [UIColor colorWithWhite:1.0 alpha:0.7]; // color of selected line
}

//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionFillColorForLineAtLineIndex:(NSUInteger)lineIndex {
//    return ...; // color of area under selected line
//}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return 6.0;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    if (horizontalIndex == currentTerm) {
        return [UIColor whiteColor];
    } else {
        return [UIColor colorWithWhite:1.0 alpha:0.4];
    }
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex {
    return [UIColor whiteColor];
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex {
    return JBLineChartViewLineStyleSolid;
}

#pragma mark - JBChartView delegate

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint {
    // Update view
    self.tableView.scrollEnabled = NO;
    // 不该每次执行都更新，但是第一次要更新
    GPAData *tmp = dataArr[horizontalIndex];
    if (graphIsTouched == NO) {
        //NSLog(@"terms update");
        gpaLabel.text = tmp.gpa;
        scoreLabel.text = tmp.score;
        graphIsTouched = YES;
    }
    
    if (horizontalIndex != lastSelected) {
        if (horizontalIndex > lastSelected) {
            [self selectPointForIndex:horizontalIndex withRowAnimation:UITableViewRowAnimationLeft];
        } else {
            [self selectPointForIndex:horizontalIndex withRowAnimation:UITableViewRowAnimationRight];
        }
        gpaLabel.text = tmp.gpa;
        scoreLabel.text = tmp.score;
        lastSelected = horizontalIndex;
    }
    self.title = ((GPAData *)dataArr[horizontalIndex]).name;
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView {
    // Update view
    self.tableView.scrollEnabled = YES;
    graphIsTouched = NO;
    gpaLabel.text = stat.gpa;
    scoreLabel.text = stat.score;
    self.title = @"成绩";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataArr.count == 0) {
        return 0;
    } else {
        GPAData *gpa = (GPAData *)dataArr[currentTerm];
        return gpa.data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPATableViewCell *cell = (GPATableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"simpleIdentifier"];
    GPAData *gpa = (GPAData *)dataArr[currentTerm];
    GPAClassData *tmp = gpa.data[indexPath.row];
    cell.nameLabel.text = tmp.name;
    cell.creditLabel.text = tmp.credit;
    cell.scoreLabel.text = tmp.score;
    cell.dotView.hidden = YES;
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > -60 && scrollView.contentOffset.y <= -10) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBarBackgroundAlpha = (scrollView.contentOffset.y + 60) * 0.02;
    } else if (scrollView.contentOffset.y <= -60) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationController.navigationBarBackgroundAlpha = 0.0;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBarBackgroundAlpha = 1.0;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    
}

@end
