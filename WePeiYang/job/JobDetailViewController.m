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
#import "WePeiYang-Swift.h"

@interface JobDetailViewController ()

@end

@implementation JobDetailViewController

{
    NSString *detail;
    UIAlertView *waitingAlert;
}

@synthesize webView;
@synthesize jobCorp;
@synthesize jobDate;
@synthesize jobId;
@synthesize jobTitle;

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
    
    self.title = jobTitle;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet:)];
    [self.navigationItem setRightBarButtonItem:share];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/detail";
    NSDictionary *body = @{@"ctype":@"job",
                           @"index":jobId,
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
    wpyActionSheet *actionSheet = [[wpyActionSheet alloc]initWithTitle:@"更多"];
    
    [actionSheet addButtonWithTitle:@"分享" image:[UIImage imageNamed: @"shareInSheet.png"] type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self share];
    }];
    
    [actionSheet addButtonWithTitle:@"收藏" image:[UIImage imageNamed: @"addToFav.png"] type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self addToFav];
    }];
    
    [actionSheet addButtonWithTitle:@"在 Safari 中打开" image:[UIImage imageNamed: @"openInSafari.png"] type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self openInSafari];
    }];
    
    [actionSheet show];
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
    [newDic setObject:jobCorp forKey:@"corp"];
    [newDic setObject:jobDate forKey:@"date"];
    [newDic setObject:jobId forKey:@"id"];
    [newDic setObject:jobTitle forKey:@"title"];
    
    [jobFavDic setObject:newDic forKey:jobTitle];
    [jobFavDic writeToFile:plistPath atomically:YES];
    
    [SVProgressHUD showSuccessWithStatus:@"就业资讯收藏成功！"];
}

- (void)share
{
    NSArray *activityItems;
    NSString *urlStr = [NSString stringWithFormat:@"http://job.tju.edu.cn/zhaopinxinxi_detail.php?id=%@",jobId];
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ %@ %@",jobTitle,jobCorp,jobDate];
    NSURL *shareURL = [NSURL URLWithString:urlStr];
    activityItems = @[shareString, shareURL];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (void)openInSafari
{
    NSString *urlStr = [NSString stringWithFormat:@"http://job.tju.edu.cn/zhaopinxinxi_detail.php?id=%@",jobId];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication]openURL:url];
}

@end
