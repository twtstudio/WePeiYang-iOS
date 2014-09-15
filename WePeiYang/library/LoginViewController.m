//
//  LoginViewController.m
//  Library
//
//  Created by Qin Yubo on 13-11-5.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "LoginViewController.h"
#import "data.h"
#import "UIButton+Bootstrap.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

{
    NSString *username;
    NSString *password;
    
    UIAlertView *waitingAlert;
    UIAlertView *successAlert;
}

@synthesize passwordField;
@synthesize usernameField;
@synthesize loginBtn;
@synthesize cancelBtn;

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
    //self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"loginbg.png"]];
    
    [loginBtn successStyle];
    [cancelBtn dangerStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender
{
    [loginBtn setUserInteractionEnabled:NO];
    username = usernameField.text;
    password = passwordField.text;
    if ([username isEqualToString:@""] || [password  isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        waitingAlert = [[UIAlertView alloc]initWithTitle:@"请稍候" message:@"正在登录..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [waitingAlert show];
        //NSString *urlStr = [[NSString alloc]initWithFormat:@"http://service.twtstudio.com/phone/android/lib_account.php?user_id=%@&password=%@&platform=ios&version=%@",username,password,[data shareInstance].appVersion];
        NSString *url = @"http://push-mobile.twtapps.net/user/bindLib";
        NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                     @"token":[data shareInstance].userToken,
                                     @"libname":username,
                                     @"libpasswd":password,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
            successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"绑定图书馆账号成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [successAlert show];
            [data shareInstance].libLogin = @"Changed";
            NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"bindLib"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSInteger statusCode = operation.response.statusCode;
            [waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
            if (statusCode == 401) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"账号或密码错误哦QAQ" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                [SVProgressHUD showErrorWithStatus:@"绑定图书馆帐号失败T^T"];
            }
        }];
        
        /*
        NSString *body = [NSString stringWithFormat:@"id=%@&token=%@&libuname=%@&libpasswd=%@",[data shareInstance].userId,[data shareInstance].userToken,username,password];
        [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
            if (dic!=nil) [self dealWithReceivedData:dic];
            [loginBtn setUserInteractionEnabled:YES];
        }];*/
    }
    [loginBtn setUserInteractionEnabled:YES];
}

/*
- (void)dealWithReceivedData:(NSDictionary *)loginDic
{
    NSString *statusCode = [loginDic objectForKey:@"statusCode"];
    if (![statusCode isEqualToString:@"200"])
    {
        if ([statusCode isEqualToString:@"401"])
        {
            [waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"账号或密码错误哦QAQ" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        [waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
        successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"绑定图书馆账号成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [successAlert show];
        [data shareInstance].libLogin = @"Changed";
        NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"bindLib"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
}
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == waitingAlert)
    {
        
    }
    else
    {
        if (alertView == successAlert)
        {
            if (buttonIndex == [alertView cancelButtonIndex])
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

@end
