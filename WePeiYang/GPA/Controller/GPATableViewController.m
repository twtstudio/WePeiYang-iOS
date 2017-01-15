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
#import "MJExtension.h"
#import "twtSDK.h"
#import "GPAData.h"
#import "GPAClassData.h"
#import "GPAStat.h"
#import "GPATableViewCell.h"
#import "wpyCacheManager.h"
#import "MsgDisplay.h"
#import "twtSecretKeys.h"
#import "wpyCacheManager.h"
#import "BlocksKit.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import "wpyDeviceStatus.h"
#import "AccountManager.h"
#import "AFNetworking.h"
#import "WePeiYang-Swift.h"

#define BACKGROUND_BLUR_KEY @"backgroundBlurGPA"

@interface GPATableViewController ()<UIScrollViewAccessibilityDelegate>

@end

@implementation GPATableViewController {
    NSArray *dataArr;
    NSMutableArray *chartDataArr;
    NSInteger currentTerm;
    GPAStat *stat;
    NSMutableSet *oldClassNamesSet;
    
    BOOL graphIsTouched;
    NSInteger lastSelected;
    
    NSString *userName;
    NSString *userPasswd;
    NSString *GPASession;
    
    BOOL isRequestingData;
    
    //test
    NSDictionary *fuckingDict;
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
    self.jz_navigationBarBackgroundAlpha = 0.0;
    self.clearsSelectionOnViewWillAppear = YES;
    headerView.backgroundColor = [UIColor flatPinkColorDark];
    
    dataArr = [[NSArray alloc] init];
    chartDataArr = [[NSMutableArray alloc] init];
    stat = [[GPAStat alloc] init];
    currentTerm = 0;
    graphIsTouched = NO;
    lastSelected = 0;
    isRequestingData = NO;
    oldClassNamesSet = [[NSMutableSet alloc] init];
    
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
    
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotificationReceived) name:@"NOTIFICATION_BINDTJU_SUCCESSED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotificationReceived) name:@"NOTIFICATION_BINDTJU_CANCELLED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotificationReceived) name:@"NOTIFICATION_LOGIN_SUCCESSED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotificationReceived) name:@"NOTIFICATION_LOGIN_CANCELLED" object:nil];
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.tintColor = self.view.tintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
//    self.jz_navigationBarBackgroundAlpha = 1.0;
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
    [self refresh];
}

