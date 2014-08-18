//
//  AboutViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-18.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "AboutUSViewController.h"
#import "GuideViewController.h"
#import "DMScaleTransition.h"
#import "wpyWebConnection.h"
#import "twtLoginViewController.h"
#import "data.h"
#import "CSNotificationView.h"
#import "LoginViewController.h"
#import "GPALoginViewController.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface AboutViewController ()

@property (strong, nonatomic) DMScaleTransition *scaleTransition;

@end

@implementation AboutViewController

{
    NSArray *aboutArr;
    NSArray *webArr;
    NSArray *feedbackArr;
    
    UIAlertView *removeAlert;
}

@synthesize scaleTransition;
@synthesize tableView;

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

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
    aboutArr = @[@"关于我们",@"欢迎页面"];
    webArr = @[@"访问天外天网站"];
    feedbackArr = @[@"发送反馈",@"联系我们"];
    //self.title = @"关于";
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //对于iOS 7.1 应该这样……
    scaleTransition = [[DMScaleTransition alloc]init];
    
    [[UIButton appearance]setTintColor:[UIColor darkGrayColor]];
    [[UITextView appearance]setTintColor:[UIColor darkGrayColor]];
    [[UITextField appearance]setTintColor:[UIColor darkGrayColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor darkGrayColor]];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc]init];
    NSString *backIconPath = [[NSBundle mainBundle]pathForResource:@"backForNav@2x" ofType:@"png"];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithContentsOfFile:backIconPath] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome:)];
    [navigationBar pushNavigationItem:navigationItem animated:YES];
    [navigationItem setTitle:@"关于"];
    [navigationItem setLeftBarButtonItem:backBarBtn];
    [self.view addSubview:navigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)logFileExists
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath]) return YES;
    else return NO;
}

- (BOOL)libBinded
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"bindLib"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath]) return YES;
    else return NO;
}

- (BOOL)tjuBinded
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"bindTju"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath]) return YES;
    else return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [aboutArr count];
    }
    else if (section == 1)
    {
        return [webArr count];
    }
    else if (section == 2)
    {
        return [feedbackArr count];
    }
    else if (section == 3)
    {
        if ([self logFileExists])
        {
            return 3;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    if (section == 0)
    {
        cell.textLabel.text = [aboutArr objectAtIndex:row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (section == 1)
    {
        cell.textLabel.text = [webArr objectAtIndex:row];
    }
    else if (section == 2)
    {
        cell.textLabel.text = [feedbackArr objectAtIndex:row];
        if (row == 0) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (section == 3)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self logFileExists])
        {
            if (row == 0)
            {
                if ([self tjuBinded]) cell.textLabel.text = @"解除办公网账号绑定";
                else cell.textLabel.text = @"绑定办公网账号";
            }
            else if (row == 1)
            {
                if ([self libBinded]) cell.textLabel.text = @"解除图书馆账号绑定";
                else cell.textLabel.text = @"绑定图书馆账号";
            }
            else if (row == 2)
            {
                cell.textLabel.text = @"注销天外天账号";
            }
        }
        else
        {
            cell.textLabel.text = @"登录天外天账号";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    if (section == 0)
    {
        if (row == 0)
        {
            [self pushAboutUS];
        }
        else if (row == 1)
        {
            [self showGuide];
        }
    }
    else if (section == 1)
    {
        if (row == 0)
        {
            [self openTwtInSafari];
        }
    }
    else if (section == 2)
    {
        if (row == 0)
            [self pushFeedback];
        else if (row == 1)
        {
            [self sendEmail];
        }
    }
    else if (section == 3)
    {
        if ([self logFileExists])
        {
            if (row == 0)
            {
                if ([self tjuBinded]) [self jbTju];
                else [self bindTju];
            }
            else if (row == 1)
            {
                if ([self libBinded]) [self jbLib];
                else [self bindLib];
            }
            else
            {
                [self logout];
            }
        }
        else
        {
            [self login];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)joinUs
{
    NSURL *twt = [NSURL URLWithString:@"http://mobile.twt.edu.cn/apply.html"];
    [[UIApplication sharedApplication] openURL:twt];
}

- (void)pushFeedback
{
    FeedbackViewController *feedback;
    if (DEVICE_IS_IPHONE5)
    {
        feedback = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    }
    else
    {
        feedback = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController3.5" bundle:nil];
    }
    [self.navigationController pushViewController:feedback animated:YES];
}

- (void)openTwtInSafari
{
    NSURL *twt = [NSURL URLWithString:@"http://www.twt.edu.cn"];
    [[UIApplication sharedApplication] openURL:twt];
}

- (void)pushAboutUS
{
    AboutUSViewController *aboutUS = [[AboutUSViewController alloc] init];
    [self.navigationController pushViewController:aboutUS animated:YES];
}

- (void)sendEmail
{
    //检测设备是否支持邮件发送功能
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];//调用发送邮件的方法
        }
    }

}

- (void)displayComposerSheet
{
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@""];
    [mc setToRecipients:@[@"mobile@twtstudio.com"]];
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showGuide
{
    GuideViewController *guide = [[GuideViewController alloc]init];
    [guide setTransitioningDelegate:scaleTransition];
    [self presentViewController:guide animated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"关于";
    }
    else if (section == 1)
    {
        return @"更多";
    }
    else if (section == 2)
    {
        return @"反馈";
    }
    else if (section == 3)
    {
        return @"账号管理";
    }
    else
    {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else if (section == 2)
    {
        return @"非常希望您能够将您的宝贵意见告诉我们。\n您的建议是微北洋持续改进的动力。";
    }
    else
    {
        return @"";
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == removeAlert)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            [self logout];
        }
    }
}

- (void)logout
{
    NSString *url = @"http://push-mobile.twtapps.net/user/logout";
    NSString *body = [NSString stringWithFormat:@"id=%@&token=%@",[data shareInstance].userId,[data shareInstance].userToken];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if ([[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
            {
                //NSString *msg = [dic objectForKey:@"msg"];
                //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //[alert show];
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"注销账号成功！"];
            }
            else
            {
                //NSString *msg = [[dic objectForKey:@"content"] objectForKey:@"msg"];
                //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"成功" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //[alert show];
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"注销账号失败QAQ"];
            }
        }
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
        }
    }];
    
    [data shareInstance].userId = @"";
    [data shareInstance].userToken = @"";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = @[@"login",@"libraryCollectionData",@"gpa",@"gpaResult",@"collectionData",@"noticeFavData",@"jobFavData",@"noticeAccount",@"twtLogin",@"libraryRecordCache",@"gpaCacheData",@"bindLib",@"bindTju"];
    for (NSString *fileName in files)
    {
        NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:plistPath error:nil];
        NSLog(@"Plist file %@ deleted.",fileName);
    }
    
    [self.tableView reloadData];
}

