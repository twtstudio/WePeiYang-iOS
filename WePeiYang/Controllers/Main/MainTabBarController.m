//
//  MainTabBarController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/16.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "MainTabBarController.h"
#import "Chameleon.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.tabBar.tintColor = [UIColor flatTealColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isEqual:self.viewControllers[0]]) {
        self.tabBar.tintColor = [UIColor flatTealColor];
    }
    if ([viewController isEqual:self.viewControllers[1]]) {
        self.tabBar.tintColor = [UIColor flatPinkColorDark];
    }
    if ([viewController isEqual:self.viewControllers.lastObject]) {
        self.tabBar.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