- (void)backNotificationReceived {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)refresh {
    if ([AccountManager tokenExists]) {
        if (dataArr.count == 0) {
            [self getGPAData];
        } else {
            [self updateView];
        }
    } else {
        [self clearTableContent];
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)clearTableContent {
    dataArr = [[NSArray alloc] init];
    chartDataArr = [[NSMutableArray alloc] init];
    stat = [[GPAStat alloc] init];
    currentTerm = 0;
    graphIsTouched = NO;
    lastSelected = 0;
    [self.tableView reloadData];
    [self updateView];
}

- (void)getGPAData {
    if (!isRequestingData) {
        isRequestingData = YES;
        // 继承旧版本？
        [self fetchGPAData];
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
        GPASession = (cacheData[@"data"])[@"session"];
        stat = [GPAStat mj_objectWithKeyValues:(cacheData[@"data"])[@"stat"]];
        for (GPAData *tmpData in dataArr) {
            for (GPAClassData *tmpClass in tmpData.data) {
                [oldClassNamesSet addObject:tmpClass.name];
            }
        }
        [self.tableView reloadData];
        [self updateView];
    } failed:nil];
    [twtSDK getGpaWithToken:[[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY] success:^(NSURLSessionTask *task, id responseObject) {
        //fuckingDict = (NSDictionary *)responseObject;
        if ([responseObject[@"error_code"] isEqual: @-1]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [wpyCacheManager saveCacheData:responseObject withKey:GPA_CACHE];
            dataArr = [GPAData mj_objectArrayWithKeyValuesArray:(responseObject[@"data"])[@"data"]];
            GPASession = (responseObject[@"data"])[@"session"];
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
        [MsgDisplay dismiss];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MsgDisplay dismiss];
        NSError *jsonError;
        NSData *errorResponse = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorResponse) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorResponse options:NSJSONReadingMutableContainers error:&jsonError];
            if (dic != nil) {
                if ([dic objectForKey:@"error_code"] != nil) {
                    NSString *errorCode = [dic[@"error_code"] stringValue];
                    if ([errorCode isEqualToString:@"20001"]) {
                        // 未绑定
                        [MsgDisplay showErrorMsg:dic[@"message"]];
                        [self clearTableContent];
                        BindTjuViewController *bindTju = [[BindTjuViewController alloc] initWithStyle:UITableViewStyleGrouped];
                        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:bindTju] animated:YES completion:nil];
                    } else if ([errorCode isEqualToString:@"20002"]) {
                        // TJU 验证失败
                        [MsgDisplay showErrorMsg:dic[@"message"]];
                        [self clearTableContent];
                        
                    }
                } else {
                    if ([dic objectForKey:@"message"] != nil) {
                        [MsgDisplay showErrorMsg:dic[@"message"]];
                    } else {
                        [MsgDisplay showErrorMsg:error.localizedDescription];
                    }
                }
            } else {
                [MsgDisplay showErrorMsg:error.localizedDescription];
            }
        } else {
            [MsgDisplay showErrorMsg:error.localizedDescription];
        }
        
        isRequestingData = NO;
    } userCanceledCaptcha:^() {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MsgDisplay dismiss];
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
        self.jz_navigationBarBackgroundAlpha = (offSetY + 60) * 0.02;
    } else if (offSetY <= -60) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.jz_navigationBarBackgroundAlpha = 0.0;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        self.navigationController.navigationBar.tintColor = [UIColor flatPinkColorDark];
        self.jz_navigationBarBackgroundAlpha = 1.0;
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
//                NSLog(error.localizedDescription);
            }
        }];
    });
}

- (void)unbindTju {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要解除绑定办公网账号吗？" message:@"解除绑定后您将无法获得成绩等信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [AccountManager unbindTjuAccountSuccess:^{
            [MsgDisplay showSuccessMsg:@"解除绑定成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *errorMsg) {
            [MsgDisplay showErrorMsg:[NSString stringWithFormat:@"解除绑定失败！\n%@", errorMsg]];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)moreActions:(id)sender {
    UIAlertController *actions = [UIAlertController alertControllerWithTitle:@"更多" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *refreshAction = [UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self refresh];
    }];
    UIAlertAction *unbindAction = [UIAlertAction actionWithTitle:@"解绑办公网账号" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self unbindTju];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [actions addAction:refreshAction];
    [actions addAction:unbindAction];
    [actions addAction:cancelAction];
    actions.modalPresentationStyle = UIModalPresentationPopover;
    actions.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    actions.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    actions.popoverPresentationController.sourceView = self.view;
    [self presentViewController:actions animated:YES completion:nil];
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
    //NSLog(@"%@", tmp);
    cell.nameLabel.text = tmp.name;
    cell.creditLabel.text = tmp.credit;
    //if need to evaluate course to get score
    if ([tmp.score  isEqual: @"-1"]) {
        cell.scoreLabel.text = @"点这里去评价";
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.userInteractionEnabled = YES;
    } else {
        cell.scoreLabel.text = tmp.score;
        cell.userInteractionEnabled = NO;
    }
    cell.dotView.hidden = ([oldClassNamesSet containsObject:tmp.name] || oldClassNamesSet.count == 0) ? YES : NO;
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CourseAppraiseViewController *CourseAppraiseVC = [[CourseAppraiseViewController alloc] init];
    GPAData *gpa = (GPAData *)dataArr[currentTerm];
    GPAClassData *tmp = gpa.data[indexPath.row];
    CourseAppraiseVC.data = tmp;
    CourseAppraiseVC.GPASession = GPASession;
    [self.navigationController pushViewController:CourseAppraiseVC animated:YES];
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    GPATableViewCell *cell = (GPATableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.scoreLabel.text isEqualToString:@"点这里去评价"]) {
//        return indexPath;
//    }
//    return nil;
//}


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

}

@end
