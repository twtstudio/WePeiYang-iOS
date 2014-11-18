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
#import "AFNetworking.h"
#import "SVProgressHUD.h"

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
        NSString *url = @"http://push-mobile.twtapps.net/user/bindTju";
        NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                     @"token":[data shareInstance].userToken,
                                     @"tjuuname":username,
                                     @"tjupasswd":password,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"绑定账号成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [successAlert show];
            [data shareInstance].gpaLoginStatus = @"Changed";
            
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
            [userDefaults setBool:YES forKey:@"bindTju"];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 401) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                [SVProgressHUD showErrorWithStatus:@"绑定办公网失败"];
            }
        }];
    }
    [loginBtn setUserInteractionEnabled:YES];
}

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
