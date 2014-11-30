//
//  LAFTabBarController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-16.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "LAFTabBarController.h"

@interface LAFTabBarController ()

@end

@implementation LAFTabBarController

{
    UIColor *lafTintColor;
}

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
    
    LAFound_QueryListViewController *qlVC = [[LAFound_QueryListViewController alloc] init];
    UINavigationController *qlVCNavigationViewController = [[UINavigationController alloc]initWithRootViewController:qlVC];
    
    LAFound_CollectionViewController *cVC = [[LAFound_CollectionViewController alloc] init];
    UINavigationController *cVCNavigationViewController = [[UINavigationController alloc] initWithRootViewController:cVC];
    
    lafTintColor = [UIColor colorWithRed:13/255.0f green:174/255.0f blue:124/255.0f alpha:1.0f];
    [[UITabBar appearance]setTintColor:lafTintColor];
    [[UIButton appearance]setTintColor:lafTintColor];
    [[UINavigationBar appearance]setTintColor:lafTintColor];
    [[UITextView appearance]setTintColor:lafTintColor];
    [[UITextField appearance]setTintColor:lafTintColor];
    [[UISegmentedControl appearance]setTintColor:lafTintColor];
    
    NSArray *controllers = @[qlVCNavigationViewController, cVCNavigationViewController];
    self.viewControllers = controllers;
    [[self.tabBar.items objectAtIndex:0] setTitle:@"查询"];
    [[self.tabBar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"l_search.png"]];
    //[[self.tabBar.items objectAtIndex:1] setTitle:@"发布"];
    //[[self.tabBar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"laf_post.png"]];
    [[self.tabBar.items objectAtIndex:1] setTitle:@"收藏"];
    [[self.tabBar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"l_fav.png"]];
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
