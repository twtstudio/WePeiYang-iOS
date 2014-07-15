//
//  AboutUSViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-18.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "AboutUSViewController.h"
//#import "eggViewController.h"
#import "VWWWaterView.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

{
    BOOL btn1Pressed;
    BOOL btn2Pressed;
    BOOL btn3Pressed;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
	// Do any additional setup after loading the view.
    //btn1Pressed = NO;
    //btn2Pressed = NO;
    //btn3Pressed = NO;
    
    //UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //scroll.delegate = self;
    //scroll.pagingEnabled = NO;
    /*
    NSString *path = [[NSBundle mainBundle]pathForResource:@"aboutUS@2x" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    [scroll setContentSize:[image size]];
    [scroll addSubview:imgView];
     */
    
    /*
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setFrame:CGRectMake(55, 893, 32, 32)];
    [btn1 addTarget:self action:@selector(btn1Press) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setFrame:CGRectMake(100, 893, 32, 32)];
    [btn2 addTarget:self action:@selector(btn2Press) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setFrame:CGRectMake(231, 893, 32, 32)];
    [btn3 addTarget:self action:@selector(btn3Press) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:btn3];
     */
    
    //[scroll setContentSize:CGSizeMake(self.view.frame.size.width, 750)];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"wpyicon@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    [imgView setFrame:CGRectMake(115, 80, 90, 90)];
    [self.view addSubview:imgView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, 320, 40)];
    [nameLabel setText:@"微北洋 1.2.1"];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    
    UILabel *twtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, 320, 40)];
    [twtLabel setTextAlignment:NSTextAlignmentCenter];
    [twtLabel setText:@"天外天工作室"];
    [self.view addSubview:twtLabel];
    
    int justAConst = 60;
    VWWWaterView *waterView = [[VWWWaterView alloc]initWithFrame:CGRectMake(0, justAConst, self.view.frame.size.width, self.view.frame.size.height - justAConst)];
    [self.view addSubview:waterView];
    
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"zhanshanlogo@2x" ofType:@"png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path2];
    UIImageView *imgView2 = [[UIImageView alloc]initWithImage:image2];
    int imgheight = 240;
    if (DEVICE_IS_IPHONE5)
        imgheight = 240;
    else
        imgheight = 240*0.6;
    [imgView2 setFrame:CGRectMake(0.5*(self.view.frame.size.width - 320*imgheight/240), self.view.frame.size.height - imgheight, 320*imgheight/240, imgheight)];
    [self.view addSubview:imgView2];
    
    
    //[self.view addSubview:scroll];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setFrame:CGRectMake(0, 20, 40, 40)];
    //[backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    /*
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *arr = @[back,flexItem];
    [self setToolbarItems:arr animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
     */
    
}

/*
- (void)btn1Press
{
    btn1Pressed = YES;
}

- (void)btn2Press
{
    if (btn1Pressed == YES)
    {
        btn2Pressed = YES;
    }
}

- (void)btn3Press
{
    if (btn1Pressed == YES && btn2Pressed == YES)
    {
        [self pushEgg];
        btn1Pressed = NO;
        btn2Pressed = NO;
        btn3Pressed = NO;
    }
}

- (void)pushEgg
{
    eggViewController *twtEgg = [[eggViewController alloc]init];
    [twtEgg setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentViewController:twtEgg animated:YES completion:nil];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
