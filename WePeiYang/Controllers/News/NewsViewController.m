//
//  NewsViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/21.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewController.h"

@interface NewsViewController ()<NewsTableViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;

@end

@implementation NewsViewController {
    NSString *selectedIndex;
}

@synthesize pageContent;
@synthesize pageController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    pageContent = @[@1, @2, @3];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    pageController.dataSource = self;
    pageController.view.frame = self.view.frame;
    
    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:0]];
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return nil;
    }
    NewsTableViewController *tableController = [[NewsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableController.delegate = self;
    tableController.tag = [pageContent[index] integerValue];
    return tableController;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    return [pageContent indexOfObject:[NSNumber numberWithInteger:((NewsTableViewController *)viewController).tag]];
}

#pragma mark - UIPageViewController DataSource

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
    
    
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - NewsTableDelegate

- (void)pushContentWithIndex:(NSString *)index {
    selectedIndex = index;
    [self performSegueWithIdentifier:@"pushContent" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushContent"]) {
        
    }
}

@end
