//
//  LAFoundQueryDetailViewController.m
//  LostAndFound
//
//  Created by 马骁 on 14-4-15.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import "LAFound_QueryDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "CSNotificationView.h"

@interface LAFound_QueryDetailViewController ()

@end

@implementation LAFound_QueryDetailViewController
{
    NSDictionary *_dic;
    NSMutableArray *_tempCollectionArray;
    NSString *shareContent;
}

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
    
    self.title = @"详细信息";
    
    self.titleTextField.text = [_dic valueForKey:@"title"];
    self.placeTextField.text = [_dic valueForKey:@"place"];
    self.timeTextField.text = [_dic valueForKey:@"time"];
    self.nameTextField.text = [_dic valueForKey:@"name"];
    self.phoneTextField.text = [_dic valueForKey:@"phone"];
    self.contentTextView.text = [_dic valueForKey:@"content"];
    self.updataDateTextField.text = [_dic valueForKey:@"created_at"];

    //self.contentTextView.layer.borderWidth = 1.0;
    //self.contentTextView.layer.cornerRadius = 5.0;
    //self.contentTextView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.15].CGColor;
    
    if (!self.isCollectionDetail) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    //NSTimer *timerforScrollView;
    //timerforScrollView = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(forScrollView) userInfo:nil repeats:NO];
}
/*
- (void)forScrollView{
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-40)];
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LAFound_CollectionViewController:(LAFound_CollectionViewController *)cVC ShowDetailByDataDic:(NSDictionary *)dic
{
    _dic = dic;
}

- (void)LAFound_QueryListViewController:(LAFound_QueryListViewController *)qdVC ShowDetailByDataDic:(NSDictionary *)dic
{
    _dic = dic;
}

#pragma mark 收集


- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"LAFound_Collection.plist"];
}



- (void)collectItemAction{
    [self loadDataArray];
    if (![_tempCollectionArray containsObject:_dic]) {
        [_tempCollectionArray addObject:_dic];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:_tempCollectionArray forKey:@"LAFound_Collection"];
        [archiver finishEncoding];
        [data writeToFile:[self dataFilePath] atomically:YES];
    }
    [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"添加收藏成功！"];
}

- (void)loadDataArray
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _tempCollectionArray = [unArchiver decodeObjectForKey:@"LAFound_Collection"];
        [unArchiver finishDecoding];
    } else {
        _tempCollectionArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

#pragma mark actionSheet
- (void)showActionSheet
{
    //    actionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"添加到收藏夹", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self collectItemAction];
    }
    else if (buttonIndex == 0) {
        [self getShareInfoString];
    }
}


#pragma mark 取得分享内容文本
- (void)getShareInfoString
{
    NSString *type;
    if ([[_dic valueForKey:@"type"] isEqualToString:@"0"]) {
        type = @"遗失物品,请求帮助";
    } else if([[_dic valueForKey:@"type"] isEqualToString:@"1"]){
        type = @"拾取失物,发布招领";
    }
    shareContent = [[NSString alloc]initWithFormat:@"%@ 标题: %@ 地点: %@ 时间: %@ 发布人姓名: %@ 发布人联系电话: %@ 详细信息: %@", type, [_dic valueForKey:@"title"], [_dic valueForKey:@"place"], [_dic valueForKey:@"time"], [_dic valueForKey:@"name"], [_dic valueForKey:@"phone"], [_dic valueForKey:@"content"]];
    //NSString *shareString = [shareContent substringToIndex:140];
    
    NSLog(@"%@", shareContent);
    NSString *shareTitle = [_dic objectForKey:@"title"];
    NSLog(shareTitle);
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession, ShareTypeWeixiTimeline, ShareTypeRenren, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeQQ, ShareTypeQQSpace, ShareTypeFacebook, ShareTypeTwitter, nil];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:nil
                                                title:shareTitle
                                                  url:@"http://www.twt.edu.cn"
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

- (IBAction)call:(id)sender
{
    NSString *phoneNum = [_dic objectForKey:@"phone"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:13/255.0f green:174/255.0f blue:124/255.0f alpha:1.0f];;
        }
    }];
}


@end
