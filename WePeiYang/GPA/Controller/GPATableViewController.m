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
#import "wpyCacheManager.h"
#import "MsgDisplay.h"
#import "GPAAnalysisTableViewController.h"
#import "twtSecretKeys.h"
#import "wpyCacheManager.h"
#import "BlocksKit.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import "wpyDeviceStatus.h"
#import "AccountManager.h"
#import "AFNetworking.h"
#import "WePeiYang-Swift.h"

@interface GPATableViewController ()<UIScrollViewAccessibilityDelegate>

@end

@implementation GPATableViewController {
    NSArray *dataArr;
    NSMutableArray *chartDataArr;
    NSInteger currentTerm;
    GPAStat *stat;
    
    BOOL graphIsTouched;
    NSInteger lastSelected;
    
    NSString *userName;
    NSString *userPasswd;
    
    BOOL isRequestingData;
}

@synthesize headerView;
@synthesize chartView;
@synthesize gpaLabel;
@synthesize scoreLabel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBarBackgroundAlpha = 0.0;
    self.clearsSelectionOnViewWillAppear = YES;
    headerView.backgroundColor = [UIColor flatPinkColorDark];
    
    dataArr = [[NSArray alloc] init];
    chartDataArr = [[NSMutableArray alloc] init];
    stat = [[GPAStat alloc] init];
    currentTerm = 0;
    graphIsTouched = NO;
    lastSelected = 0;
    isRequestingData = NO;
    
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
    
    [self refresh:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotificationReceived) name:@"PleaseRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotificationReceived) name:@"PleaseGetBack" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    float offSetY = self.tableView.contentOffset.y;
    [self adjustStyleWithScrollOffset:offSetY];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.tintColor = self.view.tintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    self.navigationController.navigationBarBackgroundAlpha = 1.0;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^(NSTimer *timer) {
        [self updateView];
    } repeats:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (void)refreshNotificationReceived {
    [self refresh:self];
}

- (void)backNotificationReceived {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getGPAData {
    if (!isRequestingData) {
        isRequestingData = YES;
        // 继承旧版本
        [self fetchGPAData];
//        [wpyCacheManager loadCacheDataWithKey:GPA_USER_NAME_CACHE andBlock:^(id cacheData) {
//            userName = cacheData[@"username"];
//            userPasswd = cacheData[@"password"];
//            [self fetchGPAData];
//        } failed:^{
//            isRequestingData = NO;
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入天大办公网的账号密码" message:@"由于部分原因，暂时无法校验您账号密码是否正确，请保证输入准确无误。\n如反复要求您输入验证码，可能是您输入错误，请进入［设置］注销后重新登录。" preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                textField.placeholder = @"请输入办公网账号";
//            }];
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                textField.placeholder = @"请输入办公网密码";
//                textField.secureTextEntry = YES;
//            }];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                NSDictionary *dic = @{@"username": alertController.textFields[0].text,
//                                      @"password": alertController.textFields[1].text};
//                [wpyCacheManager saveCacheData:dic withKey:GPA_USER_NAME_CACHE];
//                [self getGPAData];
//            }];
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
//            [alertController addAction:cancel];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//        }];
    }
}

- (void)fetchGPAData {
    dataArr = [[NSArray alloc] init];
    chartDataArr = [[NSMutableArray alloc] init];
    stat = [[GPAStat alloc] init];
    [MsgDisplay showLoading];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [wpyCacheManager loadCacheDataWithKey:GPA_CACHE andBlock:^(id cacheData) {
        dataArr = [GPAData mj_objectArrayWithKeyValuesArray:(cacheData[@"data"])[@"data"]];
        stat = [GPAStat mj_objectWithKeyValues:(cacheData[@"data"])[@"stat"]];
        [self updateView];
    } failed:nil];
    [twtSDK getGpaWithToken:[[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY] success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject[@"error_code"] isEqual: @-1]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [wpyCacheManager saveCacheData:responseObject withKey:GPA_CACHE];
            dataArr = [GPAData mj_objectArrayWithKeyValuesArray:(responseObject[@"data"])[@"data"]];
            stat = [GPAStat mj_objectWithKeyValues:(responseObject[@"data"])[@"stat"]];
            [self updateView];
            if ([wpyDeviceStatus getOSVersionFloat] >= 9.0) {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:ALLOW_SPOTLIGHT_KEY] == nil) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ALLOW_SPOTLIGHT_KEY];
                }
                if ([[NSUserDefaults standardUserDefaults] boolForKey:ALLOW_SPOTLIGHT_KEY] == YES) {
                    [self saveGPADataForCoreSpotlight];
                }
            }
        } else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        isRequestingData = NO;
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSError *jsonError;
        NSData *errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorResponse options:NSJSONReadingMutableContainers error:&jsonError];
        if (dic != nil) {
            if ([dic objectForKey:@"error_code"] != nil) {
                NSString *errorCode = [dic[@"error_code"] stringValue];
                if ([errorCode isEqualToString:@"20001"]) {
                    // 未绑定
                    [MsgDisplay showErrorMsg:dic[@"message"]];
                    BindTjuViewController *bindTju = [[BindTjuViewController alloc] initWithNibName:nil bundle:nil];
                    [self presentViewController:bindTju animated:YES completion:nil];
                } else if ([errorCode isEqualToString:@"20002"]) {
                    // TJU 验证失败
                    [MsgDisplay showErrorMsg:dic[@"message"]];
                    
                }
            } else {
                if ([dic objectForKey:@"message"] != nil) {
                    [MsgDisplay showErrorMsg:dic[@"message"]];
                } else {
                    [MsgDisplay showErrorMsg:error.description];
                }
            }
        } else {
            [MsgDisplay showErrorMsg:error.description];
        }
        
        isRequestingData = NO;
    } userCanceledCaptcha:^() {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [wpyCacheManager loadCacheDataWithKey:GPA_CACHE andBlock:^(id cacheData) {
            dataArr = [GPAData mj_objectArrayWithKeyValuesArray:(cacheData[@"data"])[@"data"]];
            stat = [GPAStat mj_objectWithKeyValues:(cacheData[@"data"])[@"stat"]];
            [self updateView];
            [MsgDisplay showErrorMsg:@"您已取消输入验证码\n将为您加载缓存"];
        } failed:^{
            [MsgDisplay showErrorMsg:@"您已取消输入验证码"];
        }];
        isRequestingData = NO;
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
    
    [chartDataArr removeAllObjects];
    for (GPAData *data in dataArr) {
        [chartDataArr addObject:[NSNumber numberWithDouble:[data.score doubleValue]]];
    }
    [chartView reloadData];
    [chartView setState:JBChartViewStateExpanded animated:YES];
}

