//
//  PartyScoreViewController.m
//  WePeiYang
//
//  Created by JinHongxu on 16/8/14.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "PartyScoreViewController.h"
#import "WePeiYang-Swift.h"
#import "MsgDisplay.h"

#define partyRed [UIColor colorWithRed:240.0/255.0 green:22.0/255.0 blue:22.0/255.0 alpha:1]
#define partyPink [UIColor colorWithRed:255.0/255.0 green:64.0/255.0 blue:168.0/255.0 alpha:1]

@interface PartyScoreViewController ()

@end

@implementation PartyScoreViewController


- (instancetype)init {
    
    self = [super init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self) {
        self.viewControllerClasses = @[[TwentyCourseScoreViewController class], [GradeCheckViewController class], [GradeCheckViewController class], [GradeCheckViewController class]];
        self.titles = @[@"20课时成绩", @"结业考试成绩", @"院级积极分子成绩", @"预备党员党校成绩"];
        self.keys = [@[@"type", @"type"] mutableCopy];
        self.values = [@[@0, @1] mutableCopy];
        
        // customization
        self.pageAnimatable = YES;
        self.titleSizeSelected = 14.0;
        self.titleSizeNormal = 13.0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = [UIColor whiteColor];
        self.menuItemWidth = self.view.frame.size.width/3;
        
        self.bounces = YES;
        //self.menuHeight = 44;
        self.menuViewBottomSpace = -(self.menuHeight + 64.0);
        
    }
    return self;
}

- (void)viewDidLoad {
    
    //MenuBar设置
    self.menuBGColor = partyRed;
    self.progressColor = partyPink;
    self.progressHeight = 3.0;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //NavigationBar 的文字
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //NavigationBar 的背景，使用了View
    self.navigationController.jz_navigationBarBackgroundAlpha = 0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height)];
    view.backgroundColor = partyRed;
    view.tag = 1;
    [self.view addSubview:view];
    
    //改变 statusBar 颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
