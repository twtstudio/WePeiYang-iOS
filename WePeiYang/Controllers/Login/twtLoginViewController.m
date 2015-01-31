//
//  twtLoginViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-12.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "twtLoginViewController.h"
#import "GPAViewController.h"
#import "AFNetworking.h"
#import "data.h"
#import "UIButton+Bootstrap.h"
#import "wpyEncryption.h"
#import "GuideViewController.h"
#import "SVProgressHUD.h"
#import "twtSecretKeys.h"
#import "twtAPIs.h"
#import <POP/POP.h>

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface twtLoginViewController ()

@end

@implementation twtLoginViewController

{
    UIAlertView *successAlert;
}

@synthesize unameField;
@synthesize passwdField;
@synthesize twtLoginType;
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
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
    [loginBtn setUserInteractionEnabled:NO];
    if ([self moved])
    {
        [self adjustViewAnimation];
    }
    [unameField resignFirstResponder];
    [passwdField resignFirstResponder];
    NSString *uname = [unameField text];
    NSString *passwd = [passwdField text];
    if ([uname isEqualToString:@""] || [passwd isEqualToString:@""])
    {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString *url = [twtAPIs twtAPILogin];
        NSDictionary *parameters = @{@"twtuname":uname,
                                     @"twtpasswd":passwd,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            [self processLoginData:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 401) {
                UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"出错" message:@"账号或密码错误哦QAQ" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [errorAlert show];
            } else {
                [SVProgressHUD showErrorWithStatus:@"当前无法登录哦T^T"];
            }
        }];
    }
    [loginBtn setUserInteractionEnabled:YES];
}

- (void)processLoginData:(NSDictionary *)contentDic {
    
    NSUserDefaults *userDefault = [[NSUserDefaults alloc]init];
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:plistPath])
    {
        [fileManager removeItemAtPath:plistPath error:nil];
    }
    [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    
    NSString *twtId = [contentDic objectForKey:@"id"];
    NSString *twtToken = [contentDic objectForKey:@"token"];
    NSString *key = [twtSecretKeys getSecretKey];
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
    
    if ([tjuuname isEqualToString:@""])
    {
        [userDefault setBool:NO forKey:@"bindTju"];
    } else {
        [userDefault setBool:YES forKey:@"bindTju"];
    }
    if ([libuname isEqualToString:@""])
    {
        [userDefault setBool:NO forKey:@"bindLib"];
    } else {
        [userDefault setBool:YES forKey:@"bindLib"];
    }
    
    NSString *studentId = [contentDic objectForKey:@"studentid"];
    [userDefault setObject:studentId forKey:@"studentid"];
    
    if (twtLoginType == twtLoginTypeGPA) {
        [data shareInstance].gpaLoginStatus = @"Changed";
        successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"登录成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [successAlert show];
    } else if (twtLoginType == twtLoginTypeLibrary) {
        [data shareInstance].libLogin = @"Changed";
        successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"登录成功！\n图书馆系统加载速度较慢\n请耐心等待哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [successAlert show];
    }
    [loginBtn setUserInteractionEnabled:YES];
}


- (IBAction)cancelLogin:(id)sender
{
    UIViewController *presentingVC = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([presentingVC isKindOfClass:[GuideViewController class]]) {
            [presentingVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == successAlert)
    {
        UIViewController *presentingVC = self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            if ([presentingVC isKindOfClass:[GuideViewController class]]) {
                [presentingVC dismissViewControllerAnimated:YES completion:nil];
            } else if ([presentingVC isKindOfClass:[GPAViewController class]]) {
                //
            }
        }];
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    [unameField resignFirstResponder];
    [passwdField resignFirstResponder];
    if ([self moved])
    {
        [self adjustViewAnimation];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)textFieldBeginEditing:(id)sender
{
    if (![self moved] && self.view.frame.size.width == 320) {
        [self adjustViewAnimation];
    }
}

- (IBAction)textFieldEndEditing:(id)sender
{
    if ([self moved] && self.view.frame.size.width == 320) {
        [self adjustViewAnimation];
    }
}

- (void)adjustViewAnimation {
    POPBasicAnimation *viewAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    CGPoint point = self.view.center;
    CGFloat halfHeight = 0.5*[[UIScreen mainScreen] bounds].size.height;
    if ([self moved]) {
        viewAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, halfHeight)];
    } else {
        viewAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, halfHeight - 80)];
    }
    [self.view.layer pop_addAnimation:viewAnim forKey:@"viewAnimation"];
}

- (BOOL)moved {
    CGPoint point = self.view.center;
    CGFloat halfHeight = 0.5*[[UIScreen mainScreen] bounds].size.height;
    if (point.y == halfHeight) {
        return NO;
    } else {
        return YES;
    }
}


@end
