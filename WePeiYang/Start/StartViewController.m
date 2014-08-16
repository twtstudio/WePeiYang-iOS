//
//  StartViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-1-9.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "StartViewController.h"
#import "GuideViewController.h"
#import "YViewController.h"
#import "LibraryViewController.h"
#import "GPAViewController.h"
#import "JobViewController.h"
#import "NoticeViewController.h"
#import "AboutViewController.h"
//#import "Animations.h"
#import "DMScaleTransition.h"
#import "data.h"
#import "wpyDeviceStatus.h"
#import "wpyWebConnection.h"
#import "twtLoginViewController.h"

#import "indexTabBarController.h"
#import "noticeTabBarController.h"
#import "LibraryTabBarController.h"
#import "JobTabBarController.h"
#import "LAFTabBarController.h"
#import "wpyEncryption.h"
#import "twtSecretKeys.h"

//#import "WePeiYang-Swift.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)
#define DEVICE_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface StartViewController ()

@property (strong, nonatomic) DMScaleTransition *scaleTransition;

@end

@implementation StartViewController

@synthesize scaleTransition;

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
    
    //获取当前App版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [data shareInstance].appVersion = appVersion;
    
    self.title = @"微北洋";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashboard_bg.png"]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"studysearchbg.png"]];
    //self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    //[self sendInstallData];
    [self checkGuideStatus];
    [self checkLoginStatus];
    
    int addedSpace = DEVICE_IS_IPHONE5?26:0;
    
    //行距
    int heightBetweenLines = DEVICE_IS_IPHONE5?30:20;
    int heightOfContentSize = DEVICE_IS_IPHONE5?548:460;
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scroll.delegate = self;
    [scroll setContentSize:CGSizeMake(320, heightOfContentSize)];
    
    UIButton *studySearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [studySearchBtn setFrame:CGRectMake(20, 40+addedSpace, 80, 120)];
    [studySearchBtn setImage:[UIImage imageNamed:@"studysearch.png"] forState:UIControlStateNormal];
    //NSString *ssImagePath = [[NSBundle mainBundle] pathForResource:@"studysearch_s@2x" ofType:@"png"];
    //[studySearchBtn setImage:[UIImage imageWithContentsOfFile:ssImagePath] forState:UIControlStateHighlighted];
    [studySearchBtn addTarget:self action:@selector(pushStudySearch) forControlEvents:UIControlEventTouchUpInside];
    //[studySearchBtn setAlpha:0.0f];
    [scroll addSubview:studySearchBtn];
    
    UIButton *newsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsBtn setFrame:CGRectMake(120, 40+addedSpace, 80, 120)];
    [newsBtn setImage:[UIImage imageNamed:@"news.png"] forState:UIControlStateNormal];
    //NSString *nImagePath = [[NSBundle mainBundle] pathForResource:@"news_s@2x" ofType:@"png"];
    //[newsBtn setImage:[UIImage imageWithContentsOfFile:nImagePath] forState:UIControlStateHighlighted];
    [newsBtn addTarget:self action:@selector(pushNews) forControlEvents:UIControlEventTouchUpInside];
    //[newsBtn setAlpha:0.0f];
    [scroll addSubview:newsBtn];
    
    UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [noticeBtn setFrame:CGRectMake(220, 40+addedSpace, 80, 120)];
    [noticeBtn setImage:[UIImage imageNamed:@"notice.png"] forState:UIControlStateNormal];
    //NSString *noImagePath = [[NSBundle mainBundle] pathForResource:@"notice_s@2x" ofType:@"png"];
    //[noticeBtn setImage:[UIImage imageWithContentsOfFile:noImagePath] forState:UIControlStateHighlighted];
    [noticeBtn addTarget:self action:@selector(pushNotice) forControlEvents:UIControlEventTouchUpInside];
    //[noticeBtn setAlpha:0.0f];
    [scroll addSubview:noticeBtn];
    
    UIButton *gpaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gpaBtn setFrame:CGRectMake(20, 160+heightBetweenLines+addedSpace, 80, 120)];
    [gpaBtn setImage:[UIImage imageNamed:@"gpa.png"] forState:UIControlStateNormal];
    //NSString *gImagePath = [[NSBundle mainBundle] pathForResource:@"gpa_s@2x" ofType:@"png"];
    //[gpaBtn setImage:[UIImage imageWithContentsOfFile:gImagePath] forState:UIControlStateHighlighted];
    [gpaBtn addTarget:self action:@selector(pushGPA) forControlEvents:UIControlEventTouchUpInside];
    //[gpaBtn setAlpha:0.0f];
    [scroll addSubview:gpaBtn];
    
    UIButton *libraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [libraryBtn setFrame:CGRectMake(120, 160+heightBetweenLines+addedSpace, 80, 120)];
    [libraryBtn setImage:[UIImage imageNamed:@"library.png"] forState:UIControlStateNormal];
    //NSString *liImagePath = [[NSBundle mainBundle] pathForResource:@"library_s@2x" ofType:@"png"];
    //[libraryBtn setImage:[UIImage imageWithContentsOfFile:liImagePath] forState:UIControlStateHighlighted];
    [libraryBtn addTarget:self action:@selector(pushLibrary) forControlEvents:UIControlEventTouchUpInside];
    //[libraryBtn setAlpha:0.0f];
    [scroll addSubview:libraryBtn];
    
    UIButton *jobBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [jobBtn setFrame:CGRectMake(220, 160+heightBetweenLines+addedSpace, 80, 120)];
    [jobBtn setImage:[UIImage imageNamed:@"jobs.png"] forState:UIControlStateNormal];
    //NSString *jImagePath = [[NSBundle mainBundle] pathForResource:@"jobs_s@2x" ofType:@"png"];
    //[jobBtn setImage:[UIImage imageWithContentsOfFile:jImagePath] forState:UIControlStateHighlighted];
    [jobBtn addTarget:self action:@selector(pushJobs) forControlEvents:UIControlEventTouchUpInside];
    //[jobBtn setAlpha:0.0f];
    [scroll addSubview:jobBtn];
    
    UIButton *lafBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lafBtn setFrame:CGRectMake(20, 280+2*heightBetweenLines+addedSpace, 80, 120)];
    [lafBtn setImage:[UIImage imageNamed:@"laf.png"] forState:UIControlStateNormal];
    [lafBtn addTarget:self action:@selector(pushLostAndFound) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:lafBtn];
    
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutBtn setFrame:CGRectMake(120, 280+2*heightBetweenLines+addedSpace, 80, 120)];
    [aboutBtn setImage:[UIImage imageNamed:@"about.png"] forState:UIControlStateNormal];
    //NSString *aImagePath = [[NSBundle mainBundle] pathForResource:@"about_s@2x" ofType:@"png"];
    //[aboutBtn setImage:[UIImage imageWithContentsOfFile:aImagePath] forState:UIControlStateHighlighted];
    [aboutBtn addTarget:self action:@selector(pushAbout) forControlEvents:UIControlEventTouchUpInside];
    //[aboutBtn setAlpha:0.0f];
    [scroll addSubview:aboutBtn];
    
    [self.view addSubview:scroll];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkGuideStatus
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"guide1.2.0Loaded"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath]) //初次启动
    {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        
        NSArray *oldFilesArray = @[@"guide1.2Loaded",@"guide1.1.3Loaded",@"login",@"gpa"];
        for (NSString *guideName in oldFilesArray)
        {
            NSString *oldVersionGuide = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:guideName];
            if ([fileManager fileExistsAtPath:oldVersionGuide])
            {
                [fileManager removeItemAtPath:oldVersionGuide error:nil];
            }
        }
        
        GuideViewController *guide = [[GuideViewController alloc]init];
        scaleTransition = [[DMScaleTransition alloc]init];
        [guide setTransitioningDelegate:scaleTransition];
        [self presentViewController:guide animated:YES completion:nil];
    }
}

