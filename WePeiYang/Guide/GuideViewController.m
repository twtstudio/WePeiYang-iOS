//
//  GuideViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-1-8.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "GuideViewController.h"
#import "twtLoginViewController.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface GuideViewController ()

@end

@implementation GuideViewController

{
    UIScrollView *guideView;
    UIPageControl *pageControl;
    UIButton *enterBtn;
    UIButton *loginBtn;
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

    NSInteger numberOfPages = 3;
    
    guideView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [guideView setContentSize:CGSizeMake(self.view.frame.size.width * numberOfPages, self.view.frame.size.height)];
    [guideView setPagingEnabled:YES];
    [guideView setShowsHorizontalScrollIndicator:NO];
    [guideView setDelegate:self];
    
    UIImageView *gImg1;
    NSString *imagePath;
    if (DEVICE_IS_IPHONE5)
    {
        imagePath = [[NSBundle mainBundle]pathForResource:@"g1-568h@2x" ofType:@"jpg"];
    }
    else
    {
        imagePath = [[NSBundle mainBundle]pathForResource:@"g1@2x" ofType:@"jpg"];
    }
    gImg1 = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
    [gImg1 setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [guideView addSubview:gImg1];
    
    
    UIImageView *gImg2;
    NSString *imagePath2;
    if (DEVICE_IS_IPHONE5)
    {
        imagePath2 = [[NSBundle mainBundle]pathForResource:@"g2-568h@2x" ofType:@"jpg"];
    }
    else
    {
        imagePath2 = [[NSBundle mainBundle]pathForResource:@"g2@2x" ofType:@"jpg"];
    }
    gImg2 = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:imagePath2]];
    [gImg2 setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [guideView addSubview:gImg2];
    
    UIImageView *gImg3;
    NSString *imagePath3;
    if (DEVICE_IS_IPHONE5)
    {
        imagePath3 = [[NSBundle mainBundle]pathForResource:@"g3-568h@2x" ofType:@"jpg"];
    }
    else
    {
        imagePath3 = [[NSBundle mainBundle]pathForResource:@"g3@2x" ofType:@"jpg"];
    }
    gImg3 = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:imagePath3]];
    [gImg3 setFrame:CGRectMake(2 * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [guideView addSubview:gImg3];
    
    NSInteger pcHeight;
    NSInteger ebHeight;
    if (DEVICE_IS_IPHONE5)
    {
        pcHeight = 20;
        ebHeight = 80;
    }
    else
    {
        pcHeight = 15;
        ebHeight = 75;
    }
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake( self.view.frame.size.width/2, (self.view.frame.size.height - pcHeight), 0, 0)];
    [pageControl setNumberOfPages:numberOfPages];
    [pageControl setUserInteractionEnabled:NO];
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        NSInteger btnWidth = 120;
        NSInteger btnHeight = 40;
        
        loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [loginBtn setFrame:CGRectMake((numberOfPages-1)*self.view.frame.size.width+(self.view.frame.size.width - 2*btnWidth)/3, self.view.frame.size.height - ebHeight, btnWidth, btnHeight)];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"button-background.png"] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        enterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [enterBtn setFrame:CGRectMake((numberOfPages-1)*self.view.frame.size.width+2*(self.view.frame.size.width - 2*btnWidth)/3+btnWidth, self.view.frame.size.height - ebHeight, btnWidth, btnHeight)];
        [enterBtn setBackgroundImage:[UIImage imageNamed:@"button-background.png"] forState:UIControlStateNormal];
        [enterBtn setTitle:@"进入 微北洋" forState:UIControlStateNormal];
        [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [enterBtn addTarget:self action:@selector(enterWPY) forControlEvents:UIControlEventTouchUpInside];
        
        [guideView addSubview:enterBtn];
        [guideView addSubview:loginBtn];
    }
    else
    {
        NSInteger btnWidth = 260;
        NSInteger btnHeight = 40;
        enterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [enterBtn setFrame:CGRectMake((numberOfPages-1)*self.view.frame.size.width+(self.view.frame.size.width - btnWidth)/2, self.view.frame.size.height - ebHeight, btnWidth, btnHeight)];
        [enterBtn setBackgroundImage:[UIImage imageNamed:@"button-background.png"] forState:UIControlStateNormal];
        [enterBtn setTitle:@"进入 微北洋" forState:UIControlStateNormal];
        [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [enterBtn addTarget:self action:@selector(enterWPY) forControlEvents:UIControlEventTouchUpInside];
        [guideView addSubview:enterBtn];
    }

    self.view.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    pageControl.currentPage = offset.x / (self.view.bounds.size.width);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:guideView];
    [self.view addSubview:pageControl];
}

- (void)enterWPY
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login
{
    twtLoginViewController *twtLogin = [[twtLoginViewController alloc]initWithNibName:nil bundle:nil];
    [twtLogin setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:twtLogin animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
