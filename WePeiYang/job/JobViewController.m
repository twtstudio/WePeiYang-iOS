//
//  JobViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "JobViewController.h"
#import "data.h"
#import "JobTableCell.h"
#import "JobDetailViewController.h"
#import "JobFavViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface JobViewController ()

@end

@implementation JobViewController

{
    //NSMutableArray *jobTitles;
    //NSMutableArray *jobCorporations;
    //NSMutableArray *jobDates;
    //NSMutableArray *jobIds;
    //NSMutableArray *titleInTable;
    //NSMutableArray *corpInTable;
    //NSMutableArray *dateInTable;
    
    NSMutableArray *jobData;
    NSMutableArray *dataInTable;
    
    UIAlertView *waitingAlert;
    
    NSInteger currentPage;
}

//@synthesize response;

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"就业资讯";

    jobData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];

    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    UIBarButtonItem *favBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(pushFav)];
    [self.navigationItem setRightBarButtonItem:favBtn];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self refresh:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
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
    
    jobData = [NSMutableArray arrayWithObjects: nil];
    dataInTable = [NSMutableArray arrayWithObjects: nil];
    
    [jobData removeAllObjects];
    [dataInTable removeAllObjects];
    
    currentPage = 0;
    
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSDictionary *parameters = @{@"ctype":@"job",
                                 @"page":[NSString stringWithFormat:@"%d",currentPage],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealWithReceivedData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取列表失败T^T"];
    }];
    [self.refreshControl endRefreshing];
}

- (void)dealWithReceivedData:(NSDictionary *)jobsDic
{
    if ([jobsDic count]>0)
    {
        for (NSDictionary *temp in jobsDic)
        {
            [jobData addObject:temp];
        }
    }
    
    dataInTable = jobData;
    [dataInTable addObject:@"点击加载更多..."];
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    JobTableCell *cell = (JobTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"JobTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    if (row == [dataInTable count]-1)
    {
        cell.titleLabel.text = [dataInTable objectAtIndex:row];
        cell.corporationLabel.text = @"";
        cell.dateLabel.text = @"";
        cell.timeIconImg.hidden = YES;
        cell.corpIconImg.hidden = YES;
    }
    else
    {
        if ([dataInTable count] > 0) {
            NSDictionary *temp = [dataInTable objectAtIndex:row];
            cell.titleLabel.text = [temp objectForKey:@"title"];
            cell.corporationLabel.text = [temp objectForKey:@"corporation"];
            cell.dateLabel.text = [temp objectForKey:@"date"];
            cell.timeIconImg.hidden = NO;
            cell.corpIconImg.hidden = NO;
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    return (row == [dataInTable count]-1) ? 64 : 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (row == [dataInTable count] - 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [dataInTable removeObject:[dataInTable lastObject]];
        [self nextPage:self];
    }
    else
    {
        NSDictionary *temp = [dataInTable objectAtIndex:row];
        JobDetailViewController *jobDetail;
        jobDetail = [[JobDetailViewController alloc]initWithNibName:@"JobDetailViewController" bundle:nil];
        jobDetail.jobId = [temp objectForKey:@"id"];
        jobDetail.jobDate = [temp objectForKey:@"date"];
        jobDetail.jobCorp = [temp objectForKey:@"corporation"];
        jobDetail.jobTitle = [temp objectForKey:@"title"];
        [jobDetail setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:jobDetail animated:YES];
    }
}

- (void)nextPage:(id)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    currentPage = currentPage + 1;
    
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSDictionary *parameters = @{@"ctype":@"job",
                                 @"page":[NSString stringWithFormat:@"%ld",(long)currentPage],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealWithReceivedData:responseObject];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取列表失败T^T"];
    }];
}

- (void)pushFav
{
    JobFavViewController *jobFav = [[JobFavViewController alloc]initWithStyle:UITableViewStylePlain];
    [jobFav setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:jobFav animated:YES];
}

- (void)backToHome
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
