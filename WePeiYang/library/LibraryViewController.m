//
//  LibraryViewController.m
//  Library
//
//  Created by Qin Yubo on 13-11-4.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "LibraryViewController.h"
#import "LibraryTableCell.h"
#import "data.h"
#import "LoginViewController.h"
#import "RecordViewController.h"
#import "LibraryFavouriteViewController.h"
#import "UIButton+Bootstrap.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface LibraryViewController ()

@end

@implementation LibraryViewController

{
    NSInteger type;
    NSString *searchStr;

    NSInteger currentPage;
    NSInteger totalBooks;
    BOOL loginStatusChanged;
    NSString *username;
    NSString *password;

    UIAlertView *detailAlert;
    
    UIActionSheet *loginActionSheet;
    UIActionSheet *recordActionSheet;
    UIActionSheet *typeActionSheet;
    
    NSMutableArray *libraryData;
    NSDictionary *itemSelected;
}

@synthesize tableView;
@synthesize typeSegmentedControl;
@synthesize headerBackView;

@synthesize label1;
@synthesize label2;
@synthesize searchBar;

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
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tableView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.headerBackView.backgroundColor = [UIColor colorWithRed:0/255.0f green:181/255.0f blue:128/255.0f alpha:1.0f];
    
    //初始化
    type = 0;

    libraryData = [[NSMutableArray alloc]initWithObjects: nil];
    currentPage = 1;
    
    self.typeSegmentedControl.selectedSegmentIndex = 0;
    
    [tableView setBackgroundColor:[UIColor whiteColor]];
    //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIImageView *nilView = [[UIImageView alloc]initWithImage:nil];
    searchField.leftView = nilView;
}

- (IBAction)backToHome:(id)sender
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender
{
    [searchBar resignFirstResponder];
}

- (IBAction)typeChanged:(id)sender
{
    [searchBar resignFirstResponder];
    
    if ([sender selectedSegmentIndex] == 0)
    {
        type = 0;
        typeSegmentedControl.momentary = NO;
    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        type = 1;
        typeSegmentedControl.momentary = NO;
    }
    else if ([sender selectedSegmentIndex] == 2)
    {
        type = 2;
        typeSegmentedControl.momentary = NO;
    }
    else
    {
        typeSegmentedControl.momentary = YES;
        typeSegmentedControl.selectedSegmentIndex = 3;
        typeActionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择检索关键字的类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"主题",@"丛书",@"期刊期名", nil];
        [typeActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}


- (void)removeRecord:(id)sender
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"login"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:plistPath error:nil];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注销成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    self.title = @"您尚未登录";
}


- (void)search:(id)sender
{
    [searchBar resignFirstResponder];
    searchStr = searchBar.text;
    if ([searchStr isEqualToString: @""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"关键字不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        libraryData = [[NSMutableArray alloc]initWithObjects: nil];
        
        currentPage = 0;
        
        [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
        
        NSString *url = @"http://push-mobile.twtapps.net/lib/search";
        NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],
                                     @"query":searchStr,
                                     @"type":[NSString stringWithFormat:@"%ld",(long)type],
                                     @"platform":@"ios",
                                     @"version":[data shareInstance].appVersion};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *resultDic = [responseObject objectForKey:@"books"];
            totalBooks = [[responseObject objectForKey:@"total"]integerValue];
            [self dealWithReceivedSearchData:resultDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"获取书目失败T^T"];
        }];
    }
}

