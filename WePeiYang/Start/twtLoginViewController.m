//
//  twtLoginViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-12.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "twtLoginViewController.h"
#import "GPAViewController.h"
#import "wpyWebConnection.h"
#import "data.h"
#import "UIButton+Bootstrap.h"
#import "CSNotificationView.h"
#import "wpyEncryption.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface twtLoginViewController ()

@end

@implementation twtLoginViewController

{
    UIAlertView *successAlert;
    BOOL moved;
}

@synthesize unameField;
@synthesize passwdField;
@synthesize twtLoginType;
@synthesize loginBtn;
@synthesize cancelBtn;
//@synthesize beiniangImg;

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
    //[loginBtn primaryStyle];
    //[cancelBtn primaryStyle];
    moved = NO;
    UIColor *color = [UIColor colorWithWhite:0.9 alpha:1.0];
    unameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入天外天账号" attributes:@{NSForegroundColorAttributeName: color}];
    passwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    [[UITextField appearance]setTintColor:color];
    self.view.backgroundColor = [UIColor colorWithRed:49/255.0f green:154/255.0f blue:207/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (IBAction)login:(id)sender
{
    [loginBtn setUserInteractionEnabled:NO];
    if (moved)
    {
        [self moveView:80];
        moved = NO;
    }
    [unameField resignFirstResponder];
    [passwdField resignFirstResponder];
    NSString *uname = [unameField text];
    NSString *passwd = [passwdField text];
    if ([uname isEqualToString:@""] || [passwd isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString *url = @"http://push-mobile.twtapps.net/user/login";
        NSString *body = [NSString stringWithFormat:@"twtuname=%@&twtpasswd=%@",uname,passwd];
        [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
            if (dic!=nil) [self processReceivedData:dic];
            else
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
                [loginBtn setUserInteractionEnabled:YES];
            }
        }];
    }
}

- (void)processReceivedData:(NSDictionary *)loginDic
{
    if ([[loginDic objectForKey:@"statusCode"]isKindOfClass:[NSString class]])
    {
        if (![[loginDic objectForKey:@"statusCode"] isEqualToString:@"200"])
        {
            //NSString *msg = [NSString stringWithFormat:@"%@",[loginDic objectForKey:@"msg"]];
            //UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"出错" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //[errorAlert show];
            if ([[loginDic objectForKey:@"statusCode"] isEqualToString:@"401"])
            {
                UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"出错" message:@"账号或密码错误哦QAQ" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [errorAlert show];
            }
            else
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"服务器出错了QAQ"];
            }
        }
        else
        {
            NSMutableDictionary *contentDic = [loginDic objectForKey:@"content"];
            NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:plistPath])
            {
                [fileManager removeItemAtPath:plistPath error:nil];
            }
            [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
            
            NSString *twtId = [contentDic objectForKey:@"id"];
            NSString *twtToken = [contentDic objectForKey:@"token"];
            NSString *key = @"TWT224studio";
            NSData *plainId = [twtId dataUsingEncoding:NSUTF8StringEncoding];
            NSData *secretId = [plainId AES256EncryptWithKey:key];
            NSData *plainToken = [twtToken dataUsingEncoding:NSUTF8StringEncoding];
            NSData *secretToken = [plainToken AES256EncryptWithKey:key];
            
            NSMutableData *saveData = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:saveData];
            [archiver encodeObject:secretId forKey:@"id"];
            [archiver encodeObject:secretToken forKey:@"token"];
            [archiver finishEncoding];
            
            [saveData writeToFile:plistPath atomically:YES];
            
            [data shareInstance].userId = [contentDic objectForKey:@"id"];
            [data shareInstance].userToken = [contentDic objectForKey:@"token"];
            
            NSString *tjuuname = [contentDic objectForKey:@"tjuuname"];
            NSString *libuname = [contentDic objectForKey:@"libuname"];
            if (![tjuuname isEqualToString:@""])
            {
                NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"bindTju"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
            }
            if (![libuname isEqualToString:@""])
            {
                NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"bindLib"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
            }
            
            if (twtLoginType == twtLoginTypeGPA)
            {
                [data shareInstance].gpaLoginStatus = @"Changed";
                successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"登录成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [successAlert show];
            }
            else if (twtLoginType == twtLoginTypeLibrary)
            {
                [data shareInstance].libLogin = @"Changed";
                successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"登录成功！\n图书馆系统加载速度较慢\n请耐心等待哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [successAlert show];
            }
        }
    }
    else
    {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"ERROR"];
    }
    [loginBtn setUserInteractionEnabled:YES];
}

- (IBAction)cancelLogin:(id)sender
{
    UIViewController *guide = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [guide dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == successAlert)
    {
        UIViewController *guide = self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            [guide dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    [unameField resignFirstResponder];
    [passwdField resignFirstResponder];
    if (moved)
    {
        [self moveView:80];
        moved = NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)textFieldBeginEditing:(id)sender
{
    if (!moved)
    {
        [self moveView:-80];
        moved = YES;
    }
}

- (IBAction)textFieldEndEditing:(id)sender
{
    if(moved)
    {
        [self moveView:80];
        moved = NO;
    }
}

- (void)moveView:(float)move
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y += move;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    //设置调整界面的动画效果
}

@end
