//
//  HiringDetailViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-5-9.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "HiringDetailViewController.h"
#import "AFNetworking.h"
#import "data.h"
#import "SVProgressHUD.h"

@interface HiringDetailViewController ()

@end

@implementation HiringDetailViewController

@synthesize webView;

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
    self.title = [data shareInstance].hiringTitle;
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareInfo)];
    [self.navigationItem setRightBarButtonItem:share];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    NSDictionary *parameters = @{@"ctype":@"fair",
                                 @"index":[data shareInstance].hiringId,
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processContentDic:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)processContentDic:(NSDictionary *)dic
{
    [webView loadHTMLString:[dic objectForKey:@"content"] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareInfo
{
    NSString *shareStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[data shareInstance].hiringTitle,[data shareInstance].hiringCorp,[data shareInstance].hiringDate,[data shareInstance].hiringTime,[data shareInstance].hiringPlace];
    NSArray *activityItems = @[shareStr];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
