//
//  NoticeDetailViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-12.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "data.h"
#import <ShareSDK/ShareSDK.h>
#import "AFNetworking.h"
#import "wpyStringProcessor.h"
#import "CSNotificationView.h"

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
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    NSDictionary *parameters = @{@"ctype":@"news",@"index":noticeId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealWithReceivedData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"无法获取公告T^T"];
    }];
    
    /*
    NSString *body = [NSString stringWithFormat:@"ctype=news&index=%@",noticeId];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if ([[dic objectForKey:@"error"]boolValue]==true)
            {
                
            }
            else
            {
                [self dealWithReceivedData:[dic objectForKey:@"content"]];
            }
        }
    }];*/
}

- (void)dealWithReceivedData:(NSDictionary *)contentDic
{
    NSString *content;
    if ([contentDic count]>0)
    {
        content = [contentDic objectForKey:@"content"];
    }
    
    NSURL *baseURL = [[NSURL alloc]initWithString:@"http://mynews.twtstudio.com/newspic/picture/"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"];
    [wpyStringProcessor convertToWebViewByString:content withFinishCallbackBlock:^(NSString *load){
        [self.webView loadHTMLString:load baseURL:baseURL];
    }];
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
        [self shareNotice];
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

/*
- (void)shareByIOS
{
    NSArray *activityItems;
    NSString *urlStr = [NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",[data shareInstance].noticeId];
    NSString *title = [data shareInstance].noticeTitle;
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ 地址：%@",title,urlStr];
    activityItems = @[shareString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}
 */

- (void)shareNotice
{
    NSString *urlStr = [NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",[data shareInstance].noticeId];
    NSString *title = [data shareInstance].noticeTitle;
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ 地址：%@",title,urlStr];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareString
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:nil
                                                title:shareString
                                                  url:urlStr
                                          description:@"分享自微北洋"
                                            mediaType:SSPublishContentMediaTypeNews];
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession, ShareTypeWeixiTimeline, ShareTypeRenren, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeQQ, ShareTypeQQSpace, ShareTypeFacebook, ShareTypeTwitter, nil];
    NSArray *oneKeyShareList = shareList;
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil      //分享视图标题
                                                              oneKeyShareList:oneKeyShareList           //一键分享菜单
                                                               qqButtonHidden:NO                               //QQ分享按钮是否隐藏
                                                        wxSessionButtonHidden:NO                   //微信好友分享按钮是否隐藏
                                                       wxTimelineButtonHidden:NO                 //微信朋友圈分享按钮是否隐藏
                                                         showKeyboardOnAppear:NO                  //是否显示键盘
                                                            shareViewDelegate:nil                            //分享视图委托
                                                          friendsViewDelegate:nil                          //好友视图委托
                                                        picViewerViewDelegate:nil];                    //图片浏览视图委托
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
    
    
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
    
    [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"公告收藏成功！"];
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
