//
//  LibraryTabBarController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-4-10.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "LibraryTabBarController.h"
#import "LibraryFavouriteViewController.h"
#import "LibraryViewController.h"
#import "RecordViewController.h"

@interface LibraryTabBarController ()

@end

@implementation LibraryTabBarController

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
    
    //[[UIView appearance]setTintColor:[UIColor colorWithRed:0/255.0f green:181/255.0f blue:128/255.0f alpha:1.0f]];
    
    LibraryViewController *library = [[LibraryViewController alloc]initWithNibName:nil bundle:nil];
    LibraryFavouriteViewController *libraryFavourite = [[LibraryFavouriteViewController alloc]initWithNibName:nil bundle:nil];
    RecordViewController *record = [[RecordViewController alloc]initWithNibName:nil bundle:nil];
    NSArray *viewControllerArr = @[library,libraryFavourite,record];
    self.viewControllers = viewControllerArr;
    
    [[self.tabBar.items objectAtIndex:0]setTitle:@"图书检索"];
    [[self.tabBar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"l_search.png"]];
    [[self.tabBar.items objectAtIndex:1]setTitle:@"收藏夹"];
    [[self.tabBar.items objectAtIndex:1]setImage:[UIImage imageNamed:@"l_fav.png"]];
    [[self.tabBar.items objectAtIndex:2]setTitle:@"记录"];
    [[self.tabBar.items objectAtIndex:2]setImage:[UIImage imageNamed:@"l_record.png"]];
    self.selectedIndex = 0;
    
    UIColor *libTintColor = [UIColor colorWithRed:0/255.0f green:181/255.0f blue:128/255.0f alpha:1.0f];
    [[UITabBar appearance]setTintColor: libTintColor];
    [[UIButton appearance]setTintColor:[UIColor whiteColor]];
    [[UISearchBar appearance]setTintColor:[UIColor whiteColor]];
    [[UITextField appearance]setTintColor:[UIColor whiteColor]];
    [[UISegmentedControl appearance]setTintColor:[UIColor whiteColor]];
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
