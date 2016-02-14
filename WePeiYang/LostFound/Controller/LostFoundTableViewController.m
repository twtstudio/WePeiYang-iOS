//
//  LostFoundTableViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/13.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "LostFoundTableViewController.h"
#import "twtSDK.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "LostFoundViewController.h"
#import "LostFoundItem.h"
#import "LostFoundDetail.h"
#import "LostFoundTableViewCell.h"
#import "MsgDisplay.h"
#import "WePeiYang-Swift.h"

@interface LostFoundTableViewController ()

@end

@implementation LostFoundTableViewController {
    NSInteger currentPage;
    NSMutableArray *dataArr;
}

@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    currentPage = 1;
    dataArr = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [UIView new];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)] && self.navigationController.navigationBar.translucent == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + MENU_VIEW_HEIGHT;
        //        insets.bottom = 49;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self nextPage];
    }];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

// type 0: Lost
// type 1: Found

- (void)refreshData {
    if (![self.tableView.mj_header isRefreshing]) {
        [dataArr removeAllObjects];
        currentPage = 1;
        [self fetchData];
    }
}

- (void)nextPage {
    currentPage ++;
    [self fetchData];
}

- (void)fetchData {
    [twtSDK getLostFoundListWithType:type page:currentPage success:^(NSURLSessionDataTask *task, id responseObj) {
        if ([responseObj objectForKey:@"data"]) {
            if (currentPage == 0) {
                dataArr = [[LostFoundItem mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"data"]] mutableCopy];
            } else {
                [dataArr addObjectsFromArray:[LostFoundItem mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"data"]]];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MsgDisplay showErrorMsg:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LostFoundTableViewCell *cell = (LostFoundTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LostFoundTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSInteger row = [indexPath row];
    [cell setLostFoundItem:dataArr[row] withType:type];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    LostFoundItem *tmp = dataArr[row];
    LostFoundDetailViewController *lfDetailVC = [[LostFoundDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    lfDetailVC.index = tmp.index;
    lfDetailVC.type = [NSString stringWithFormat:@"%ld", type];
    [self.navigationController showViewController:lfDetailVC sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
