//
//  IndexViewController.m
//  News
//
//  Created by Qin Yubo on 13-10-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "IndexViewController.h"
#import "data.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"
#import "twtAPIs.h"
#import "JSONKit.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface IndexViewController ()

@end

@implementation IndexViewController {
    NSInteger currentPage;
    NSString *type;
    
    NSMutableArray *dataInTable;
    NSMutableArray *newsData;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

// 将实际更新的数据和显示出来的数组分离以避免闪退

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
    
    newsData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];
    
    __weak IndexViewController *weakSelf = self;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.navigationController.hidesBarsOnSwipe = NO;
    }
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
    
    [self.tableView triggerPullToRefresh];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)backToHome
{
    //我也不知道为什么不过如果不写下面这一行就会出现很奇怪的错误
    //2014.4.18 想明白了……下面这行必须加上
    [data shareInstance].typeSelected = @"1";
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    newsData = [[NSMutableArray alloc]init];
    currentPage = 0;
    
    type = [data shareInstance].typeSelected;
    
    if ([data shareInstance].typeSelected == nil)
    {
        type = @"1";
    }
    else
    {
        type = [data shareInstance].typeSelected;
    }
    
    NSDictionary *typeTitleDic = @{@"1": @"天大要闻",
                                   @"5": @"视点观察",
                                   @"3": @"社团风采",
                                   @"4": @"院系动态"};
    
    self.navigationItem.title = typeTitleDic[type];
    
    [self getIndexData];
    
}

- (void)getIndexData {
    NSString *url = [twtAPIs twtAPINewsList];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ctype": @"news",
                                 @"page": [NSString stringWithFormat:@"%ld", (long)currentPage],
                                 @"ntype": type,
                                 @"platform": @"ios",
                                 @"version": [data shareInstance].appVersion};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *dataArr = [operation.responseString objectFromJSONString];
        
        [self processIndexData:dataArr];
        
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
}

- (void)processIndexData:(NSArray *)newsDic
{
    if ([newsDic count]>0)
    {
        for (NSDictionary *temp in newsDic)
        {
            [newsData addObject:temp];
        }
    }
    
    dataInTable = newsData;

    [self.tableView reloadData];
}

//这里添加方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataInTable count];
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
    NSDictionary *tmp = [dataInTable objectAtIndex:row];
    cell.textLabel.text = [tmp objectForKey:@"subject"];
    cell.textLabel.numberOfLines = 2;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)nextPage
{
    currentPage ++;

    [self getIndexData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *temp = [dataInTable objectAtIndex:row];
    NSString *rowSelected = [temp objectForKey:@"subject"];
    NSString *idSelected = [temp objectForKey:@"index"];
    
    DetailViewController *detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    detailViewController.hidesBottomBarWhenPushed = YES;
    detailViewController.detailId = idSelected;
    detailViewController.detailTitle = rowSelected;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

@end
