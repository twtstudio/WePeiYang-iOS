//
//  JobDetailViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "JobDetailViewController.h"
#import "data.h"
#import <ShareSDK/ShareSDK.h>
#import "wpyWebConnection.h"
#import "wpyStringProcessor.h"
#import "CSNotificationView.h"

@interface JobDetailViewController ()

@end

@implementation JobDetailViewController

{
    NSString *detail;
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
    
    //self.textView.text = @"";
    
    self.title = [data shareInstance].jobTitle;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet:)];
    [self.navigationItem setRightBarButtonItem:share];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    NSString *body = [NSString stringWithFormat:@"ctype=job&index=%@",[data shareInstance].jobId];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if (![[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
            {
                
            }
            else
            {
                NSDictionary *contentDic = [dic objectForKey:@"content"];
                [self dealWithReceivedData:contentDic];
            }
        }
    }];
}

- (void)dealWithReceivedData:(NSDictionary *)contentDic
{
    detail = [contentDic objectForKey:@"content"];
    /*
    [wpyStringProcessor convertToTextViewByString:detail withFinishCallbackBlock:^(NSString *filtered){
        self.textView.text = filtered;
    }];
     */
    [webView loadHTMLString:detail baseURL:[NSURL URLWithString:@""]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[data shareInstance].jobTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"添加到收藏夹",@"在Safari中打开", nil];
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
        [self shareJobInfo];
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

- (void)addToFav
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"jobFavData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSMutableDictionary *jobFavDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    if (jobFavDic == nil)
    {
        jobFavDic = [[NSMutableDictionary alloc]init];
    }
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
    [newDic setObject:[data shareInstance].jobCorp forKey:@"corp"];
    [newDic setObject:[data shareInstance].jobDate forKey:@"date"];
    [newDic setObject:[data shareInstance].jobId forKey:@"id"];
    [newDic setObject:[data shareInstance].jobTitle forKey:@"title"];
    
    [jobFavDic setObject:newDic forKey:[data shareInstance].jobTitle];
    [jobFavDic writeToFile:plistPath atomically:YES];
    
    [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"就业资讯收藏成功！"];
}

- (void)shareByIOS
{
    NSArray *activityItems;
    NSString *urlStr = [NSString stringWithFormat:@"http://job.tju.edu.cn/zhaopinxinxi_detail.php?id=%@",[data shareInstance].jobId];
    NSString *title = [data shareInstance].jobTitle;
    NSString *corp = [data shareInstance].jobCorp;
    NSString *date = [data shareInstance].jobDate;
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ %@ %@ 地址：%@",title,corp,date,urlStr];
    activityItems = @[shareString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (void)shareJobInfo
{
    NSString *urlStr = [NSString stringWithFormat:@"http://job.tju.edu.cn/zhaopinxinxi_detail.php?id=%@",[data shareInstance].jobId];
    NSString *title = [data shareInstance].jobTitle;
    NSString *corp = [data shareInstance].jobCorp;
    NSString *date = [data shareInstance].jobDate;

    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ %@ %@ 地址：%@",title,corp,date,urlStr];
    
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
    NSString *urlStr = [NSString stringWithFormat:@"http://job.tju.edu.cn/zhaopinxinxi_detail.php?id=%@",[data shareInstance].jobId];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication]openURL:url];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:149/255.0f green:82/255.0f blue:235/255.0f alpha:1.0f];
        }
    }];
}

@end
