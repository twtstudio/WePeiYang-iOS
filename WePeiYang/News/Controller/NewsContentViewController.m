//
//  NewsContentViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/12/7.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "NewsContentViewController.h"
#import "NewsCommentViewController.h"
#import "FrontEndProcessor.h"
#import "twtSDK.h"
#import "NewsContent.h"
#import "MJExtension.h"
#import "MsgDisplay.h"
#import "OpenInSafariActivity.h"
#import "WebViewJavascriptBridge.h"
#import <SafariServices/SafariServices.h>
#import "IDMPhotoBrowser.h"
#import "WeChatMomentsActivity.h"
#import "WeChatSessionActivity.h"

@interface NewsContentViewController ()<UIWebViewDelegate, IDMPhotoBrowserDelegate>

@property WebViewJavascriptBridge *bridge;

@end

@implementation NewsContentViewController {
    NSArray *commentArr;
}

@synthesize contentWebView;
@synthesize newsData;
@synthesize bridge;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = newsData.subject;
    contentWebView.delegate = self;
    commentArr = [[NSArray alloc] init];
    
    bridge = [WebViewJavascriptBridge bridgeForWebView:contentWebView];
    [bridge registerHandler:@"imgCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self presentHDImageWithURL:data];
    }];
    
    [twtSDK getNewsContentWithIndex:newsData.index success:^(NSURLSessionDataTask *task, id responseObject) {
        [self processNewsContent:[NewsContent mj_objectWithKeyValues:responseObject[@"data"]]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MsgDisplay showErrorMsg:error.localizedDescription];
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
    WeChatMomentsActivity *wechatMoments = [[WeChatMomentsActivity alloc] init];
    WeChatSessionActivity *wechatSession = [[WeChatSessionActivity alloc] init];
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[openInSafari, wechatMoments, wechatSession]];
    activityController.modalPresentationStyle = UIModalPresentationPopover;
    activityController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)presentCommentViewController:(id)sender {
    NewsCommentViewController *commentVC = [[NewsCommentViewController alloc] init];
    commentVC.commentArray = commentArr;
    commentVC.index = newsData.index;
    [self.navigationController showViewController:commentVC sender:nil];
}

#pragma mark - Private method

- (void)processNewsContent:(NewsContent *)content {
    commentArr = content.comments;
    [contentWebView loadHTMLString:[FrontEndProcessor convertToBootstrapHTMLWithNewsContent:content] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
}

- (void)presentHDImageWithURL:(NSString *)url {
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:@[[NSURL URLWithString:url]]];
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = NO;
    browser.delegate = self;
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            SFSafariViewController *SafariVC = [[SFSafariViewController alloc] initWithURL:[request URL]];
            [self presentViewController:SafariVC animated:YES completion:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[request URL]];
        }
        return NO;
    } else {
        return YES;
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
