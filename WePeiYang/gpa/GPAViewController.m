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
#import <ShareSDK/ShareSDK.h>
#import "AFNetworking.h"
#import "UIButton+Bootstrap.h"
#import "twtLoginViewController.h"
#import "CSNotificationView.h"
#import "gpaHeaderView.h"
#import "SVProgressHUD.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

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
    NSMutableArray *everyArr;
    
    NSMutableArray *dataInTable;
    
    NSMutableArray *terms;
    
    UIAlertView *errorAlert;
    
    CGRect frame; //tableHeaderView.frame
    
    UIColor *gpaTintColor;
    
    gpaHeaderView *gpaHeader;
    
    //Instances
    NSInteger gpaHeaderViewHeight;
}

@synthesize tableView;
@synthesize moreBtn;
@synthesize backBtn;
@synthesize loginBtn;
@synthesize noLoginLabel;
@synthesize chart;
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //[self.navigationController setNavigationBarHidden:YES];
    
    //INSTANCES
    gpaHeaderViewHeight = 150;
    
    self.title = @"GPA查询";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    gpaTintColor = [UIColor colorWithRed:255/255.0f green:85/255.0f blue:95/255.0f alpha:1.0f];
    [[UIButton appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    gpaData = [[NSMutableArray alloc]initWithObjects: nil];
    
    newAddedSubjects = [[NSMutableArray alloc]initWithObjects:nil, nil];
    
    [loginBtn primaryStyle];
    
    gpaHeader = [[gpaHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, gpaHeaderViewHeight)];
    
    [self reloadArraysInTable];
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

- (void)reloadArraysInTable
{
    dataInTable = [[NSMutableArray alloc]initWithObjects: nil];
}

- (void)checkLoginStatus
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [moreBtn setHidden:YES];
        [chart setHidden:YES];
        [tableView setHidden:YES];
        [noLoginLabel setHidden:NO];
        [loginBtn setHidden:NO];
        [noLoginImg setHidden:NO];
        [noLoginLabel setText:@"您尚未登录天外天账号"];
        [loginBtn setTitle:@"点击这里登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        NSString *url = @"http://push-mobile.twtapps.net/gpa/get";
        //NSString *body = [NSString stringWithFormat:@"id=%@&token=%@",[data shareInstance].userId,[data shareInstance].userToken];
        NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                     @"token":[data shareInstance].userToken,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        
        [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //Successful
            loginBtn.userInteractionEnabled = YES;
            [moreBtn setHidden:NO];
            [chart setHidden:NO];
            [tableView setHidden:NO];
            [loginBtn setHidden:YES];
            [noLoginLabel setHidden:YES];
            [noLoginImg setHidden:YES];
            [data shareInstance].gpaLoginStatus = @"";
            backBtn.tintColor = [UIColor whiteColor];
            [self processGpaData:responseObject];
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSInteger statusCode = operation.response.statusCode;
            [self processErrorWithStatusCode:statusCode];
            [SVProgressHUD dismiss];
        }];
        
    }
}

- (void)login
{
    twtLoginViewController *login = [[twtLoginViewController alloc]initWithNibName:nil bundle:nil];
    [login setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:login animated:YES completion:^{
        login.twtLoginType = twtLoginTypeGPA;
    }];
}

- (void)processErrorWithStatusCode:(NSInteger)statusCode {
    backBtn.tintColor = gpaTintColor;
    switch (statusCode) {
        case 401:
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"验证出错…请重新登录~"];
            [moreBtn setHidden:YES];
            [chart setHidden:YES];
            [tableView setHidden:YES];
            [noLoginLabel setHidden:NO];
            [loginBtn setHidden:NO];
            [noLoginImg setHidden:NO];
            [noLoginLabel setText:@"您尚未登录天外天账号"];
            [loginBtn setTitle:@"点击这里登录" forState:UIControlStateNormal];
            [loginBtn removeTarget:self action:@selector(bindTju) forControlEvents:UIControlEventTouchUpInside];
            [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];

            break;
            
        case 403:
            [moreBtn setHidden:YES];
            [chart setHidden:YES];
            [tableView setHidden:YES];
            [noLoginLabel setHidden:NO];
            [loginBtn setHidden:NO];
            [noLoginImg setHidden:NO];
            [noLoginLabel setText:@"您尚未绑定办公网账号"];
            loginBtn.userInteractionEnabled = YES;
            [loginBtn setTitle:@"点击这里绑定" forState:UIControlStateNormal];
            [loginBtn removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
            [loginBtn addTarget:self action:@selector(bindTju) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case 500:
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"服务器出错惹QAQ"];
            break;
            
        default:
            break;
    }
}

- (void)bindTju {
    GPALoginViewController *gpaLogin = [[GPALoginViewController alloc]initWithNibName:nil bundle:nil];
    [gpaLogin setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:gpaLogin animated:YES completion:nil];
}
    
- (IBAction)openActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"一键评价",@"手动评价",@"分享GPA",@"GPA计算器", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        nil;
    } else if (buttonIndex == 0) {
        [self oneKeyToEvaluate];
    } else if (buttonIndex == 1) {
        [self selfEvaluate];
    } else if (buttonIndex == 2) {
        [self shareGPA];
    } else if (buttonIndex == 3) {
        [self pushGPACalculator];
    }
}

