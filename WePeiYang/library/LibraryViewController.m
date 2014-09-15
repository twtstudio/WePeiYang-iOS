//
//  LibraryViewController.m
//  Library
//
//  Created by Qin Yubo on 13-11-4.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "LibraryViewController.h"
#import "LibraryTableCell.h"
#import "data.h"
#import "LoginViewController.h"
#import "RecordViewController.h"
#import "LibraryFavouriteViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UIButton+Bootstrap.h"
#import "DMSlideTransition.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface LibraryViewController ()

@property (strong, nonatomic) DMSlideTransition *slideTrans;

@end

@implementation LibraryViewController

{
    NSInteger type;
    NSString *searchStr;

    NSInteger currentPage;
    NSInteger totalBooks;
    BOOL loginStatusChanged;
    NSString *username;
    NSString *password;

    UIAlertView *detailAlert;
    
    UIActionSheet *loginActionSheet;
    UIActionSheet *recordActionSheet;
    UIActionSheet *typeActionSheet;
    
    NSMutableArray *libraryData;
}

@synthesize tableView;
@synthesize typeSegmentedControl;
@synthesize headerBackView;

@synthesize label1;
@synthesize label2;
@synthesize slideTrans;
@synthesize searchBar;

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tableView.hidden = YES;
    //self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"librarybg.png"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.headerBackView.backgroundColor = [UIColor colorWithRed:0/255.0f green:181/255.0f blue:128/255.0f alpha:1.0f];
    
    //初始化
    type = 0;

    libraryData = [[NSMutableArray alloc]initWithObjects: nil];
    currentPage = 1;
    
    self.typeSegmentedControl.selectedSegmentIndex = 0;
    
    [tableView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIImageView *nilView = [[UIImageView alloc]initWithImage:nil];
    searchField.leftView = nilView;
}

- (IBAction)backToHome:(id)sender
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender
{
    //[searchField resignFirstResponder];
    [searchBar resignFirstResponder];
}

- (IBAction)typeChanged:(id)sender
{
    [searchBar resignFirstResponder];
    
    if ([sender selectedSegmentIndex] == 0)
    {
        type = 0;
        typeSegmentedControl.momentary = NO;
    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        type = 1;
        typeSegmentedControl.momentary = NO;
    }
    else if ([sender selectedSegmentIndex] == 2)
    {
        type = 2;
        typeSegmentedControl.momentary = NO;
    }
    else
    {
        typeSegmentedControl.momentary = YES;
        typeSegmentedControl.selectedSegmentIndex = 3;
        typeActionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择检索关键字的类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"主题",@"丛书",@"期刊期名", nil];
        [typeActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}


- (void)removeRecord:(id)sender
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"login"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:plistPath error:nil];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注销成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    //[moreBtn removeTarget:self action:@selector(openActionSheetRecord:) forControlEvents:UIControlEventTouchUpInside];
    //[moreBtn addTarget:self action:@selector(openActionSheetLogin:) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"您尚未登录";
}


- (void)search:(id)sender
{
    //[searchField resignFirstResponder];
    [searchBar resignFirstResponder];
    searchStr = searchBar.text;
    if ([searchStr isEqualToString: @""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"关键字不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        libraryData = [[NSMutableArray alloc]initWithObjects: nil];
        
        currentPage = 1;
        
        [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *url = @"http://push-mobile.twtapps.net/lib/search";
        NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",currentPage],
                                     @"query":searchStr,
                                     @"type":[NSString stringWithFormat:@"%d",type],
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resultDic = [responseObject objectForKey:@"books"];
            totalBooks = [[responseObject objectForKey:@"total"]integerValue];
            [self dealWithReceivedSearchData:resultDic];
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"获取书目失败T^T"];
        }];
        
        /*
        NSString *body = [NSString stringWithFormat:@"page=%d&query=%@&type=%ld",currentPage,searchStr,(long)type];
        [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
            [waitingAlert dismissWithClickedButtonIndex:0 animated:YES];
            if (dic!=nil)
            {
                if (![[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
                {
                    [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"服务器出错惹QAQ"];
                }
                else
                {
                    NSDictionary *resultDic = [[dic objectForKey:@"content"] objectForKey:@"books"];
                    totalBooks = [[[dic objectForKey:@"content"] objectForKey:@"total"]integerValue];
                    [self dealWithReceivedSearchData:resultDic];
                }
            }
            else
            {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
            }
        }];
         */
    }
}

