//
//  LibLoginViewController.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "LibLoginViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "data.h"
#import "twtAPIs.h"

@interface LibLoginViewController ()

@end

@implementation LibLoginViewController {
    BOOL isLogingIn;
    UIAlertView *successAlert;
}

@synthesize tableView;
@synthesize formController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isLogingIn = NO;
    // Do any additional setup after loading the view.
    tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    formController = [[FXFormController alloc]init];
    formController.tableView = tableView;
    formController.delegate = self;
    formController.form = [[LibLoginForm alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login {
    if (isLogingIn == YES) {
        return;
    }
    
    isLogingIn = YES;
    
    LibLoginForm *form = formController.form;
    NSString *username = form.username.stringValue;
    NSString *password = form.password;
    
    if ([username isEqualToString:@""] || [password  isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
        NSString *url = [twtAPIs twtAPIBindLib];
        NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                     @"token":[data shareInstance].userToken,
                                     @"libuname":username,
                                     @"libpasswd":password,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"绑定图书馆账号成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [successAlert show];
            [data shareInstance].libLogin = @"Changed";
            
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
            [userDefaults setBool:YES forKey:@"bindLib"];
            
            isLogingIn = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSInteger statusCode = operation.response.statusCode;
            
            if (statusCode == 401) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"账号或密码错误哦QAQ" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                [SVProgressHUD showErrorWithStatus:@"绑定图书馆帐号失败T^T"];
            }
            isLogingIn = NO;
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == successAlert) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
