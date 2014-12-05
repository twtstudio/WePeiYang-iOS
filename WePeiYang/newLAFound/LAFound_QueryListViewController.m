//
//  LAFound_QueryListViewController.m
//  LostAndFound
//
//  Created by 马骁 on 14-4-16.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import "LAFound_QueryListViewController.h"
#import "LAFound_QueryDetailViewController.h"
#import "LAFound_QueryListTableViewCell.h"
#import "SVProgressHUD.h"
#import "LAFound_AnnounceViewController.h"

#import "LAFound_DataManager.h"

@interface LAFound_QueryListViewController ()

@end

@implementation LAFound_QueryListViewController
{
    NSMutableArray *_dataArrayLost;
    NSMutableArray *_dataArrayFound;
    
    NSInteger _pageLost;
    NSInteger _pageFound;
    
    NSMutableArray *_currentDataArray;
    NSInteger _currentPage;
    
    NSInteger _type;
    
    UIAlertView *_waitingAlert;
    
    bool _dataExixt;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *segmentedControlItems = @[@"失物", @"拾取"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedControlItems];
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setWidth:80 forSegmentAtIndex:0];
    [segmentedControl setWidth:80 forSegmentAtIndex:1];
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushAdd)];
    [self.navigationItem setRightBarButtonItem:addBtn];
    
    _dataArrayLost = [[NSMutableArray alloc] initWithCapacity:20];
    _dataArrayFound = [[NSMutableArray alloc] initWithCapacity:20];
    _type = 0;
    _pageLost = 0;
    _pageFound = 0;
    
    _currentDataArray = _dataArrayLost;
    _currentPage = _pageLost;
    
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
    
    if (_dataExixt) {
        return;
    }else{
        [self loadData];
        _dataExixt = YES;
        //        设置下拉刷新
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
        [self.refreshControl addTarget:self action:@selector(refreshTableview) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

#pragma mark tableView代理方法
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifie = @"cell";
    LAFound_QueryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifie];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"LAFound_QueryListTableViewCell" owner:self options:nil];
        cell = [array firstObject];
    }
    
    if (indexPath.row == [_currentDataArray count])
    {
        cell.titleLabel.text = @"点击加载更多";
        cell.placeLabel.hidden = YES;
        cell.timeLabel.hidden = YES;
        cell.imageView.hidden = YES;
        cell.placeLogo.hidden = YES;
        cell.timeLogo.hidden = YES;
        cell.borderImage.hidden = YES;
        cell.titleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    }
    else
    {
        NSDictionary *dic = [_currentDataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = [dic valueForKey:@"title"];
        //cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.placeLabel.text = [dic valueForKey:@"place"];
        cell.timeLabel.text = [dic valueForKey:@"time"];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_currentDataArray count] != 0) {
        return [_currentDataArray count] + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_currentDataArray count])
    {
        return 72;
    }
    return 118;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    用于点击加载更多
    if (indexPath.row == [_currentDataArray count]) {
        if (_type == 0) {
            _pageLost++;
            _currentPage = _pageLost;
        } else if (_type == 1){
            _pageFound++;
            _currentPage = _pageFound;
        }
        NSLog(@"%ld", (long)_currentPage);
        [self loadData];
        return;
    }
    
    LAFound_QueryDetailViewController *qdVC = [[LAFound_QueryDetailViewController alloc] init];
    self.delegate = qdVC;
    [self.delegate LAFound_QueryListViewController:self ShowDetailByDataDic:[_currentDataArray objectAtIndex:indexPath.row]];
    [qdVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:qdVC animated:YES];
}

#pragma mark 取得数据


- (void)loadData
{

    
    [LAFound_DataManager getItemInfoWithItemInfoType:_type andPage:_currentPage success:^(id responseObject) {
        [self processWithData:responseObject];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    
}

- (void)processWithData:(NSArray *)newDataArray{
    if (newDataArray) {
        if (_type == 0) {
            if ([newDataArray count] == 0 && _pageLost > 0) {
                _pageLost--;
                _currentPage = _pageLost;
            } else {
                [_dataArrayLost addObjectsFromArray:newDataArray];
                _currentDataArray = _dataArrayLost;
            }
        } else if (_type == 1){
            if ([newDataArray count] == 0 && _pageFound > 0) {
                _pageFound--;
                _currentPage = _pageFound;
            }else {
                [_dataArrayFound addObjectsFromArray:newDataArray];
                _currentDataArray = _dataArrayFound;
            }
        }
        [self.tableView reloadData];
    } else {
        [SVProgressHUD showErrorWithStatus:@"出错啦~请稍后重试…"];
    }
}


- (void)processWithDataPassRefresh:(NSArray *)newDataArray
{
    if (newDataArray) {
        if (_type == 0) {
            _pageLost = _currentPage;
            [_currentDataArray removeAllObjects];
            [_currentDataArray addObjectsFromArray:newDataArray];
            _dataArrayLost = _currentDataArray;
        } else if (_type == 1){
            _pageLost = _currentPage;
            [_currentDataArray removeAllObjects];
            [_currentDataArray addObjectsFromArray:newDataArray];
            _dataArrayFound = _currentDataArray;
        }
        [self.tableView reloadData];
    } else {
        [SVProgressHUD showErrorWithStatus:@"出错啦~请稍后重试…"];
    }
    
    
}



#pragma mark segmentedcontrol触发的事件

- (void)segmentedControlAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    if (index == 0) {
        _type = 0;
        _currentDataArray = _dataArrayLost;
        _currentPage = _pageLost;
        if ([_currentDataArray count] > 0) {
            [self.tableView reloadData];
        }else {
            [self loadData];
        }
    } else if (index == 1){
        _type = 1;
        _currentDataArray = _dataArrayFound;
        _currentPage = _pageFound;
        if ([_currentDataArray count] > 0) {
            [self.tableView reloadData];
        } else {
            [self loadData];
        }
    }
}

#pragma mark 下拉刷新

- (void)refreshTableview
{
    _currentPage = 0;
    [LAFound_DataManager getItemInfoWithItemInfoType:_type andPage:_currentPage success:^(id responseObject) {
        [self processWithDataPassRefresh:responseObject];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    [self.refreshControl endRefreshing];
    
}


- (void)backToHome
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)pushAdd
{
    LAFound_AnnounceViewController *lafAnnounce = [[LAFound_AnnounceViewController alloc]initWithNibName:nil bundle:nil];
    [lafAnnounce setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:lafAnnounce animated:YES];
}


@end
