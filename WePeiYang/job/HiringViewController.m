//
//  HiringViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-13.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "HiringViewController.h"
#import "HringTableCell.h"
#import "wpyWebConnection.h"
#import "data.h"
#import "CSNotificationView.h"
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
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self refresh];
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
    hiringData = [[NSMutableArray alloc]initWithObjects: nil];
    dataInTable = [[NSMutableArray alloc]initWithObjects: nil];
    
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSString *body = [NSString stringWithFormat:@"ctype=fair&page=%d",currentPage];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic != nil)
            [self processContentDic:dic];
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)processContentDic:(NSDictionary *)dic
{
    if (![[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
    {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"服务器出错惹QAQ"];
    }
    else
    {
        NSDictionary *dataDic = [dic objectForKey:@"content"];
        for (NSDictionary *tmp in dataDic)
        {
            [hiringData addObject:tmp];
        }
        
        dataInTable = hiringData;
        [dataInTable addObject:@"点击加载更多..."];
        
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}

- (void)nextPage
{
    currentPage ++;
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSString *body = [NSString stringWithFormat:@"ctype=fair&page=%d",currentPage];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        [self processContentDic:dic];
    }];
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
    if (row!=[dataInTable count]-1)
    {
        return 112;
    }
    else
    {
        return 64;
    }
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
        [data shareInstance].hiringId = [tmp objectForKey:@"id"];
        [data shareInstance].hiringTitle = [tmp objectForKey:@"title"];
        [data shareInstance].hiringCorp = [tmp objectForKey:@"corporation"];
        [data shareInstance].hiringDate = [tmp objectForKey:@"held_date"];
        [data shareInstance].hiringTime = [tmp objectForKey:@"held_time"];
        [data shareInstance].hiringPlace = [tmp objectForKey:@"place"];
        
        HiringDetailViewController *hiringDetail = [[HiringDetailViewController alloc]initWithNibName:nil bundle:nil];
        [hiringDetail setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:hiringDetail animated:YES];
    }
}

- (void)backToHome
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
