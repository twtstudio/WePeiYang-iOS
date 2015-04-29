//
//  JobDetailViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "JobDetailViewController.h"
#import "data.h"
#import "ContentDataManager.h"
#import "wpyStringProcessor.h"
#import "MsgDisplay.h"
#import "OpenInSafariActivity.h"
#import "WeChatMomentsActivity.h"
#import "WeChatSessionActivity.h"

@interface JobDetailViewController ()

@end

@implementation JobDetailViewController

{
    NSString *detail;
    UIAlertView *waitingAlert;
}

@synthesize webView;
@synthesize jobCorp;
@synthesize jobDate;
@synthesize jobId;
@synthesize jobTitle;

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
    
    self.title = jobTitle;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    [self.navigationItem setRightBarButtonItem:share];
    
    NSDictionary *body = @{@"ctype":@"job",
                           @"index":jobId,
                           @"platform":@"ios",
                           @"version":[data shareInstance].appVersion};
    [ContentDataManager getDetailDataWithParameters:body success:^(id responseObject) {
        [self dealWithReceivedData:responseObject];
    } failure:^(NSString *error) {
        [MsgDisplay showErrorMsg:error];
    }];
    
    webView.delegate = self;
}

- (void)dealWithReceivedData:(NSDictionary *)contentDic
{
    detail = [contentDic objectForKey:@"content"];
    [webView loadHTMLString:[wpyStringProcessor convertToBootstrapHTMLWithContent:detail] baseURL:[NSURL URLWithString:@""]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)share
{
    NSArray *activityItems;
    NSString *urlStr = [NSString stringWithFormat:@"http://job.tju.edu.cn/zhaopinxinxi_detail.php?id=%@",jobId];
    // UIImage *shareImg = [self getImageFromView:webView.scrollView.subviews[0]];
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ %@ %@",jobTitle,jobCorp,jobDate];
    NSURL *shareURL = [NSURL URLWithString:urlStr];
    activityItems = @[shareURL, shareString];
    
    OpenInSafariActivity *openInSafariActivity = [[OpenInSafariActivity alloc]init];
    WeChatMomentsActivity *wxMoments = [[WeChatMomentsActivity alloc] init];
    WeChatSessionActivity *wxSession = [[WeChatSessionActivity alloc] init];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[openInSafariActivity, wxMoments, wxSession]];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    } else {
        return YES;
    }
}

@end
