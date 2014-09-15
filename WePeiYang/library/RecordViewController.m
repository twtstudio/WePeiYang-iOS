//
//  RecordViewController.m
//  Library
//
//  Created by Qin Yubo on 13-11-5.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "RecordViewController.h"
#import "LibraryViewController.h"
#import "data.h"
#import "RecordTableCell.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "DMSlideTransition.h"
#import "UIButton+Bootstrap.h"
#import "twtLoginViewController.h"
#import "SVProgressHUD.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface RecordViewController ()

@property (strong) DMSlideTransition *slideTrans;

@end

@implementation RecordViewController

{
    NSMutableArray *title;
    NSMutableArray *status;
    NSMutableArray *money;
    NSMutableArray *author;
    NSMutableArray *deadline;
    
    UIAlertView *nilAlert;
    UIAlertView *logoutAlert;
    
    NSDictionary *recordDic;
}

@synthesize tableView;
@synthesize response;
@synthesize slideTrans;
@synthesize noLoginLabel;
@synthesize loginBtn;
@synthesize continueBtn;
@synthesize noLoginImg;
@synthesize headerBackView;

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
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    headerBackView.backgroundColor = [UIColor colorWithRed:0/255.0f green:181/255.0f blue:128/255.0f alpha:1.0f];
    
    title = [[NSMutableArray alloc]initWithObjects: nil];
    status = [[NSMutableArray alloc]initWithObjects: nil];
    money = [[NSMutableArray alloc]initWithObjects: nil];
    author = [[NSMutableArray alloc]initWithObjects: nil];
    deadline = [[NSMutableArray alloc]initWithObjects: nil];
    
    response = [[NSMutableData alloc]init];
    
    [tableView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [loginBtn primaryStyle];
    [self checkLoginStatus];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self checkLoginStatus];
}

