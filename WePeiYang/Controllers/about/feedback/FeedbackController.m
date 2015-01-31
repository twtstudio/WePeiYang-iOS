//
//  FeedbackController.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "FeedbackController.h"
#import "FeedbackForm.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "data.h"

@interface FeedbackController ()

@end

@implementation FeedbackController

@synthesize tableView;
@synthesize formController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    formController = [[FXFormController alloc]init];
    formController.tableView = tableView;
    formController.delegate = self;
    formController.form = [[FeedbackForm alloc]init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc]init];
    NSString *backIconPath = [[NSBundle mainBundle]pathForResource:@"backForNav@2x" ofType:@"png"];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithContentsOfFile:backIconPath] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [navigationBar pushNavigationItem:navigationItem animated:YES];
    [navigationItem setTitle:@"发送反馈"];
    [navigationItem setLeftBarButtonItem:backBarBtn];
    [self.view addSubview:navigationBar];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //reload the table
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitFeedback:(UITableViewCell<FXFormFieldCell> *)cell {
    FeedbackForm *form = cell.field.form;
    
    NSString *email = form.contact;
    NSString *deviceModel = form.deviceModel;
    NSString *deviceVersion = form.deviceVersion;
    NSString *feedback = form.advices;
    
    NSString *url = @"http://push-mobile.twtapps.net/suggest/wepeiyang";
    NSDictionary *parameters = @{@"email":email,
                                 @"content":feedback,
                                 @"info":[NSString stringWithFormat:@"%@,%@",deviceModel,deviceVersion],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [SVProgressHUD showSuccessWithStatus:@"感谢您的反馈！"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发送反馈失败，请稍后再试"];
    }];
}

- (void)backToHome {
    [self.navigationController popViewControllerAnimated:YES];
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
