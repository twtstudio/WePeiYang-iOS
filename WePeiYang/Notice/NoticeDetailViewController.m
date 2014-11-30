//
//  NoticeDetailViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-12.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "data.h"
#import "AFNetworking.h"
#import "wpyStringProcessor.h"
#import "SVProgressHUD.h"
#import "WePeiYang-Swift.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

{
    UIAlertView *waitingAlert;
    UIWebView *webView;
    NSString *htmlHeight;
}

@synthesize scrollView;
@synthesize noticeId;
@synthesize noticeTitle;

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
    self.title = noticeTitle;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    webView = [[UIWebView alloc]init];
    webView.scrollView.scrollEnabled = NO;
    
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet)];
    [self.navigationItem setRightBarButtonItem:share];
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    NSDictionary *parameters = @{@"ctype":@"news",@"index":noticeId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealWithReceivedData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"无法获取公告T^T"];
        [SVProgressHUD dismiss];
    }];
}

- (void)dealWithReceivedData:(NSDictionary *)contentDic
{
    NSString *content;
    if ([contentDic count]>0)
    {
        content = [contentDic objectForKey:@"content"];
    }
    
    NSURL *baseURL = [[NSURL alloc]initWithString:@"http://mynews.twtstudio.com/newspic/picture/"];
    
    [webView loadHTMLString:[wpyStringProcessor convertToBootstrapHTMLWithContent:content] baseURL:baseURL];
    webView.scalesPageToFit = YES;
    
    // Left Uncompleted
    // UIScrollView 内嵌 UIWebView
    // UIWebView 的自适应高度问题
    
    webView.frame = CGRectMake(0, 140, [[UIScreen mainScreen] bounds].size.width, 2200);
    scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 140+2200);
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:webView];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openActionSheet
{
    wpyActionSheet *actionSheet = [[wpyActionSheet alloc]initWithTitle:@"更多"];
    
    [actionSheet addButtonWithTitle:@"分享" image:nil type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self share];
    }];
    
    [actionSheet addButtonWithTitle:@"收藏" image:nil type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self addToFav];
    }];
    
    [actionSheet addButtonWithTitle:@"在 Safari 中打开" image:nil type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self openInSafari];
    }];
    
    [actionSheet show];
}

- (void)share
{
    NSArray *activityItems;
    NSString *urlStr = [NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",noticeId];
    NSString *title = noticeTitle;
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ 地址：%@",title,urlStr];
    activityItems = @[shareString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}


- (void)openInSafari
{
    NSString *urlStr = [NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",noticeId];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication]openURL:url];
}

- (void)addToFav
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"noticeFavData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSMutableDictionary *noticeFavDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    if (noticeFavDic == nil)
    {
        noticeFavDic = [[NSMutableDictionary alloc]init];
    }
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
    [newDic setObject:noticeTitle forKey:@"title"];
    [newDic setObject:noticeId forKey:@"id"];
    
    [noticeFavDic setObject:newDic forKey:noticeTitle];
    [noticeFavDic writeToFile:plistPath atomically:YES];
    
    [SVProgressHUD showSuccessWithStatus:@"公告收藏成功！"];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
