//
//  ReadViewController.m
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/24.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "ReadViewController.h"
#import "WePeiYang-Swift.h"
#import "MsgDisplay.h"
#define readRed [UIColor colorWithRed:234.0/255.0 green:74.0/255.0 blue:70/255.0 alpha:1.0]
@interface ReadViewController()
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation ReadViewController

- (instancetype)init {
    
    self = [super init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self) {
        self.viewControllerClasses = @[[RecommendedViewController class], [UIViewController class]];
        self.titles = @[@"推荐", @"我的"];
        self.keys = [@[@"type"] mutableCopy];
        self.values = [@[@0] mutableCopy];
        
        // customization
        self.pageAnimatable = YES;
        self.titleSizeSelected = 16.0;
        self.titleSizeNormal = 15.0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleColorSelected = readRed;
        self.titleColorNormal = [UIColor grayColor];
        self.menuItemWidth = self.view.frame.size.width/2;
        
        self.bounces = YES;
        self.menuHeight = 44;
        self.menuViewBottomSpace = -(self.menuHeight + 64.0);
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //NavigationBar 的文字
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //NavigationBar 的背景，使用了View
    self.navigationController.jz_navigationBarBackgroundAlpha = 0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height)];
    view.backgroundColor = readRed;
    view.tag = 1;
    [self.view addSubview:view];
    
    
    //改变 statusBar 颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //title label
    //titleLabel设置
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleLabel;
    self.titleLabel.text = @"阅北洋";
    [self.titleLabel sizeToFit];
    
    //search button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pushSearchViewController)];
}

- (void)pushSearchViewController {
    NSLog(@"student");
}

- (void)viewDidLoad {
    
    //MenuBar设置
    self.menuBGColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.progressColor = readRed;
    self.progressHeight = 3.0;
    
    [super viewDidLoad];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //BicycleUser.sharedInstance.bindCancel = NO;
    
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end