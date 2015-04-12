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
#import "MsgDisplay.h"
#import "ContentDataManager.h"
#import "SVPullToRefresh.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface JobViewController ()

@end

@implementation JobViewController

{
    NSMutableArray *rowsData;
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
    
    self.title = @"就业资讯";
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }

    rowsData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];
    
    __weak JobViewController *weakSelf = self;
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
    [self getListData];
}

- (void)nextPage {
    currentPage ++;
    [self getListData];
    [MsgDisplay showLoading];
}

- (void)getListData {
    NSDictionary *parameters = @{@"ctype":@"job",
                                 @"page":[NSString stringWithFormat:@"%ld",(long)currentPage],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    
    [ContentDataManager getIndexDataWithParameters:parameters success:^(id responseObject) {
        if (currentPage == 0) {
            rowsData = [[NSMutableArray alloc]initWithArray:responseObject];
        } else {
            [rowsData addObjectsFromArray:responseObject];
        }
        dataInTable = rowsData;
        [self.tableView reloadData];
        [MsgDisplay dismiss];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    } failure:^(NSString *error) {
        [MsgDisplay dismiss];
        [MsgDisplay showErrorMsg:error];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }];

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
    if ([dataInTable count] > 0) {
        NSDictionary *temp = [dataInTable objectAtIndex:row];
        cell.titleLabel.text = [temp objectForKey:@"title"];
        cell.corporationLabel.text = [temp objectForKey:@"corporation"];
        cell.dateLabel.text = [temp objectForKey:@"date"];
        cell.timeIconImg.hidden = NO;
        cell.corpIconImg.hidden = NO;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
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

- (void)backToHome
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
