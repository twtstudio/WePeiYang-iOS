//
//  eggViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-1-20.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "eggViewController.h"
#import "UIButton+Bootstrap.h"
#import "data.h"
#import "wpyWebConnection.h"
#import "CSNotificationView.h"

@interface eggViewController ()

@end

@implementation eggViewController

{
    UIImageView *imgView;
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
    self.view.backgroundColor = [UIColor whiteColor];
    /*
    self.title = @"青春无极限天外更有天";
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    scroll.pagingEnabled = NO;
    scroll.bounces = NO;
    scroll.delegate = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"IMG_egg@2x" ofType:@"jpg"];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    imgView = [[UIImageView alloc]initWithImage:img];
    [scroll setContentSize:[img size]];
    [scroll setMaximumZoomScale:2.0];
    [scroll setMinimumZoomScale:0.3];
    [scroll addSubview:imgView];
    [self.view addSubview:scroll];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(180, self.view.frame.size.height - 50, 120, 40)];
    [closeBtn addTarget:self action:@selector(closeEgg) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn primaryStyle];
    [self.view addSubview:closeBtn];
    
    UIButton *jbTju = [UIButton buttonWithType:UIButtonTypeSystem];
    [jbTju setTitle:@"解除办公网账号绑定" forState:UIControlStateNormal];
    [jbTju setFrame:CGRectMake(60, 120, 200, 40)];
    [jbTju dangerStyle];
    [jbTju addTarget:self action:@selector(jbTju) forControlEvents:UIControlEventTouchUpInside];
    if ([self userIsLogedIn]) [self.view addSubview:jbTju];
    
    UIButton *jbLib = [UIButton buttonWithType:UIButtonTypeSystem];
    [jbLib setTitle:@"解除图书馆账号绑定" forState:UIControlStateNormal];
    [jbLib setFrame:CGRectMake(60, 200, 200, 40)];
    [jbLib dangerStyle];
    [jbLib addTarget:self action:@selector(jbLib) forControlEvents:UIControlEventTouchUpInside];
    if ([self userIsLogedIn]) [self.view addSubview:jbLib];
     */
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake(180, self.view.frame.size.height - 50, 120, 40)];
    [closeBtn addTarget:self action:@selector(closeEgg) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn primaryStyle];
    [self.view addSubview:closeBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height - 140, 320, 60)];
    [label setText:@"Hello from TWT:)"];
    [self.view addSubview:label];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeEgg
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
- (void)jbTju
{
    NSString *userId = [data shareInstance].userId;
    NSString *userToken = [data shareInstance].userToken;
    NSString *url = @"http://push-mobile.twtapps.net/user/unbindTju";
    NSString *body = [NSString stringWithFormat:@"id=%@&token=%@",userId,userToken];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if ([[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"解除绑定成功！"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *files = @[@"gpa",@"gpaResult",@"gpaCacheData"];
            for (NSString *fileName in files)
            {
                NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:plistPath error:nil];
                NSLog(@"Plist file %@ deleted.",fileName);
            }
        }
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"解除绑定失败！"];
        }
    }];
    
}

- (void)jbLib
{
    NSString *userId = [data shareInstance].userId;
    NSString *userToken = [data shareInstance].userToken;
    NSString *url = @"http://push-mobile.twtapps.net/user/unbindLib";
    NSString *body = [NSString stringWithFormat:@"id=%@&token=%@",userId,userToken];
    [wpyWebConnection getDataFromURLStr:url andBody:body withFinishCallbackBlock:^(NSDictionary *dic){
        if ([[dic objectForKey:@"statusCode"] isEqualToString:@"200"])
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"解除绑定成功！"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *files = @[@"login",@"libraryRecordCache"];
            for (NSString *fileName in files)
            {
                NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:plistPath error:nil];
                NSLog(@"Plist file %@ deleted.",fileName);
            }
        }
        else
        {
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"解除绑定失败！"];
        }
    }];

}

- (BOOL)userIsLogedIn
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"twtLogin"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath:plistPath])
        return YES;
    else return NO;
}
 */

@end
