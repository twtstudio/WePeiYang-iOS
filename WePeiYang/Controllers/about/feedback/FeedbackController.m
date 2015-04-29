//
//  FeedbackController.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/1/22.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "FeedbackController.h"
#import "FeedbackForm.h"
#import "MsgDisplay.h"
#import "AFNetworking.h"
#import "data.h"
#import "twtAPIs.h"

@interface FeedbackController ()

@end

@implementation FeedbackController {
    UIAlertView *successAlert;
}

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
    
    NSString *url = [twtAPIs sendFeedback];
    NSDictionary *parameters = @{@"email":email,
                                 @"content":feedback,
                                 @"info":[NSString stringWithFormat:@"%@,%@",deviceModel,deviceVersion],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        successAlert = [[UIAlertView alloc]initWithTitle:@"反馈成功" message:@"感谢您的反馈！" delegate:self cancelButtonTitle:@"平身" otherButtonTitles:nil];
        [successAlert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MsgDisplay showErrorMsg:@"发送反馈失败，请稍后再试"];
    }];
}

- (void)backToHome {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == successAlert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
