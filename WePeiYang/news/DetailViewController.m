//
//  DetailViewController.m
//  News
//
//  Created by Qin Yubo on 13-10-13.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "DetailViewController.h"
#import "data.h"
#import "Social/Social.h"
#import "AFNetworking.h"
#import "wpyStringProcessor.h"
#import "SVProgressHUD.h"
#import "OpenInSafariActivity.h"
#import "JSONKit.h"
#import "WePeiYang-Swift.h"

#define DEVICE_IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface DetailViewController ()

@end

@implementation DetailViewController

{
    NSString *detailContent;
}

@synthesize webView;
@synthesize detailId;
@synthesize detailTitle;

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
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.title = detailTitle;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    // pragma mark - 等全局原生NavigationBar之后再取消注释
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.navigationController.hidesBarsOnSwipe = YES;
    }
     */
    
    UIBarButtonItem *openInSafari = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = openInSafari;
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ctype": @"news",
                                 @"index": detailId,
                                 @"platform": @"ios",
                                 @"version": [data shareInstance].appVersion};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processDetailData:[operation.responseString objectFromJSONString]];
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取新闻失败T^T"];
    }];
}

- (void)processDetailData:(NSDictionary *)contentDic
{
    NSURL *baseURL = [[NSURL alloc]initWithString:@"http://mynews.twtstudio.com/newspic/picture/"];
    if ([contentDic count] > 0) {
        detailContent = [contentDic objectForKey:@"content"];
    }
    
    [self.webView loadHTMLString:[wpyStringProcessor convertToBootstrapHTMLWithContent:detailContent] baseURL:baseURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)share {
    NSArray *activityItems;
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",self.detailId]];
    activityItems = @[shareURL];
    
    // Presentation Controller
    
    OpenInSafariActivity *openInSafariActivity = [[OpenInSafariActivity alloc]init];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[openInSafariActivity]];
    
    if (DEVICE_IS_IOS8) {
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        
        UIPopoverPresentationController *popPC = activityViewController.popoverPresentationController;
        popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPC.barButtonItem = self.navigationItem.rightBarButtonItem;
        popPC.delegate = self;
        
        // Not working on iOS 7
    }
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

@end
