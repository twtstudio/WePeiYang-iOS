//
//  ReceivedNotificationViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-10.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "ReceivedNotificationViewController.h"
#import "data.h"
#import <ShareSDK/ShareSDK.h>
#import "wpyWebConnection.h"
#import "wpyStringProcessor.h"

@interface ReceivedNotificationViewController ()

@end

@implementation ReceivedNotificationViewController

{
    UIAlertView *waitingAlert;
    NSString *detailContent;
}

@synthesize titleLabel;
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
    NSString *detailTitle = [data shareInstance].newsTitle;
    NSString *detailId = [data shareInstance].newsId;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    titleLabel.text = [detailTitle substringWithRange:NSMakeRange(0, 10)];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    NSString *body = [NSString stringWithFormat:@"ctype=news&index=%@",detailId];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if (![[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
            {
                
            }
            else
            {
                [self dealWithReceivedData:[dic objectForKey:@"content"]];
            }
        }
    }];

}

- (void)dealWithReceivedData:(NSDictionary *)contentDic
{
    //图片的BaseURL
    NSURL *baseURL = [[NSURL alloc]initWithString:@"http://mynews.twtstudio.com/newspic/picture/"];
    if ([contentDic count]>0)
    {
        detailContent = [contentDic objectForKey:@"content"];
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"];
    [wpyStringProcessor convertToWebViewByString:detailContent withFinishCallbackBlock:^(NSString *load){
        [self.webView loadHTMLString:load baseURL:baseURL];
    }];
    self.webView.scalesPageToFit = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToFormerView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)moreBtn:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[data shareInstance].newsTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"添加到收藏",@"在Safari中打开", nil];
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
        [self collection];
    }
    else if (buttonIndex == 2)
    {
        [self openInSafari];
    }
}

- (void)openInSafari
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",[data shareInstance].newsId]];
    [[UIApplication sharedApplication]openURL:url];
}

- (void)share
{
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    NSString *urlStr = [NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",[data shareInstance].newsId];
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession, ShareTypeWeixiTimeline, ShareTypeRenren, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeQQ, ShareTypeQQSpace, ShareTypeFacebook, ShareTypeTwitter, nil];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@ %@",[data shareInstance].newsTitle,urlStr]
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:nil
                                                title:[NSString stringWithFormat:@"【天外天新闻】%@",[data shareInstance].newsTitle]
                                                  url:urlStr
                                          description:@"分享自微北洋"
                                            mediaType:SSPublishContentMediaTypeNews];
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

- (void)shareByIOS
{
    NSArray *activityItems;
    NSString *detailTitle = [data shareInstance].newsTitle;
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ 地址：%@",detailTitle,[NSString stringWithFormat:@"http://news.twt.edu.cn/?c=default&a=pernews&id=%@",[data shareInstance].newsId]];
    activityItems = @[shareString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)collection
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"noticeFavData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSMutableDictionary *collectionDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    if (collectionDic == nil)
    {
        collectionDic = [[NSMutableDictionary alloc]init];
    }
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
    [newDic setObject:[data shareInstance].newsTitle forKey:@"title"];
    [newDic setObject:[data shareInstance].newsId forKey:@"id"];
    
    [collectionDic setObject:newDic forKey:[data shareInstance].newsTitle];
    [collectionDic writeToFile:plistPath atomically:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"公告平台" message:@"通知收藏成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
}


@end