- (void)selfEvaluate {
    NSURL *url = [NSURL URLWithString:@"http://e.tju.edu.cn"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)processGpaData:(NSDictionary *)gpaDic
{
    NSArray *termsDataArr = [gpaDic objectForKey:@"terms"];
    
    for (NSDictionary *termDic in termsDataArr)
    {
        for (NSDictionary *temp in termDic)
        {
            [gpaData addObject:temp];
        }
    }
    [data shareInstance].gpaDataArray = gpaData;
    
    //所有科目的学期值数组
    //[data shareInstance].termsArray = termArray;
    
    gpa = [[[gpaDic objectForKey:@"data"] objectForKey:@"gpa"] floatValue];
    score = [[[gpaDic objectForKey:@"data"] objectForKey:@"score"] floatValue];
    
    gpaHeader.gpaLabel.text = [NSString stringWithFormat:@"%.2f",gpa];
    gpaHeader.scoreLabel.text = [NSString stringWithFormat:@"%.2f",score];
    
    //学期数组
    terms = [[NSMutableArray alloc]initWithObjects: nil];
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
    
    everyArr = [[NSMutableArray alloc]initWithObjects: nil];
    NSArray *everyDataArr = [[gpaDic objectForKey:@"data"]objectForKey:@"every"];
    for (NSDictionary *tmp in everyDataArr)
    {
        [everyArr addObject:[tmp objectForKey:@"score"]];
    }
    [data shareInstance].every = everyArr;
    
    NSArray *termsInGraph;
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
    
    [data shareInstance].term = terms;
    [data shareInstance].termsInGraph = termsInGraph;
    
    [self compareWithPreviousResult];
    
    chart = [[YTrendChartView alloc]init];
    [chart setFrame:CGRectMake(0, gpaHeaderViewHeight+20, self.view.frame.size.width, 130)];
    [chart setBackgroundColor:[UIColor whiteColor]];
    //[self.view addSubview:chart];
    chart.delegate = self;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, gpaHeaderViewHeight+150)];
    [headerView addSubview:gpaHeader];
    [headerView addSubview:chart];
    
    
    tableView.tableHeaderView = headerView;
    //frame = [tableView.tableHeaderView frame];
}

- (void)oneKeyToEvaluate
{
    NSString *url = @"http://push-mobile.twtapps.net/gpa/auto";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                 @"token":[data shareInstance].userToken,
                                 @"platform":@"ios",
                                 @"version":appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"一键评价成功！"];
        [self checkLoginStatus];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        switch (statusCode) {
            case 403:
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"没有可以评价的科目"];
                break;
                
            default:
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"无法一键评价T^T"];
                break;
        }
    }];
    
}

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
        GPALoginViewController *login = [[GPALoginViewController alloc]initWithNibName:nil bundle:nil];
        [self presentViewController:login animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = gpaTintColor;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectTermForString:(NSString *)string
{
    [self reloadArraysInTable];
    NSString *termSelectedStr = string;
    for (int i = 0; i < [gpaData count]; i++)
    {
        if ([[[gpaData objectAtIndex:i] objectForKey:@"term"] isEqualToString:termSelectedStr])
        {
            [dataInTable addObject:[gpaData objectAtIndex:i]];
        }
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
}

- (IBAction)backToHomeBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)captureScreen
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)shareGPA
{
    UIImage *screenShot = [self captureScreen];
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
    
    NSData *imgData = UIImageJPEGRepresentation(shareImg, 1.0);
    
    NSString *shareFrom = @"（分享自 微北洋 iOS 版 https://itunes.apple.com/cn/app/wei-bei-yang/id785509141?mt=8）";
    NSString *gpaStr = gpaHeader.gpaLabel.text;
    NSString *scoreStr = gpaHeader.scoreLabel.text;
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"我的平均分是 %@，GPA是 %@，快来晒出你的GPA吧！%@",scoreStr,gpaStr,shareFrom];
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession, ShareTypeWeixiTimeline, ShareTypeRenren, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeQQ, ShareTypeQQSpace, ShareTypeFacebook, ShareTypeTwitter, nil];
    id<ISSContent> publishContent = [ShareSDK content:shareString
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithData:imgData fileName:@"gpa" mimeType:@"jpg"]
                                                title:@"晒出GPA"
                                                  url:nil
                                          description:@"分享自微北洋"
                                            mediaType:SSPublishContentMediaTypeImage];
    NSArray *oneKeyShareList = shareList;
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil      //分享视图标题
                                                              oneKeyShareList:oneKeyShareList           //一键分享菜单
                                                               qqButtonHidden:NO                               //QQ分享按钮是否隐藏
                                                        wxSessionButtonHidden:NO                   //微信好友分享按钮是否隐藏
                                                       wxTimelineButtonHidden:NO                 //微信朋友圈分享按钮是否隐藏
                                                         showKeyboardOnAppear:NO                  //是否显示键盘
                                                            shareViewDelegate:nil                            //分享视图委托
                                                          friendsViewDelegate:nil                          //好友视图委托
                                                        picViewerViewDelegate:nil];                    //图片浏览视图委托
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

//和之前查询的成绩进行比较，如果新出科目则标注小蓝点，并保存最新查询的成绩
- (void)compareWithPreviousResult
{
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
}

- (void)pushGPACalculator
{
    GPACalculatorViewController *gpaCalculator = [[GPACalculatorViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:gpaCalculator animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offsetY = [scrollView contentOffset].y;
    //NSLog([NSString stringWithFormat:@"%f",offsetY]);
    gpaHeader.alpha = 1-offsetY/150;
    if (offsetY > 100)
    {
        chart.alpha = 1-(offsetY-150)/130;
    }
    backBtn.tintColor = [UIColor colorWithRed:255/255.0f green:(-2*offsetY+255)/255.0f blue:(-1.8824*offsetY+255)/255.0f alpha:1.0f];
    moreBtn.tintColor = [UIColor colorWithRed:255/255.0f green:(-2*offsetY+255)/255.0f blue:(-1.8824*offsetY+255)/255.0f alpha:1.0f];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
