//
//  JobDetailViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "JobDetailViewController.h"
#import "data.h"
#import "AFNetworking.h"
#import "wpyStringProcessor.h"
#import "SVProgressHUD.h"

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
    NSDictionary *body = @{@"ctype":@"job",
                           @"index":[data shareInstance].jobId,
                           @"platform":@"ios",
                           @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealWithReceivedData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取详情失败T^T"];
    }];
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
    
    [SVProgressHUD showSuccessWithStatus:@"就业资讯收藏成功！"];
}

- (void)share
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
