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
#import "wpyStringProcessor.h"
#import "wpyDeviceStatus.h"
#import "MsgDisplay.h"
#import "OpenInSafariActivity.h"
#import "ContentDataManager.h"

#define DEVICE_IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface DetailViewController ()

@end

@implementation DetailViewController {
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
    
    [MsgDisplay showLoading];
    
    NSDictionary *parameters = @{@"ctype": @"news",
                                 @"index": detailId,
                                 @"platform": @"ios",
                                 @"version": [data shareInstance].appVersion};
    [ContentDataManager getDetailDataWithParameters:parameters success:^(id responseObject) {
        [self processDetailData:responseObject];
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [MsgDisplay dismiss];
        
    } failure:^(NSString *error) {
        [MsgDisplay dismiss];
        [MsgDisplay showErrorMsg:error];
        
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
    // UIImage *shareImg = [wpyDeviceStatus getImageFromView:webView.scrollView.subviews[0]];
    
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
