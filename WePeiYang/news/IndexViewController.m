//
//  IndexViewController.m
//  News
//
//  Created by Qin Yubo on 13-10-11.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "IndexViewController.h"
#import "data.h"
#import "DetailViewController.h"
#import "CollectionViewController.h"
#import "wpyWebConnection.h"
#import "CSNotificationView.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface IndexViewController ()

@end

@implementation IndexViewController

{
    NSInteger currentPage;
    NSString *type;
    
    NSMutableArray *dataInTable;
    NSMutableArray *newsData;
    
    NSMutableArray *titleInTable;
    
    UIAlertView *waitingAlert;
}

//@synthesize response;
//@synthesize delegate;

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
    
    newsData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];
    
    [self refresh:self];
    
    UIBarButtonItem *pushCollection = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(collection:)];
    [self.navigationItem setRightBarButtonItem:pushCollection];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    //下面这段代码自定义NavigationBar
    //
    
    //[[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0f green:138/255.0f blue:185/255.0f alpha:1.0f];
    //self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:55/255.0f blue:156/255.0f alpha:1.0f];
    
    //下面开始写下拉刷新的代码
    
    //注意：显示数组与数据数组一定要区分开！
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //self.navigationController.toolbarHidden = NO;
}

- (void)backToHome
{
    //我也不知道为什么不过如果不写下面这一行就会出现很奇怪的错误
    //2014.4.18 想明白了……下面这行必须加上
    [data shareInstance].typeSelected = @"1";
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)collection:(id)sender
{
    CollectionViewController *collectionVC = [[CollectionViewController alloc]initWithStyle:UITableViewStylePlain];
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView:(UIRefreshControl *)refreshControl
{
    if(refreshControl.refreshing)
    {
        refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在加载..."];
        //[self performSelector:@selector(refresh:) withObject:nil afterDelay:0];
        [self refresh:self];
    }
}

- (void)refresh:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    newsData = [[NSMutableArray alloc]init];
    dataInTable = [[NSMutableArray alloc]init];
    
    currentPage = 0;
    
    type = [data shareInstance].typeSelected;
    
    
    if ([data shareInstance].typeSelected == nil)
    {
        type = @"1";
    }
    else
    {
        type = [data shareInstance].typeSelected;
    }
    
    if ([type isEqual:@"1"])
    {
        self.navigationItem.title = @"天大要闻";
    }
    else if ([type isEqual:@"5"])
    {
        self.navigationItem.title = @"视点观察";
    }
    else if ([type isEqual:@"3"])
    {
        self.navigationItem.title = @"社团风采";
    }
    else if ([type isEqual:@"4"])
    {
        self.navigationItem.title = @"院系动态";
    }
    
    /*
    NSError *error;
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://service.twtstudio.com/phone/android/get_news_list.php?page=%ld&platform=ios&type=%@&version=%@",(long)currentPage,type,[data shareInstance].appVersion];
    [wpyWebConnection getDataFromURLStr:urlString withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic != nil) [self processIndexData:dic];
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
            [self.refreshControl endRefreshing];
        }
    }];
     */
    
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSString *body = [NSString stringWithFormat:@"ctype=news&page=%ld&ntype=%@",(long)currentPage,type];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if (![[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
            {
                //NSString *msg = [dic objectForKey:@"msg"];
            }
            else
            {
                NSDictionary *contentDic = [dic objectForKey:@"content"];
                /*
                NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"newsType%@CacheData",type]];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:plistPath])
                {
                    [fileManager removeItemAtPath:plistPath error:nil];
                }
                else
                {
                    [contentDic writeToFile:plistPath atomically:YES];
                }
                 */
                
                [self processIndexData:contentDic];
            }
        }
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前没有网络连接哦~"];
            [self.refreshControl endRefreshing];
            /*
            NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"newsType%@CacheData",type]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:plistPath])
            {
                [self processIndexData:[[NSDictionary alloc]initWithContentsOfFile:plistPath]];
            }
             */
        }
    }];
}

- (void)processIndexData:(NSDictionary *)newsDic
{
    if ([newsDic count]>0)
    {
        for (NSDictionary *temp in newsDic)
        {
            //[newsTitle addObject:[temp objectForKey:@"subject"]];
            //[newsId addObject:[temp objectForKey:@"index"]];
            [newsData addObject:temp];
        }
    }
    
    dataInTable = newsData;
    [dataInTable addObject:@"点击加载更多..."];
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

//这里添加方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataInTable count];
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
    if (row != [dataInTable count]-1)
    {
        NSDictionary *tmp = [dataInTable objectAtIndex:row];
        cell.textLabel.text = [tmp objectForKey:@"subject"];
        cell.textLabel.numberOfLines = 2;
    }
    else
    {
        NSString *last = [dataInTable lastObject];
        cell.textLabel.text = last;
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)nextPage:(id)sender
{
    currentPage = currentPage + 1;
    NSString *url = @"http://push-mobile.twtapps.net/content/list";
    NSString *body = [NSString stringWithFormat:@"ctype=news&page=%ld&ntype=%@",(long)currentPage,type];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if (dic!=nil)
        {
            if ([[dic objectForKey:@"error"]boolValue]==true)
            {
                NSString *msg = [dic objectForKey:@"msg"];
            }
            else
            {
                NSDictionary *contentDic = [dic objectForKey:@"content"];
                [self processIndexData:contentDic];
            }
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (row == [dataInTable count] - 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //[newsTitle removeObject:[newsTitle lastObject]];
        [dataInTable removeObject:[dataInTable lastObject]];
        [self nextPage:self];
    }
    else
    {
        NSDictionary *temp = [dataInTable objectAtIndex:row];
        NSString *rowSelected = [temp objectForKey:@"subject"];
        NSString *idSelected = [temp objectForKey:@"index"];
        [data shareInstance].newsTitle = rowSelected;
        [data shareInstance].newsId = idSelected;
        
        DetailViewController *detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
        //[self.tabBarController.navigationController pushViewController:detailViewController animated:YES];
        //[delegate push];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

@end