- (void)adjustStyleWithScrollOffset:(float)offSetY {
    if (offSetY > -60 && offSetY <= -10) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        self.navigationController.navigationBar.tintColor = [UIColor flatPinkColorDark];
        self.navigationController.navigationBarBackgroundAlpha = (offSetY + 60) * 0.02;
    } else if (offSetY <= -60) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBarBackgroundAlpha = 0.0;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        self.navigationController.navigationBar.tintColor = [UIColor flatPinkColorDark];
        self.navigationController.navigationBarBackgroundAlpha = 1.0;
    }
}

- (void)saveGPADataForCoreSpotlight {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError *error) {
            
        }];
        NSMutableArray *searchableItems = [[NSMutableArray alloc] init];
        for (GPAData *data in dataArr) {
            for (GPAClassData *tmp in data.data) {
                CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"image"];
                attributeSet.title = tmp.name;
                attributeSet.contentDescription = [NSString stringWithFormat:@"成绩：%@   学分：%@", tmp.score, tmp.credit];
                attributeSet.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"thumbAppIcon"]);
                CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:tmp.name domainIdentifier:@"cn.edu.twt.WePeiYang" attributeSet:attributeSet];
                [searchableItems addObject:item];
            }
        }
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError *error) {
            if (error) {
                NSLog(error.localizedDescription);
            }
        }];
    });
}

#pragma mark - IBActions

- (IBAction)refresh:(id)sender {
    if ([AccountManager tokenExists]) {
        if (dataArr.count == 0) {
            [self getGPAData];
        } else {
            [self updateView];
        }
    } else {
        dataArr = [[NSArray alloc] init];
        chartDataArr = [[NSMutableArray alloc] init];
        stat = [[GPAStat alloc] init];
        currentTerm = 0;
        graphIsTouched = NO;
        lastSelected = 0;
        [self.tableView reloadData];
        [self updateView];
        
    }
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
    [self adjustStyleWithScrollOffset:scrollView.contentOffset.y];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showStat"]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        self.navigationController.navigationBar.tintColor = [UIColor flatPinkColorDark];
        self.navigationController.navigationBarBackgroundAlpha = 1.0;
        GPAAnalysisTableViewController *destVC = (GPAAnalysisTableViewController *)[segue destinationViewController];
        destVC.dataArr = dataArr;
    }
}

@end