- (void)checkLoginStatus
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        //未登录
        
    }
    else
    {
        NSData *savedData = [[NSData alloc]initWithContentsOfFile:plistPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:savedData];
        
        NSData *secretId = [unarchiver decodeObjectForKey:@"id"];
        NSData *secretToken = [unarchiver decodeObjectForKey:@"token"];
        [unarchiver finishDecoding];
        
        NSString *key = [twtSecretKeys getSecretKey];
        NSData *plainId = [secretId AES256DecryptWithKey:key];
        NSData *plainToken = [secretToken AES256DecryptWithKey:key];
        NSString *twtId = [[NSString alloc]initWithData:plainId encoding:NSUTF8StringEncoding];
        NSString *twtToken = [[NSString alloc]initWithData:plainToken encoding:NSUTF8StringEncoding];
        
        [data shareInstance].userId = twtId;
        [data shareInstance].userToken = twtToken;
    }
}

- (void)sendInstallData
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"InstallDataSent"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:plistPath])
    {
        [self getInstallInfo];
    }
}

- (void)pushStudySearch
{
    YViewController *studySearch;
    studySearch = [[YViewController alloc] initWithNibName:@"YViewController" bundle:nil];
    [self.navigationController pushViewController:studySearch animated:YES];
}

- (void)pushNews
{
    indexTabBarController *hostVC = [[indexTabBarController alloc]init];
    //[self presentViewController:hostVC animated:YES completion:nil];
    //HostViewController *hostVC = [[HostViewController alloc]init];
    [self.navigationController pushViewController:hostVC animated:YES];
}

