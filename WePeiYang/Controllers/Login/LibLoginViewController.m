//
//  LibLoginViewController.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "LibLoginViewController.h"
#import "data.h"
#import "SVProgressHUD.h"
#import "MsgDisplay.h"
#import "AccountManager.h"
#import "twtLoginViewController.h"

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
        NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                     @"token":[data shareInstance].userToken,
                                     @"libuname":username,
                                     @"libpasswd":password,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        [AccountManager bindLibWithParameters:parameters success:^() {
            isLogingIn = NO;
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessfully object:LoginSuccessfully];
                [MsgDisplay showSuccessMsg:@"绑定图书馆账号成功！"];
            }];
        } failure:^(NSInteger statusCode, NSString *errorStr) {
            if (statusCode == 401) {
                [MsgDisplay showErrorMsg:@"账号或密码错误哦QAQ"];
            } else {
                [MsgDisplay showErrorMsg:errorStr];
            }
            isLogingIn = NO;
        }];
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
