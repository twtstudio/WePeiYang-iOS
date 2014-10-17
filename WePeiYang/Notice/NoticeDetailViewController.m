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

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

{
    UIAlertView *waitingAlert;
}

@synthesize webView;
//@synthesize response;

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
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = [data shareInstance].noticeTitle;
    NSString *noticeId = [data shareInstance].noticeId;
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet)];
    [self.navigationItem setRightBarButtonItem:share];
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    NSDictionary *parameters = @{@"ctype":@"news",@"index":noticeId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
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
    
    [self.webView loadHTMLString:[wpyStringProcessor convertToBootstrapHTMLWithContent:content] baseURL:baseURL];
    self.webView.scalesPageToFit = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[data shareInstance].noticeTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"添加到收藏夹",@"在Safari中打开", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex])
    {
        nil;
    }
    else if (buttonIndex == 0)
    {
        [self share];
    }
    else if (buttonIndex == 1)
    {
        [self addToFav];
    }
    else if (buttonIndex == 2)
    {
        [self openInSafari];
    }
}

- (void)share
{
    NSArray *activityItems;
    NSString *urlStr = [NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",[data shareInstance].noticeId];
    NSString *title = [data shareInstance].noticeTitle;
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ 地址：%@",title,urlStr];
    activityItems = @[shareString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}


- (void)openInSafari
{
    NSString *urlStr = [NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",[data shareInstance].noticeId];
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
    [newDic setObject:[data shareInstance].noticeTitle forKey:@"title"];
    [newDic setObject:[data shareInstance].noticeId forKey:@"id"];
    
    [noticeFavDic setObject:newDic forKey:[data shareInstance].noticeTitle];
    [noticeFavDic writeToFile:plistPath atomically:YES];
    
    [SVProgressHUD showSuccessWithStatus:@"公告收藏成功！"];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:232/255.0f green:159/255.0f blue:0/255.0f alpha:1.0f];
        }
    }];
}

@end
