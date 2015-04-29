//
//  HiringViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-13.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "HiringViewController.h"
#import "HringTableCell.h"
#import "ContentDataManager.h"
#import "data.h"
#import "MsgDisplay.h"
#import "HiringDetailViewController.h"
#import "SVPullToRefresh.h"

@interface HiringViewController ()

@end

@implementation HiringViewController

{
    NSMutableArray *rowsData;
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
    
    self.title = @"校园招聘";
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    rowsData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];
    currentPage = 0;
    
    __weak HiringViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    [self.tableView triggerPullToRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)refresh {
    currentPage = 0;
    rowsData = [[NSMutableArray alloc]init];
    
    [self getIndexData];
    
}

- (void)getIndexData {
    NSDictionary *parameters = @{@"ctype":@"fair",
                                 @"page":[NSString stringWithFormat:@"%ld",(long)currentPage],
                                 @"platform": @"ios",
                                 @"version": [data shareInstance].appVersion};
    
    [MsgDisplay showLoading];
    
    [ContentDataManager getIndexDataWithParameters:parameters success:^(id _rowsData) {
        [MsgDisplay dismiss];
        if (currentPage == 0) {
            rowsData = [[NSMutableArray alloc]initWithArray:_rowsData];
        } else {
            [rowsData addObjectsFromArray:_rowsData];
        }
        dataInTable = rowsData;
        
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }failure:^(NSString *error) {
        [MsgDisplay dismiss];
        [MsgDisplay showErrorMsg:error];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)nextPage {
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
    return 112;
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
    NSDictionary *tmp = [dataInTable objectAtIndex:row];
    cell.titleLabel.text = [tmp objectForKey:@"title"];
    cell.corpLabel.text = [tmp objectForKey:@"corporation"];
    cell.dateLabel.text = [tmp objectForKey:@"held_date"];
    cell.timeLabel.text = [tmp objectForKey:@"held_time"];
    cell.placeLabel.text = [tmp objectForKey:@"place"];
    cell.timeImg.hidden = NO;
    cell.placeImg.hidden = NO;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
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

- (void)backToHome {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
