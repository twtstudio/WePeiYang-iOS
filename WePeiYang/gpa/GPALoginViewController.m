//
//  GPALoginViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-10.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "GPALoginViewController.h"
#import "data.h"
#import "UIButton+Bootstrap.h"
#import "wpyWebConnection.h"
#import "CSNotificationView.h"

@interface GPALoginViewController ()

@end

@implementation GPALoginViewController

{
    NSString *username;
    NSString *password;
    
    UIAlertView *blankAlert;
    UIAlertView *waitingAlert;
    UIAlertView *successAlert;
}

@synthesize usernameField;
@synthesize passwdField;
@synthesize cancelBtn;
@synthesize loginBtn;

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
    //received = [[NSMutableData alloc]init];
    [cancelBtn dangerStyle];
    [loginBtn successStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender
{
    [usernameField resignFirstResponder];
    [passwdField resignFirstResponder];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(id)sender
{
    [loginBtn setUserInteractionEnabled:NO];
    username = usernameField.text;
    password = passwdField.text;
    if ([username isEqualToString:@""] || [password isEqualToString:@""])
    {
        blankAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [blankAlert show];
    }
    else
    {
        /*
        NSString *urlStr = [NSString stringWithFormat:@"http://service.twtstudio.com/phone/android/gpa.php?username=%@&pwd=%@&platform=ios&version=%@",username,password,[data shareInstance].appVersion];
        [wpyWebConnection getDataFromURLStr:urlStr withFinishCallbackBlock:^(NSDictionary *dic){
            if (dic!=nil) [self processGpaData:dic];
            else [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前可能没有网络连接哦~"];
        }];
         */
        
        NSString *url = @"http://push-mobile.twtapps.net/user/bindTju";
        NSString *body = [NSString stringWithFormat:@"id=%@&token=%@&tjuuname=%@&tjupasswd=%@",[data shareInstance].userId,[data shareInstance].userToken,username,password];
        [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
            if (dic!=nil)
            {
                if (![[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
                {
                    if ([[dic objectForKey:@"statusCode"] isEqualToString:@"401"])
                    {
                        //NSString *msg = [[dic objectForKey:@"content"] objectForKey:@"error"];
                        if ([[[dic objectForKey:@"content"] objectForKey:@"error"] integerValue] == 401)
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"出错惹QAQ" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                }
                else
                {
                    successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"绑定账号成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [successAlert show];
                    [data shareInstance].gpaLoginStatus = @"Changed";
                    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"bindTju"];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
                }
            }
            else
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前可能没有网络连接哦~"];
            }
            [loginBtn setUserInteractionEnabled:YES];
        }];
        
    }
}

/*
- (void)processGpaData:(NSDictionary *)gpaDic
{
    //NSInteger termsCount = 0;
    //NSDictionary *lastDic;
    if (gpaDic != nil)
    {
 
        for (NSDictionary *temp in gpaDic)
        {
            termsCount ++;
            lastDic = temp;
        }
        if ([lastDic objectForKey:@"every"] == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"用户名或密码错误！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        else
        {
            [self writeLoginStatusToPlist];
        }
 
        //[self writeLoginStatusToPlist];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"用户名或密码错误！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)writeLoginStatusToPlist
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"gpa"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    NSMutableDictionary *gpaLogin = [[NSMutableDictionary alloc]init];
    [gpaLogin setObject:username forKey:@"username"];
    [gpaLogin setObject:password forKey:@"password"];
    [gpaLogin writeToFile:plistPath atomically:YES];
    successAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [successAlert show];
    [data shareInstance].gpaLoginStatus = @"Login Successed";
}
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == successAlert)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [data shareInstance].gpaLoginStatus = @"Changed";
        }];
    }
}

@end
