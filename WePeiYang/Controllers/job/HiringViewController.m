//
//  HiringViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-13.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "HiringViewController.h"
#import "HringTableCell.h"
#import "AFNetworking.h"
#import "data.h"
#import "SVProgressHUD.h"
#import "HiringDetailViewController.h"

@interface HiringViewController ()

@end

@implementation HiringViewController

{
    NSMutableArray *hiringData;
    NSMutableArray *dataInTable;
    
    NSInteger currentPage;
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"校园招聘";
    
    hiringData = [[NSMutableArray alloc]initWithObjects: nil];
    dataInTable = [[NSMutableArray alloc]initWithObjects: nil];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)refreshView:(UIRefreshControl *)refreshControl
{
    if(refreshControl.refreshing)
    {
        refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在加载..."];
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0];
    }
}

- (void)refresh
{
    currentPage = 0;
    [hiringData removeAllObjects];
    [dataInTable removeAllObjects];
    
    [self getIndexData];
    
}

- (void)getIndexData {
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSDictionary *parameters = @{@"ctype":@"fair", @"page":[NSString stringWithFormat:@"%ld",(long)currentPage],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processContentDic:responseObject];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)processContentDic:(NSDictionary *)dic {
    
    for (NSDictionary *tmp in dic)
    {
        [hiringData addObject:tmp];
    }
    
    dataInTable = hiringData;
    [dataInTable addObject:@"点击加载更多..."];
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)nextPage
{
    
    currentPage ++;
    [self getIndexData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    return (row!=[dataInTable count]-1) ? 112 : 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleCellIdentifier = @"CellIdentifier";
    HringTableCell *cell = (HringTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HringTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSInteger row = [indexPath row];
    if (row!=[dataInTable count]-1)
    {
        NSDictionary *tmp = [dataInTable objectAtIndex:row];
        cell.titleLabel.text = [tmp objectForKey:@"title"];
        cell.corpLabel.text = [tmp objectForKey:@"corporation"];
        cell.dateLabel.text = [tmp objectForKey:@"held_date"];
        cell.timeLabel.text = [tmp objectForKey:@"held_time"];
        cell.placeLabel.text = [tmp objectForKey:@"place"];
        cell.timeImg.hidden = NO;
        cell.placeImg.hidden = NO;
    }
    else
    {
        cell.titleLabel.text = [dataInTable lastObject];
        cell.corpLabel.text = @"";
        cell.dateLabel.text = @"";
        cell.timeLabel.text = @"";
        cell.placeLabel.text = @"";
        cell.timeImg.hidden = YES;
        cell.placeImg.hidden = YES;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row == [dataInTable count] - 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [dataInTable removeObject:[dataInTable lastObject]];
        [self nextPage];
    }
    else
    {
        NSDictionary *tmp = [dataInTable objectAtIndex:row];

        HiringDetailViewController *hiringDetail = [[HiringDetailViewController alloc]initWithNibName:nil bundle:nil];
        [hiringDetail setHidesBottomBarWhenPushed:YES];
        hiringDetail.hiringId = [tmp objectForKey:@"id"];
        hiringDetail.hiringTitle = [tmp objectForKey:@"title"];
        hiringDetail.hiringCorp = [tmp objectForKey:@"corporation"];
        hiringDetail.hiringDate = [tmp objectForKey:@"held_date"];
        hiringDetail.hiringTime = [tmp objectForKey:@"held_time"];
        hiringDetail.hiringPlace = [tmp objectForKey:@"place"];
        [self.navigationController pushViewController:hiringDetail animated:YES];
    }
}

- (void)backToHome
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
