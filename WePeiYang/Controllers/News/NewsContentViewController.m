//
//  NewsContentViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/12/7.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "NewsContentViewController.h"
#import "FrontEndProcessor.h"
#import "twtSDK.h"
#import "NewsContent.h"
#import "MJExtension.h"
#import "MsgDisplay.h"
#import "OpenInSafariActivity.h"
#import "WeChatMomentsActivity.h"
#import "WeChatSessionActivity.h"

@interface NewsContentViewController ()

@end

@implementation NewsContentViewController

@synthesize contentWebView;
@synthesize newsData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = newsData.subject;
    
    [twtSDK getNewsContentWithIndex:newsData.index success:^(NSURLSessionDataTask *task, id responseObject) {
        [self processNewsContent:[NewsContent mj_objectWithKeyValues:responseObject[@"data"]]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MsgDisplay showErrorMsg:error.description];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)shareContent:(id)sender {
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@", newsData.index]];
    NSArray *activityItems = @[shareURL, newsData.subject];
    OpenInSafariActivity *openInSafari = [[OpenInSafariActivity alloc] init];
    WeChatMomentsActivity *wxMoment = [[WeChatMomentsActivity alloc] init];
    WeChatSessionActivity *wxSession = [[WeChatSessionActivity alloc] init];
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[openInSafari, wxMoment, wxSession]];
    activityController.modalPresentationStyle = UIModalPresentationPopover;
    activityController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - Private method

- (void)processNewsContent:(NewsContent *)content {
    [contentWebView loadHTMLString:[FrontEndProcessor convertToBootstrapHTMLWithNewsContent:content] baseURL:nil];
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
