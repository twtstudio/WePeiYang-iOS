//
//  NewsViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/21.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewController.h"
#import "Chameleon.h"
#import "NewsContentViewController.h"
#import "NewsData.h"

@interface NewsViewController ()

@end

@implementation NewsViewController {
    NewsData *selectedNewsData;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self) {
        self.viewControllerClasses = @[[NewsTableViewController class], [NewsTableViewController class], [NewsTableViewController class], [NewsTableViewController class], [NewsTableViewController class]];
        self.titles = @[@"天大要闻", @"校园公告", @"社团风采", @"院系动态", @"视点观察"];
        // KVO value passing
        self.keys = [@[@"type", @"type", @"type", @"type", @"type"] mutableCopy];
        self.values = [@[@1, @2, @3, @4, @5] mutableCopy];
        
        // customization
        self.pageAnimatable = YES;
        self.titleSizeSelected = 15.0;
        self.titleSizeNormal = 15.0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleColorSelected = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        self.titleColorNormal = [UIColor darkGrayColor];
        self.menuItemWidth = 100;
        self.bounces = YES;
        self.menuHeight = MENU_VIEW_HEIGHT;
        self.menuViewBottomSpace = -(self.menuHeight + 64.0);
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name: PUSH_NOTIFICATION object:nil];
//    self.navigationController.navigationBar.tintColor = [UIColor flatTealColor];
    
    // Appearance Customization
    self.menuView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.menuView.layer.shadowOffset = CGSizeMake(0, 0.1);
    self.menuView.layer.shadowOpacity = 1;
    self.menuView.layer.shadowRadius = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
     
#pragma mark - Private Method
     
- (void)notificationHandler:(NSNotification *)notification {
    selectedNewsData = notification.object;
    [self performSegueWithIdentifier:@"pushContent" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushContent"]) {
        NewsContentViewController *vc = (NewsContentViewController *)segue.destinationViewController;
        vc.newsData = selectedNewsData;
    }
}

@end
