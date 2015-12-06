//
//  NewsTableViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/17.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "NewsTableViewController.h"
#import "twtSDK.h"
#import "MJExtension.h"
#import "SVPullToRefresh.h"
#import "NewsData.h"

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController {
    NSUInteger currentPage;
    NewsType type;
}

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        // 使 tableView 最上方不被 navigationBar 遮挡
        UIEdgeInsets oriContentInset = self.tableView.contentInset;
        UIEdgeInsets oriScrollIndicatorInset = self.tableView.scrollIndicatorInsets;
        self.tableView.contentInset = UIEdgeInsetsMake(64.0, oriContentInset.left, oriContentInset.bottom, oriContentInset.right);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64.0, oriScrollIndicatorInset.left, oriScrollIndicatorInset.bottom, oriScrollIndicatorInset.right);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    currentPage = 0;
    type = NewsTypeTJU;
    
    __weak NewsTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf nextPage];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)getData {
    
}

- (void)nextPage {
    
}

- (void)refreshData {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
