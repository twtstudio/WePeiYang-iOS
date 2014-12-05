//
//  AboutUSViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-18.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "AboutUSViewController.h"
#import "VWWWaterView.h"
#import "data.h"
#import "WePeiYang-Swift.h"
#import "twtSecretKeys.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height >= (double)568))

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

{
    NSInteger timesThatTheLogoWasTouched;
    UIAlertView *secureAlert;
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
    
    timesThatTheLogoWasTouched = 0;
    
    //UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //scroll.delegate = self;
    //scroll.pagingEnabled = NO;
    
    //[scroll setContentSize:CGSizeMake(self.view.frame.size.width, 750)];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"wpyicon@2x" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    [imgView setFrame:CGRectMake(0.5*(self.view.frame.size.width-90), 80, 90, 90)];
    [self.view addSubview:imgView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 40)];
    NSString *nameStr = [NSString stringWithFormat:@"微北洋 %@",[data shareInstance].appVersion];
    [nameLabel setText:nameStr];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    
    UILabel *twtLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 40)];
    [twtLabel setTextAlignment:NSTextAlignmentCenter];
    [twtLabel setText:@"天外天工作室"];
    [self.view addSubview:twtLabel];
    
    int justAConst = 60;
    VWWWaterView *waterView = [[VWWWaterView alloc]initWithFrame:CGRectMake(0, justAConst, self.view.frame.size.width, self.view.frame.size.height - justAConst)];
    [self.view addSubview:waterView];
    
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"zhanshanlogo@2x" ofType:@"png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:path2];
    UIImageView *imgView2 = [[UIImageView alloc]initWithImage:image2];
    int imgheight = DEVICE_IS_IPHONE5 ? (self.view.frame.size.width * 0.667) : (self.view.frame.size.width * 0.667)*0.6;
    [imgView2 setFrame:CGRectMake(0.5*(self.view.frame.size.width-4*imgheight/3), self.view.frame.size.height - imgheight, 4*imgheight/3, imgheight)];
    [self.view addSubview:imgView2];
    
    
    //[self.view addSubview:scroll];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setFrame:CGRectMake(0, 20, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *eggBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [eggBtn setFrame:imgView.frame];
    [eggBtn addTarget:self action:@selector(eggEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eggBtn];
    
}

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

- (void)eggEvent {
    timesThatTheLogoWasTouched++;
    if (timesThatTheLogoWasTouched == 10) {
        
        // Change this line.
        [self openDevKit];
        
        timesThatTheLogoWasTouched = 0;
    }
}

- (void) openDevKit {
    
    secureAlert = [[UIAlertView alloc]initWithTitle:@"安全验证" message:@"输入密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    secureAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [secureAlert show];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == secureAlert) {
        UITextField *secureField = [alertView textFieldAtIndex:0];
        NSString *key = [twtSecretKeys getDevKey];
        if (buttonIndex == 1) {
            NSString *password = secureField.text;
            if ([password isEqualToString:key]) {
                DevViewController *devVC = [[DevViewController alloc]initWithNibName:@"DevViewController" bundle:nil];
                [self presentViewController:devVC animated:YES completion:nil];
            } else {
                UIAlertView *failAlert = [[UIAlertView alloc]initWithTitle:@"Failed" message:@"Wrong Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [failAlert show];
            }
        }
        
    }
}

@end
