//
//  GPALoginViewController.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "GPALoginViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "data.h"

@interface GPALoginViewController () <UIAlertViewDelegate>

@end

@implementation GPALoginViewController {
    UIAlertView *blankAlert;
    UIAlertView *waitingAlert;
    UIAlertView *successAlert;
    
    BOOL isLogingIn;
}

@synthesize tableView;
@synthesize formController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLogingIn = NO;
    // Do any additional setup after loading the view.
    tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    formController = [[FXFormController alloc]init];
    formController.tableView = tableView;
    formController.delegate = self;
    formController.form = [[GPALoginForm alloc]init];
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
    
    GPALoginForm *form = formController.form;
    NSString *username = form.username.stringValue;
    NSString *password = form.password;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        blankAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [blankAlert show];
    } else {
        NSString *url = @"http://push-mobile.twtapps.net/user/bindTju";
        NSDictionary *parameters = @{@"id":[data shareInstance].userId,
                                     @"token":[data shareInstance].userToken,
                                     @"tjuuname":username,
                                     @"tjupasswd":password,
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            isLogingIn = NO;
            
            successAlert = [[UIAlertView alloc]initWithTitle:@"成功" message:@"绑定账号成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [successAlert show];
            
            [data shareInstance].gpaLoginStatus = @"Changed";
            
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
            [userDefaults setBool:YES forKey:@"bindTju"];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSInteger statusCode = operation.response.statusCode;
            if (statusCode == 401) {
                isLogingIn = NO;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"用户名或密码错误！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                [SVProgressHUD showErrorWithStatus:@"绑定办公网失败"];
                isLogingIn = NO;
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == successAlert) {
        [self dismissViewControllerAnimated:YES completion:^{
            [data shareInstance].gpaLoginStatus = @"Changed";
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
