//
//  NoticeViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-12.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "NoticeViewController.h"
#import "data.h"
#import "NoticeDetailViewController.h"
#import "NoticeFavViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface NoticeViewController ()

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UINavigationItem *navItem = [[UINavigationItem alloc]initWithTitle:@"校园公告"];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [navItem setLeftBarButtonItem:backBtn];
    
    UIBarButtonItem *favBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(pushFav)];
    [navItem setRightBarButtonItem:favBtn];
    
    [navBar pushNavigationItem:navItem animated:YES];
    [self.view addSubview:navBar];

    noticeData = [[NSMutableArray alloc]initWithObjects: nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.title = @"校园公告";
    
    [self refresh:self];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:232/255.0f green:159/255.0f blue:0/255.0f alpha:1.0f];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}

- (void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshView:(UIRefreshControl *)refreshControl
{
    if(refreshControl.refreshing)
    {
        refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在加载..."];
        [self performSelector:@selector(refresh:) withObject:nil afterDelay:0];
    }
}

- (void)refresh:(id)sender
{
    noticeData = [[NSMutableArray alloc]initWithObjects: nil];
    currentPage = 0;
    
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSDictionary *parameters = @{@"ctype":@"news",@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],@"ntype":@"2"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealWithReceivedDictionary:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    [self.refreshControl endRefreshing];
}

- (void)tableViewEndReloading
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pushFav {
    NoticeFavViewController *noticeFav = [[NoticeFavViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:noticeFav animated:YES];
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
    if (row == [titleInTable count]-1)
    {
        cell.textLabel.text = [titleInTable objectAtIndex:row];
    }
    else
    {
        cell.textLabel.text = [[titleInTable objectAtIndex:row]objectForKey:@"subject"];
        cell.textLabel.numberOfLines = 2;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)nextPage:(id)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    currentPage = currentPage + 1;
    
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSDictionary *parameters = @{@"ctype":@"news",@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],@"ntype":@"2"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealWithReceivedDictionary:responseObject];
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)dealWithReceivedDictionary:(NSDictionary *)noticeDic
{
    if ([noticeDic count]>0)
    {
        for (NSDictionary *temp in noticeDic)
        {
            [noticeData addObject:temp];
        }
    }
    titleInTable = noticeData;
    [titleInTable addObject:@"点击加载更多..."];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (row == [titleInTable count] - 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [titleInTable removeObject:[titleInTable lastObject]];
        [self nextPage:self];
    }
    else
    {
        NSString *rowSelected = [[titleInTable objectAtIndex:row] objectForKey:@"subject"];
        NSString *idSelected = [[titleInTable objectAtIndex:row] objectForKey:@"index"];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NoticeDetailViewController *noticeDetail;
        noticeDetail = [[NoticeDetailViewController alloc]initWithNibName:@"NoticeDetailViewController" bundle:nil];
        noticeDetail.hidesBottomBarWhenPushed = YES;
        noticeDetail.noticeId = idSelected;
        noticeDetail.noticeTitle = rowSelected;
        [self.navigationController pushViewController:noticeDetail animated:YES];
    }
}

@end
