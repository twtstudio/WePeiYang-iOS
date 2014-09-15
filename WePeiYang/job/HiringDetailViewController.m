//
//  HiringDetailViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-5-9.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "HiringDetailViewController.h"
#import "AFNetworking.h"
#import <ShareSDK/ShareSDK.h>
#import "data.h"
#import "SVProgressHUD.h"

@interface HiringDetailViewController ()

@end

@implementation HiringDetailViewController

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
    self.title = [data shareInstance].hiringTitle;
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareInfo)];
    [self.navigationItem setRightBarButtonItem:share];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    NSDictionary *parameters = @{@"ctype":@"fair",
                                 @"index":[data shareInstance].hiringId,
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processContentDic:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    /*
    NSString *body = [NSString stringWithFormat:@"ctype=fair&index=%@",[data shareInstance].hiringId];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if ([[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
            {
                NSDictionary *contentDic = [dic objectForKey:@"content"];
                [self processContentDic:contentDic];
            }
            else
            {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"服务器出错了QAQ"];
            }
        }
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
        }
    }];
    */
}

- (void)processContentDic:(NSDictionary *)dic
{
    [webView loadHTMLString:[dic objectForKey:@"content"] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareInfo
{
    NSString *shareStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[data shareInstance].hiringTitle,[data shareInstance].hiringCorp,[data shareInstance].hiringDate,[data shareInstance].hiringTime,[data shareInstance].hiringPlace];
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession, ShareTypeWeixiTimeline, ShareTypeRenren, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeQQ, ShareTypeQQSpace, ShareTypeFacebook, ShareTypeTwitter, nil];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareStr
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:nil
                                                title:[data shareInstance].hiringTitle
                                                  url:nil
                                          description:@"分享自微北洋"
                                            mediaType:SSPublishContentMediaTypeText];
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

@end
