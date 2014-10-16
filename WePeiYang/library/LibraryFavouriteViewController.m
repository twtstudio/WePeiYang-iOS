//
//  LibraryFavouriteViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-14.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "LibraryFavouriteViewController.h"
#import "LibraryTableCell.h"

@interface LibraryFavouriteViewController ()

@end

@implementation LibraryFavouriteViewController

{
    NSArray *titleArray;
    NSArray *yearArray;
    NSArray *positionArray;
    NSArray *authorArray;
    NSArray *leftArray;
    
    NSDictionary *collectionDic;
}

@synthesize tableView;
@synthesize noFavLabel;
@synthesize headerBackView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"收藏夹";
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    headerBackView.backgroundColor = [UIColor colorWithRed:0/255.0f green:181/255.0f blue:128/255.0f alpha:1.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryCollectionData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    collectionDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    titleArray = [collectionDic allKeys];
    if ([titleArray count]==0)
    {
        [noFavLabel setHidden:NO];
        [tableView setHidden:YES];
    }
    else
    {
        [noFavLabel setHidden:YES];
        [tableView setHidden:NO];
        [tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    //计算自适应行高
    NSString *title = [titleArray objectAtIndex:row];
    CGFloat width = self.tableView.frame.size.width;
    
    UILabel *gettingSizeLabel = [[UILabel alloc]init];
    gettingSizeLabel.text = title;
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maxSize = CGSizeMake(width, 1000.0);
    
    CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
    
    return 80 + size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableIdentifier";
    LibraryTableCell *cell = (LibraryTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LibraryTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    NSString *title = [titleArray objectAtIndex:row];

    NSDictionary *dic = [collectionDic objectForKey:title];
    cell.titleLabel.text = title;
    cell.authorLabel.text = [dic objectForKey:@"author"];
    cell.positionYearLabel.text = [[NSString alloc]initWithFormat:@"%@，%@",[dic objectForKey:@"position"],[dic objectForKey:@"year"]];
    cell.leftLabel.text = [dic objectForKey:@"left"];
    cell.cellBgImageView.hidden = NO;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)deleteFromCollectionByTitle:(NSString *)title
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryCollectionData"];
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
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryCollectionData"];
    NSDictionary *collectionDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    titleArray = [collectionDic allKeys];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    if ([titleArray count]==0)
    {
        [noFavLabel setHidden:NO];
        [tableView setHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)backToHome:(id)sender
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
