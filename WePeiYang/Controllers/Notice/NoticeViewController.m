//
//  NoticeViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-12.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "NoticeViewController.h"
#import "data.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "SVPullToRefresh.h"
#import "MsgDisplay.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface NoticeViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NoticeViewController

{
    NSInteger currentPage;
    
    NSMutableArray *noticeData;
    NSMutableArray *titleInTable;
    
    UIAlertView *waitingAlert;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //修复下拉刷新位置错误
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];

    noticeData = [[NSMutableArray alloc]init];
    titleInTable = [[NSMutableArray alloc]init];
    
    self.title = @"校园公告";
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:232/255.0f green:159/255.0f blue:0/255.0f alpha:1.0f];
    
    __weak NoticeViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
    
    [self.tableView triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)backToHome
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh {
    noticeData = [[NSMutableArray alloc]init];
    currentPage = 0;
    
    [self getIndexData];
}

- (void)getIndexData {
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSDictionary *parameters = @{@"ctype":@"news",@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],@"ntype":@"2"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealWithReceivedData:[operation.responseString objectFromJSONString]];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MsgDisplay showErrorMsg:error.localizedDescription];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)tableViewEndReloading
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[titleInTable objectAtIndex:row]objectForKey:@"subject"];
    cell.textLabel.numberOfLines = 2;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)nextPage
{
    currentPage = currentPage + 1;
    
    [self getIndexData];
}

- (void)dealWithReceivedData:(NSMutableArray *)noticeArr
{
    if ([noticeArr count]>0)
    {
        for (NSDictionary *temp in noticeArr)
        {
            [noticeData addObject:temp];
        }
    }
    titleInTable = noticeData;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *rowSelected = [[titleInTable objectAtIndex:row] objectForKey:@"subject"];
    NSString *idSelected = [[titleInTable objectAtIndex:row] objectForKey:@"index"];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *noticeDetail;
    noticeDetail = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    noticeDetail.hidesBottomBarWhenPushed = YES;
    noticeDetail.detailId = idSelected;
    noticeDetail.detailTitle = rowSelected;
    [self.navigationController pushViewController:noticeDetail animated:YES];
}

@end
