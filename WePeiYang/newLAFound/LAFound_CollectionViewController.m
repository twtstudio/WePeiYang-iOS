//
//  LAFound_CollectionViewController.m
//  LostAndFound
//
//  Created by 马骁 on 14-4-16.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import "LAFound_CollectionViewController.h"
#import "LAFound_QueryListTableViewCell.h"
#import "LAFound_QueryDetailViewController.h"


@interface LAFound_CollectionViewController ()
{
    NSMutableArray *_collectionArray;
}

@end

@implementation LAFound_CollectionViewController

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
    
    self.title = @"收藏夹";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadDataArray];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 文件路径
- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"LAFound_Collection.plist"];
}

#pragma mark 读取数据

- (void)loadDataArray
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _collectionArray = [unArchiver decodeObjectForKey:@"LAFound_Collection"];
        [unArchiver finishDecoding];
    } else {
        _collectionArray = [[NSMutableArray alloc] initWithObjects: nil];
    }
}

- (void)saveDataArray
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_collectionArray forKey:@"LAFound_Collection"];
    [archiver finishEncoding];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self dataFilePath] error:nil];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

#pragma mark tableView的代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifie = @"cell";
    LAFound_QueryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifie];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"LAFound_QueryListTableViewCell" owner:self options:nil];
        cell = [array firstObject];
    }
    NSDictionary *dic = [_collectionArray objectAtIndex:([_collectionArray count]- 1 - indexPath.row)];
    cell.titleLabel.text = [dic valueForKey:@"title"];
    cell.placeLabel.text = [dic valueForKey:@"place"];
    cell.timeLabel.text = [dic valueForKey:@"time"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_collectionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LAFound_QueryDetailViewController *qdVC = [[LAFound_QueryDetailViewController alloc] init];
    qdVC.isCollectionDetail = YES;
    self.delegete = qdVC;
    [self.delegete LAFound_CollectionViewController:self ShowDetailByDataDic:[_collectionArray objectAtIndex:([_collectionArray count]- 1 - indexPath.row)]];
    [qdVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:qdVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_collectionArray removeObjectAtIndex:([_collectionArray count]- 1 - indexPath.row)];
    [self saveDataArray];
    NSArray *indexPaths = @[indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)backToHome
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
