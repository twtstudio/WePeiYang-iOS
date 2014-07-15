//
//  NoticeFavViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-2-26.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "NoticeFavViewController.h"
#import "NoticeDetailViewController.h"
#import "data.h"

@interface NoticeFavViewController ()

@end

@implementation NoticeFavViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];

    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.title = @"收藏夹";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:232/255.0f green:159/255.0f blue:0/255.0f alpha:1.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"noticeFavData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    favDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    titleArray = [favDic allKeys];
    [self.tableView reloadData];
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
    // Return the number of rows in the section.
    return [titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [titleArray objectAtIndex:row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *title = [titleArray objectAtIndex:row];
    NSDictionary *dic = [favDic objectForKey:title];
    [data shareInstance].noticeTitle = title;
    [data shareInstance].noticeId = [dic objectForKey:@"id"];
    NoticeDetailViewController *noticeDetail = [[NoticeDetailViewController alloc]initWithNibName:nil bundle:nil];
    [noticeDetail setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:noticeDetail animated:YES];
}

- (void)deleteFromCollectionByTitle:(NSString *)title
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"noticeFavData"];
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
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"noticeFavData"];
    NSDictionary *collectionDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    titleArray = [collectionDic allKeys];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)backToHome
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