- (void)jbTju
{
    NSString *userId = [data shareInstance].userId;
    NSString *userToken = [data shareInstance].userToken;
    NSString *url = @"http://push-mobile.twtapps.net/user/unbindTju";
    NSString *body = [NSString stringWithFormat:@"id=%@&token=%@",userId,userToken];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if ([[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"解除绑定成功！"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray *files = @[@"gpa",@"gpaResult",@"gpaCacheData",@"bindTju"];
                for (NSString *fileName in files)
                {
                    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
                    [fileManager removeItemAtPath:plistPath error:nil];
                    NSLog(@"Plist file %@ deleted.",fileName);
                }
                [self.tableView reloadData];
            }
            else
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"解除绑定失败！"];
            }
        }
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
        }
    }];
}

- (void)jbLib
{
    NSString *userId = [data shareInstance].userId;
    NSString *userToken = [data shareInstance].userToken;
    NSString *url = @"http://push-mobile.twtapps.net/user/unbindLib";
    NSString *body = [NSString stringWithFormat:@"id=%@&token=%@",userId,userToken];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if ([[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"解除绑定成功！"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray *files = @[@"login",@"libraryRecordCache",@"bindLib"];
                for (NSString *fileName in files)
                {
                    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
                    [fileManager removeItemAtPath:plistPath error:nil];
                    NSLog(@"Plist file %@ deleted.",fileName);
                }
                [self.tableView reloadData];
            }
            else
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"解除绑定失败！"];
            }
        }
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
        }
    }];
}

- (void)bindTju
{
    GPALoginViewController *gpaLogin = [[GPALoginViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:gpaLogin animated:YES completion:nil];
}

- (void)bindLib
{
    LoginViewController *libLogin = [[LoginViewController alloc]initWithNibName:nil bundle:nil];
    [self presentViewController:libLogin animated:YES completion:nil];
}

- (void)login
{
    twtLoginViewController *twtLogin = [[twtLoginViewController alloc]initWithNibName:nil bundle:nil];
    [twtLogin setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:twtLogin animated:YES completion:nil];
}

- (IBAction)backToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
