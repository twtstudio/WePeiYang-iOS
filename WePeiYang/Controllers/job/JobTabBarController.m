//
//  JobTabBarController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-12.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "JobTabBarController.h"
#import "JobViewController.h"
#import "HiringViewController.h"
#import "data.h"

@interface JobTabBarController ()

@end

@implementation JobTabBarController

{
    UIColor *jobTintColor;
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
    JobViewController *jobs = [[JobViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *jobNav = [[UINavigationController alloc]initWithRootViewController:jobs];
    HiringViewController *hiring = [[HiringViewController alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *hiringNav = [[UINavigationController alloc]initWithRootViewController:hiring];
    NSArray *arr = @[jobNav,hiringNav];
    
    jobTintColor = [UIColor colorWithRed:149/255.0f green:82/255.0f blue:235/255.0f alpha:1.0f];
    [[UITabBar appearance]setTintColor:jobTintColor];
    [[UINavigationBar appearance]setTintColor:jobTintColor];
    
    self.viewControllers = arr;
    [[self.tabBar.items objectAtIndex:0]setTitle:@"就业资讯"];
    [[self.tabBar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"jobs_tab.png"]];
    [[self.tabBar.items objectAtIndex:1]setTitle:@"校园招聘"];
    [[self.tabBar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"hiring.png"]];
    self.selectedIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
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
