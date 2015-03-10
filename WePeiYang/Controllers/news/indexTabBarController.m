//
//  indexTabBarController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-20.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "indexTabBarController.h"
#import "IndexViewController.h"
#import "data.h"

@interface indexTabBarController ()

@end

@implementation indexTabBarController

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
    IndexViewController *newsIndex = [[IndexViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *newsNav = [[UINavigationController alloc]initWithRootViewController:newsIndex];
    
    IndexViewController *lookIndex = [[IndexViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *lookNav = [[UINavigationController alloc]initWithRootViewController:lookIndex];
    
    IndexViewController *collegeIndex = [[IndexViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *collegeNav = [[UINavigationController alloc]initWithRootViewController:collegeIndex];
    
    IndexViewController *leagueIndex = [[IndexViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *leagueNav = [[UINavigationController alloc]initWithRootViewController:leagueIndex];
    
    NSArray *arr = @[newsNav,lookNav,collegeNav,leagueNav];
    self.viewControllers = arr;
    
    [[self.tabBar.items objectAtIndex:0] setTitle:@"天大要闻"];
    [[self.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"news_n.png"]];
    
    [[self.tabBar.items objectAtIndex:1] setTitle:@"视点观察"];
    [[self.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"look.png"]];
    
    [[self.tabBar.items objectAtIndex:2] setTitle:@"院系动态"];
    [[self.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"college.png"]];
    
    [[self.tabBar.items objectAtIndex:3] setTitle:@"社团风采"];
    [[self.tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"league.png"]];
    
    self.tabBarController.selectedIndex = 0;
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:255/255.0f green:55/255.0f blue:156/255.0f alpha:1.0f]];
    [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:255/255.0f green:55/255.0f blue:156/255.0f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];//This is important!
    //不执行super方法会导致动画丢失！
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [data shareInstance].typeSelected = @"1";
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item == [tabBar.items objectAtIndex:0])
    {
        [data shareInstance].typeSelected = @"1";
    }
    else if (item == [tabBar.items objectAtIndex:1])
    {
        [data shareInstance].typeSelected = @"5";
    }
    else if (item == [tabBar.items objectAtIndex:2])
    {
        [data shareInstance].typeSelected = @"4";
    }
    else if (item == [tabBar.items objectAtIndex:3])
    {
        [data shareInstance].typeSelected = @"3";
    }
    /*
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.2f];
    [transition setType:@"fade"];
    [transition setSubtype:@"fromLeft"];
    [self.view.layer addAnimation:transition forKey:nil];
     */
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
