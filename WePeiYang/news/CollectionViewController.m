//
//  CollectionViewController.m
//  News
//
//  Created by Qin Yubo on 13-10-23.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "CollectionViewController.h"
#import "DetailViewController.h"
#import "data.h"
#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface CollectionViewController ()

@end

@implementation CollectionViewController
{
    NSArray *tableArray;
    NSDictionary *collectionDic;
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
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.title = @"收藏";
  
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"collectionData"];
    collectionDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    tableArray = [collectionDic allKeys];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [tableArray objectAtIndex:row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *dicSelected = [collectionDic objectForKey:[tableArray objectAtIndex:row]];
    //[data shareInstance].newsTitle = [dicSelected objectForKey:@"title"];
    //[data shareInstance].newsId = [dicSelected objectForKey:@"id"];
    
    DetailViewController *detailVC = [[DetailViewController alloc]initWithNibName:nil bundle:nil];
    detailVC.detailId = [dicSelected objectForKey:@"id"];
    detailVC.detailTitle = [dicSelected objectForKey:@"title"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)deleteFromCollectionByTitle:(NSString *)title
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"collectionData"];
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
    NSString *titleSelected = [tableArray objectAtIndex:row];
    [self deleteFromCollectionByTitle:titleSelected];
    
    //重新加载数据
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"collectionData"];
    NSDictionary *collectionDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    tableArray = [collectionDic allKeys];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

@end