- (void)pushLibrary
{
    //LibraryViewController *library;
    //library = [[LibraryViewController alloc]initWithNibName:@"LibraryViewController" bundle:nil];
    LibraryTabBarController *library = [[LibraryTabBarController alloc]init];
    [self.navigationController pushViewController:library animated:YES];
}

- (void)pushGPA
{
    GPAViewController *gpaViewController;
    gpaViewController = [[GPAViewController alloc]initWithNibName:@"GPAViewController" bundle:nil];
    [self.navigationController pushViewController:gpaViewController animated:YES];
}

- (void)pushJobs
{
    JobTabBarController *jobs = [[JobTabBarController alloc]init];
    [self.navigationController pushViewController:jobs animated:YES];
}

- (void)pushNotice
{
    //NoticeViewController *notice = [[NoticeViewController alloc]initWithStyle:UITableViewStylePlain];
    noticeTabBarController *notice = [[noticeTabBarController alloc]init];
    [self.navigationController pushViewController:notice animated:YES];
}

- (void)pushAbout
{
    AboutViewController *about = [[AboutViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:about animated:YES];
}

- (void)pushLostAndFound
{
    LAFTabBarController *lafTab = [[LAFTabBarController alloc]init];
    [self.navigationController pushViewController:lafTab animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //return UIStatusBarStyleLightContent;
    return UIStatusBarStyleDefault;
}

- (void)getInstallInfo
{
    [wpyDeviceStatus getDeviceStatusWithFinishCallbackBlock:^(NSDictionary *device){
        NSString *deviceStatus = [device objectForKey:@"model"];
        NSString *deviceSize = [device objectForKey:@"size"];
        NSString *deviceVersion = [device objectForKey:@"version"];
        NSString *deviceUdid = [device objectForKey:@"udid"];
        
        NSString *date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        date = [formatter stringFromDate:[NSDate date]];
        
        NSString *urlStr = [[NSString alloc]initWithFormat:@"http://service.twtstudio.com/phone/android/install_record.php?time=%@&version=%@&brand=Apple&model=%@&system=%@&size=%@&id=%@",date,[data shareInstance].appVersion,deviceStatus,deviceVersion,deviceSize,deviceUdid];
        
        [wpyWebConnection postDataToURLStr:urlStr withFinishCallbackBlock:^(NSDictionary *dic){
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"InstallDataSent"];
            [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
            NSLog(@"Install Data Sent Success.");
        }];
    }];
}

@end