- (void)dealWithReceivedSearchData:(NSDictionary *)resultDic
{
    if ([resultDic count]>0)
    {
        
        for (NSDictionary *temp in resultDic)
        {
            if ([temp objectForKey:@"title"] != nil)
            {
                [libraryData addObject:temp];
            }
            else
            {
                //totalPages = [[temp objectForKey:@"totalPages"]integerValue];
            }
        }
        
        
        
    }
    
    if (currentPage <= (totalBooks/20+1) && totalBooks >= 20)
    {
        [libraryData addObject:@"点击加载更多..."];
    }
    
    [self.tableView reloadData];
    [tableView setHidden:NO];
    [label1 setHidden:YES];
    [label2 setHidden:YES];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [libraryData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row == [libraryData count]-1 && totalBooks >= 20)
    {
        return 68;
    }
    else
    {
        return 134;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableIdentifier";
    LibraryTableCell *cell = (LibraryTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LibraryTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    if (row == [libraryData count]-1)
    {
        cell.titleLabel.text = [libraryData objectAtIndex:row];
        cell.authorLabel.text = @"";
        cell.positionYearLabel.text = @"";
        cell.leftLabel.text = @"";
    }
    else
    {
        NSDictionary *temp = [libraryData objectAtIndex:row];
        cell.titleLabel.text = [temp objectForKey:@"title"];
        cell.authorLabel.text = [temp objectForKey:@"author"];
        cell.positionYearLabel.text = [NSString stringWithFormat:@"%@ %@", [temp objectForKey:@"position"],[temp objectForKey:@"year"]];
        cell.leftLabel.text = [temp objectForKey:@"left"];
    }
    cell.cellBgImageView.hidden = NO;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    NSInteger row = [indexPath row];
    if (row == [libraryData count]-1 && currentPage <= (totalBooks/20+1))
    {
        [libraryData removeObject:[libraryData lastObject]];
        [self nextPage];
    }
    else
    {
        //NSString *msgStr = [[NSString alloc]initWithFormat:@"%@，%@，%@，%@",[titleArray objectAtIndex:row],[yearArray objectAtIndex:row],[positionArray objectAtIndex:row],[leftArray objectAtIndex:row]];
        NSDictionary *temp = [libraryData objectAtIndex:row];
        [data shareInstance].titleSelected = [temp objectForKey:@"title"];
        [data shareInstance].positionSelected = [temp objectForKey:@"position"];
        [data shareInstance].authorSelected = [temp objectForKey:@"author"];
        [data shareInstance].yearSelected = [temp objectForKey:@"year"];
        [data shareInstance].leftSelected = [temp objectForKey:@"left"];
        
        detailAlert = [[UIAlertView alloc]initWithTitle:@"更多" message:[data shareInstance].titleSelected delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加到收藏",@"分享", nil];
        [detailAlert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)nextPage
{
    
    currentPage = currentPage + 1;
    [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
    NSString *url = @"http://push-mobile.twtapps.net/lib/search";
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",currentPage],
                                 @"query":searchStr,
                                 @"type":[NSString stringWithFormat:@"%d",type],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = [responseObject objectForKey:@"books"];
        totalBooks = [[responseObject objectForKey:@"total"]integerValue];
        [self dealWithReceivedNextData:resultDic];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取书目失败T^T"];
    }];

}

- (void)dealWithReceivedNextData:(NSDictionary *)resultDic
{
    if ([resultDic count]>0)
    {
        for (NSDictionary *temp in resultDic)
        {
            if ([temp objectForKey:@"title"] != nil)
            {
                [libraryData addObject:temp];
            }
            else
            {
                //totalPages = [[temp objectForKey:@"totalPages"]integerValue];
            }
        }
    }
    
    if (currentPage <= (totalBooks/20+1))
    {
        [libraryData addObject:@"点击加载更多..."];
    }
    
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == detailAlert)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            nil;
        }
        else if (buttonIndex == 1)
        {
            [self addToFavourite];
        }
        else if (buttonIndex == 2)
        {
            [self share];
        }
    }
}

- (void)addToFavourite
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryCollectionData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSMutableDictionary *LibraryCollectionDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    if (LibraryCollectionDic == nil)
    {
        LibraryCollectionDic = [[NSMutableDictionary alloc]init];
    }
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
    [newDic setObject:[data shareInstance].titleSelected forKey:@"title"];
    [newDic setObject:[data shareInstance].authorSelected forKey:@"author"];
    [newDic setObject:[data shareInstance].yearSelected forKey:@"year"];
    [newDic setObject:[data shareInstance].positionSelected forKey:@"position"];
    [newDic setObject:[data shareInstance].leftSelected forKey:@"left"];
    
    [LibraryCollectionDic setObject:newDic forKey:[data shareInstance].titleSelected];
    [LibraryCollectionDic writeToFile:plistPath atomically:YES];
    
    [SVProgressHUD showSuccessWithStatus:@"书目收藏成功"];
}

- (void)share
{
    NSString *title = [data shareInstance].titleSelected;
    NSString *position = [data shareInstance].positionSelected;
    NSString *left = [data shareInstance].leftSelected;
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession, ShareTypeWeixiTimeline, ShareTypeRenren, ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeQQ, ShareTypeQQSpace, ShareTypeFacebook, ShareTypeTwitter, nil];
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ %@ %@",title,position,left];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareString
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:nil
                                                title:shareString
                                                  url:nil
                                          description:@"分享自微北洋"
                                            mediaType:SSPublishContentMediaTypeText];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
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


/*
- (void)shareByIOS
{
    NSArray *activityItems;
    
    NSString *title = [data shareInstance].titleSelected;
    NSString *position = [data shareInstance].positionSelected;
    NSString *left = [data shareInstance].leftSelected;
    
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ %@ %@",title,position,left];
    
    activityItems = @[shareString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}
 */

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search button clicked");
    [searchBar resignFirstResponder];
    [self search:self];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"BEGIN EDITING");
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:0/255.0f green:181/255.0f blue:128/255.0f alpha:1.0f];
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