- (void)checkLoginStatus
{
    //[data shareInstance].loginStatus = @"NOT CHANGED";
    //NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"login"];
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        //无twt登录文件时
        //
        [tableView setHidden:YES];
        [noLoginLabel setHidden:NO];
        [noLoginLabel setText:@"您尚未登录天外天账号"];
        [loginBtn setHidden:NO];
        [continueBtn setHidden:YES];
        [loginBtn setTitle:@"点击这里登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [continueBtn setHidden:YES];
        [noLoginImg setHidden:NO];
    }
    else
    {
        //[self loadLoginStatusFromPlist];
        
        NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryRecordCache"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:plistPath])
        {
            [self dealWithReceivedLoginData:[[NSDictionary alloc]initWithContentsOfFile:plistPath]];
        }
        
        NSString *url = @"http://push-mobile.twtapps.net/lib/info";
        NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                     @"token":[data shareInstance].userToken,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //Successful
            //[waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
            [SVProgressHUD dismiss];
            
            NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryRecordCache"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:plistPath])
            {
                [fileManager removeItemAtPath:plistPath error:nil];
            }
            else
            {
                [responseObject writeToFile:plistPath atomically:YES];
            }
            
            [self dealWithReceivedLoginData:responseObject];
            [data shareInstance].libLogin = @"";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            NSInteger statusCode = operation.response.statusCode;
            switch (statusCode) {
                    
                case 405:
                    NSLog(@"HERE 405");
                    break;
                    
                case 403:
                    //未绑定图书馆
                    [tableView setHidden:YES];
                    [noLoginLabel setHidden:NO];
                    [loginBtn setHidden:NO];
                    [continueBtn setHidden:YES];
                    [noLoginLabel setText:@"您尚未绑定图书馆账号"];
                    [loginBtn setTitle:@"绑定图书馆" forState:UIControlStateNormal];
                    [loginBtn removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
                    [loginBtn addTarget:self action:@selector(bindLib) forControlEvents:UIControlEventTouchUpInside];
                    [noLoginImg setHidden:NO];
                    break;
                    
                case 401:
                    [SVProgressHUD showErrorWithStatus:@"登录验证出错...请重新登录！"];
                    [tableView setHidden:YES];
                    [noLoginLabel setHidden:NO];
                    [noLoginLabel setText:@"您尚未登录天外天账号"];
                    [loginBtn setHidden:NO];
                    [continueBtn setHidden:YES];
                    [loginBtn setTitle:@"点击这里登录" forState:UIControlStateNormal];
                    [loginBtn removeTarget:self action:@selector(bindLib) forControlEvents:UIControlEventTouchUpInside];
                    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
                    [continueBtn setHidden:YES];
                    [noLoginImg setHidden:NO];
                    break;
                    
                default:
                    [SVProgressHUD showErrorWithStatus:@"获取记录失败T^T"];
                    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryRecordCache"];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:plistPath])
                    {
                        [self dealWithReceivedLoginData:[[NSDictionary alloc]initWithContentsOfFile:plistPath]];
                    }
                    break;
            }
        }];

        
        
        /*
        NSString *body = [NSString stringWithFormat:@"id=%@&token=%@",[data shareInstance].userId,[data shareInstance].userToken];
        [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
            if (dic!=nil)
            {
                if (![[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
                {
                    //出错
                    
                    if([[dic objectForKey:@"statusCode"] isEqualToString:@"403"])
                    {
                        //未绑定图书馆
                        [tableView setHidden:YES];
                        [noLoginLabel setHidden:NO];
                        [loginBtn setHidden:NO];
                        [continueBtn setHidden:YES];
                        [noLoginLabel setText:@"您尚未绑定图书馆账号"];
                        [loginBtn setTitle:@"绑定图书馆" forState:UIControlStateNormal];
                        [loginBtn removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
                        [loginBtn addTarget:self action:@selector(bindLib) forControlEvents:UIControlEventTouchUpInside];
                        [noLoginImg setHidden:NO];
                    }
                    else
                    {
                        if([[dic objectForKey:@"statusCode"] isEqualToString:@"401"])
                        {
                            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"登录验证出错...请重新登录！"];
                            [tableView setHidden:YES];
                            [noLoginLabel setHidden:NO];
                            [noLoginLabel setText:@"您尚未登录天外天账号"];
                            [loginBtn setHidden:NO];
                            [continueBtn setHidden:YES];
                            [loginBtn setTitle:@"点击这里登录" forState:UIControlStateNormal];
                            [loginBtn removeTarget:self action:@selector(bindLib) forControlEvents:UIControlEventTouchUpInside];
                            [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
                            [continueBtn setHidden:YES];
                            [noLoginImg setHidden:NO];
                        }
                    }
                    
                }
                else
                {
                    //未出错
                    [waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
                    NSDictionary *loginDic = [dic objectForKey:@"content"];
                    
                    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryRecordCache"];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:plistPath])
                    {
                        [fileManager removeItemAtPath:plistPath error:nil];
                    }
                    else
                    {
                        [loginDic writeToFile:plistPath atomically:YES];
                    }
                    
                    [self dealWithReceivedLoginData:loginDic];
                    [data shareInstance].libLogin = @"";
                }
            }
            else
            {
                //无网络连接
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
                NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryRecordCache"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:plistPath])
                {
                    [self dealWithReceivedLoginData:[[NSDictionary alloc]initWithContentsOfFile:plistPath]];
                }
            }
        }];
         */
    }
}

