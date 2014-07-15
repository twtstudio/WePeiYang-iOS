//
//  JobFavViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-2-19.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "JobFavViewController.h"
#import "JobTableCell.h"
#import "JobDetailViewController.h"
#import "data.h"

@interface JobFavViewController ()

@end

@implementation JobFavViewController

{
    NSArray *titleArray;
    
    NSDictionary *favDic;
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
    self.title = @"收藏夹";
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"jobFavData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    favDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    titleArray = [favDic allKeys];
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
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
    NSString *title = [titleArray objectAtIndex:row];
    NSDictionary *dic = [favDic objectForKey:title];
    cell.titleLabel.text = title;
    cell.corporationLabel.text = [dic objectForKey:@"corp"];
    cell.dateLabel.text = [dic objectForKey:@"date"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)deleteFromCollectionByTitle:(NSString *)title
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"jobFavData"];
    NSMutableDictionary *collectionDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    [collectionDic removeObjectForKey:title];
    [collectionDic writeToFile:plistPath atomically:YES];
}

//右滑删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *titleSelected = [titleArray objectAtIndex:row];
    [self deleteFromCollectionByTitle:titleSelected];
    
    //重新加载数据
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"jobFavData"];
    NSDictionary *collectionDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    titleArray = [collectionDic allKeys];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *title = [titleArray objectAtIndex:row];
    NSDictionary *dic = [favDic objectForKey:title];
    [data shareInstance].jobId = [dic objectForKey:@"id"];
    [data shareInstance].jobTitle = [dic objectForKey:@"title"];
    JobDetailViewController *jobDetail = [[JobDetailViewController alloc]initWithNibName:nil bundle:nil];
    [jobDetail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:jobDetail animated:YES];
}


@end