- (void)dealWithReceivedSearchData:(NSDictionary *)resultDic
{
    if ([resultDic count]>0)
    {
        for (NSDictionary *temp in resultDic)
        {
            [libraryData addObject:temp];
        }
        
        if ((currentPage+1) <= (totalBooks/20+1) && (totalBooks >= 20)) {
            [libraryData addObject:@"点击加载更多..."];
        }
        
        [self.tableView reloadData];
        [tableView setHidden:NO];
        [label1 setHidden:YES];
        [label2 setHidden:YES];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"未找到您需要的书目"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [libraryData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if ([[libraryData objectAtIndex:row] isKindOfClass:[NSString class]])
    {
        return 68;
    }
    else
    {
        //计算自适应行高
        NSString *title = [[libraryData objectAtIndex:row] objectForKey:@"title"];
        CGFloat width = self.tableView.frame.size.width;
        
        UILabel *gettingSizeLabel = [[UILabel alloc]init];
        gettingSizeLabel.text = title;
        gettingSizeLabel.numberOfLines = 0;
        gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize maxSize = CGSizeMake(width, 1000.0);
        
        CGSize size = [gettingSizeLabel sizeThatFits:maxSize];
        
        return 80 + size.height;
    }
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
    if ([[libraryData objectAtIndex:row] isKindOfClass:[NSString class]])
    {
        cell.titleLabel.text = [libraryData objectAtIndex:row];
        cell.authorLabel.text = @"";
        cell.positionYearLabel.text = @"";
        cell.leftLabel.text = @"";
    }
    else
    {
        NSDictionary *temp = [libraryData objectAtIndex:row];
        cell.titleLabel.text = [temp objectForKey:@"title"];
        cell.authorLabel.text = [temp objectForKey:@"author"];
        cell.positionYearLabel.text = [NSString stringWithFormat:@"%@ %@", [temp objectForKey:@"position"],[temp objectForKey:@"year"]];
        cell.leftLabel.text = [temp objectForKey:@"left"];
    }
    cell.cellBgImageView.hidden = NO;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    NSInteger row = [indexPath row];
    if ([[libraryData objectAtIndex:row] isKindOfClass:[NSString class]])
    {
        [libraryData removeObject:[libraryData lastObject]];
        [self nextPage];
    }
    else
    {
        NSDictionary *temp = [libraryData objectAtIndex:row];
        itemSelected = temp;
        
        detailAlert = [[UIAlertView alloc]initWithTitle:@"更多" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加到收藏",@"分享", nil];
        [detailAlert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)nextPage
{
    currentPage = currentPage + 1;
    [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
    NSString *url = @"http://push-mobile.twtapps.net/lib/search";
    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)currentPage],
                                 @"query":searchStr,
                                 @"type":[NSString stringWithFormat:@"%ld",(long)type],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = [responseObject objectForKey:@"books"];
        totalBooks = [[responseObject objectForKey:@"total"]integerValue];
        [self dealWithReceivedNextData:resultDic];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取书目失败T^T"];
    }];

}

- (void)dealWithReceivedNextData:(NSDictionary *)resultDic
{
    if ([resultDic count]>0)
    {
        for (NSDictionary *temp in resultDic)
        {
            [libraryData addObject:temp];
        }
        
        if ((currentPage+1) <= (totalBooks/20+1))
        {
            [libraryData addObject:@"点击加载更多..."];
        }
    }
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == detailAlert)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            nil;
        }
        else if (buttonIndex == 1)
        {
            [self addToFavourite];
        }
        else if (buttonIndex == 2)
        {
            [self share];
        }
    }
}

- (void)addToFavourite
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"libraryCollectionData"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSMutableDictionary *LibraryCollectionDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    if (LibraryCollectionDic == nil)
    {
        LibraryCollectionDic = [[NSMutableDictionary alloc]init];
    }
    NSDictionary *newDic = [[NSDictionary alloc]init];
    newDic = itemSelected;
    NSString *titleStr = [newDic objectForKey:@"title"];
    [LibraryCollectionDic setObject:newDic forKey:titleStr];
    [LibraryCollectionDic writeToFile:plistPath atomically:YES];
    
    [SVProgressHUD showSuccessWithStatus:@"书目收藏成功"];
}

- (void)share
{
    NSString *title = [itemSelected objectForKey:@"title"];
    NSString *position = [itemSelected objectForKey:@"position"];
    NSString *left = [itemSelected objectForKey:@"left"];
    NSString *shareString = [[NSString alloc]initWithFormat:@"%@ %@ %@",title,position,left];
    
    NSArray *activityItems = @[shareString];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self search:self];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:0/255.0f green:181/255.0f blue:128/255.0f alpha:1.0f];
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