- (void)dealWithReceivedLoginData:(NSDictionary *)loginDic
{
    title = [[NSMutableArray alloc]initWithObjects:nil, nil];
    author = [[NSMutableArray alloc]initWithObjects:nil, nil];
    deadline = [[NSMutableArray alloc]initWithObjects:nil, nil];
    recordDic = [loginDic objectForKey:@"charge"];
    NSString *money = [loginDic objectForKey:@"money"];
    NSString *outStr = [NSString stringWithFormat:@"%@",[loginDic objectForKey:@"out"]];
    NSString *backStr = [NSString stringWithFormat:@"%@",[loginDic objectForKey:@"back"]];
    NSString *uName = [loginDic objectForKey:@"uname"];
    [data shareInstance].welcomeLabelString = [NSString stringWithFormat:@"       %@  已借：%@本  应还：%@本  欠款：%@元",uName,outStr,backStr,money];
    if (recordDic != [NSNull null])
    {
        for (NSDictionary *temp in recordDic)
        {
            [title addObject:[temp objectForKey:@"name"]];
            [author addObject:[temp objectForKey:@"author"]];
            [deadline addObject:[temp objectForKey:@"deadline"]];
        }
        [tableView setHidden:NO];
        [noLoginLabel setHidden:YES];
        [loginBtn setHidden:YES];
        [continueBtn setHidden:NO];
        [noLoginImg setHidden:YES];
        [tableView reloadData];
    }
}

/*
- (void)loadLoginStatusFromPlist
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"login"];
    NSDictionary *personalDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *username = [personalDic objectForKey:@"username"];
    NSString *password = [personalDic objectForKey:@"password"];
    //response = [[NSMutableData alloc]init];
    [data shareInstance].libraryUsername = username;
    [data shareInstance].libraryPassword = password;
    waitingAlert = [[UIAlertView alloc]initWithTitle:@"请稍候" message:@"正在加载..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [waitingAlert show];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"http://service.twtstudio.com/phone/android/lib_account.php?user_id=%@&password=%@&platform=ios&version=%@",username,password,[data shareInstance].appVersion];
    [wpyWebConnection getDataFromURLStr:urlStr withFinishCallbackBlock:^(NSDictionary *loginDic){
        if (loginDic != nil) [self dealWithReceivedLoginData:loginDic];
    }];
}
 */

- (void)login
{
    //LoginViewController *login = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
    twtLoginViewController *login = [[twtLoginViewController alloc]initWithNibName:nil bundle:nil];
    [login setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:login animated:YES completion:^{
        login.twtLoginType = twtLoginTypeLibrary;
    }];
}

- (void)bindLib
{
    LoginViewController *libLogin = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
    [libLogin setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:libLogin animated:YES completion:nil];
}

- (IBAction)back:(id)sender
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [title count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    RecordTableCell *cell = (RecordTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RecordTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    cell.titleLabel.text = [title objectAtIndex:row];
    cell.authorLabel.text = [author objectAtIndex:row];
    cell.deadlineLabel.text = [deadline objectAtIndex:row];
    cell.recordCellBgImage.hidden = NO;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == logoutAlert)
    {
        switch (buttonIndex)
        {
            case 1:
            {
                NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"login"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:plistPath error:nil];
                [self checkLoginStatus];
                break;
            }
            default:
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)continueLend:(id)sender
{
    NSString *url = @"http://push-mobile.twtapps.net/lib/renew";
    NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                 @"token":[data shareInstance].userToken,
                                 @"type":@"all",
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] integerValue] == 409) {
            [SVProgressHUD showSuccessWithStatus:@"没有需要续订的书籍"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"一键续订成功!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"一键续订失败T^T"];
    }];
    
    /*
    NSString *body = [NSString stringWithFormat:@"id=%@&token=%@&type=all",[data shareInstance].userId,[data shareInstance].userToken];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if ([[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
            {
                //[CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"一键续订成功!"];
                if ([[[dic objectForKey:@"content"] objectForKey:@"error"] integerValue] == 409)
                {
                    [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"没有需要续订的书籍"];
                }
                else
                {
                    [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"一键续订成功!"];
                }
            }
            else
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"一键续订失败..."];
            }
        }
        else
        {
            //connection failed
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前可能没有网络连接哦~"];
        }
    }];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    [headerView setFrame:CGRectMake(0, 0, [data shareInstance].deviceWidth, 32)];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [data shareInstance].deviceWidth, 32)];
    [headerLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    headerLabel.text = [data shareInstance].welcomeLabelString;
    [headerLabel setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [headerView addSubview:headerLabel];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    return headerView;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
