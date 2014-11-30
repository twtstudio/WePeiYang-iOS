//
//  noticeTabBarController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-21.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "noticeTabBarController.h"
#import "NoticeViewController.h"
#import "NoticeFavViewController.h"
#import "data.h"

@interface noticeTabBarController ()

@end

@implementation noticeTabBarController

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
    // Do any additional setup after loading the view.
    
    NoticeViewController *noticeList = [[NoticeViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *noticeNav = [[UINavigationController alloc]initWithRootViewController:noticeList];
    NoticeFavViewController *noticeFav = [[NoticeFavViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *FavNav = [[UINavigationController alloc]initWithRootViewController:noticeFav];
    NSArray *arr = @[noticeNav,FavNav];
    self.viewControllers = arr;
    [[self.tabBar.items objectAtIndex:0]setTitle:@"校园公告"];
    [[self.tabBar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"n_notice.png"]];
    [[self.tabBar.items objectAtIndex:1]setTitle:@"收藏夹"];
    [[self.tabBar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"l_fav.png"]];
    self.selectedIndex = 0;
    [[UITabBar appearance]setTintColor:[UIColor colorWithRed:232/255.0f green:159/255.0f blue:0/255.0f alpha:1.0f]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item == [self.tabBar.items objectAtIndex:0])
    {
        self.title = @"校园公告";
    }
    else if (item == [self.tabBar.items objectAtIndex:1])
    {
        self.title = @"收藏夹";
    }
    /*
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.2f];
    [transition setType:@"fade"];
    [transition setSubtype:@"fromLeft"];
    [self.view.layer addAnimation:transition forKey:nil];
     */
}

@end
