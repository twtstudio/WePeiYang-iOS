//
//  FeedbackViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-12.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import "FeedbackViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "AFNetworking.h"
#import "wpyDeviceStatus.h"
#import "SVProgressHUD.h"
#import "data.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

{
    NSString *username;
    NSString *deviceStatus;
    NSString *deviceVersion;
    NSString *feedback;
    
    UIAlertView *nilAlert;
    UIAlertView *thxAlert;
    UIAlertView *waitingAlert;
}

@synthesize numberField;
@synthesize deviceStatusField;
@synthesize deviceVersionField;
@synthesize feedbackView;

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
    // Do any additional setup after loading the view from its nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    //self.title = @"发送反馈";
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, [data shareInstance].deviceWidth, 64)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc]init];
    NSString *backIconPath = [[NSBundle mainBundle]pathForResource:@"backForNav@2x" ofType:@"png"];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithContentsOfFile:backIconPath] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome:)];
    NSString *sendIconPath = [[NSBundle mainBundle]pathForResource:@"sendForNav@2x" ofType:@"png"];
    UIBarButtonItem *sendBarBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithContentsOfFile:sendIconPath] style:UIBarButtonItemStylePlain target:self action:@selector(sendFeedback:)];
    [navigationBar pushNavigationItem:navigationItem animated:YES];
    [navigationItem setTitle:@"发送反馈"];
    [navigationItem setLeftBarButtonItem:backBarBtn];
    [navigationItem setRightBarButtonItem:sendBarBtn];
    [self.view addSubview:navigationBar];
    
    [wpyDeviceStatus getDeviceStatusWithFinishCallbackBlock:^(NSDictionary *device){
        deviceStatus = [device objectForKey:@"model"];
        deviceVersion = [device objectForKey:@"version"];
    }];
    
    deviceStatusField.text = deviceStatus;
    deviceVersionField.text = deviceVersion;
    
    feedbackView.delegate = self;
    
}

- (IBAction)backToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendFeedback:(id)sender
{
    username = numberField.text;
    feedback = feedbackView.text;
    
    NSString *url = @"http://push-mobile.twtapps.net/suggest/wepeiyang";
    NSDictionary *parameters = @{@"email":username,
                                 @"content":feedback,
                                 @"info":[NSString stringWithFormat:@"%@_%@",deviceStatus,deviceVersion],
                                 @"platform":@"ios",
                                 @"version":[data shareInstance].appVersion};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        thxAlert = [[UIAlertView alloc]initWithTitle:@"Thanks" message:@"感谢您的反馈！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [thxAlert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发送反馈失败，请稍后再试"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backgroundTap:(id)sender
{
    [numberField resignFirstResponder];
    [deviceVersionField resignFirstResponder];
    [deviceStatusField resignFirstResponder];
    [feedbackView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.view.frame.size.width <= 320) {
        [self moveView:-80];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.view.frame.size.width <= 320) {
        [self moveView:80];
    }
}

- (void)moveView:(float)move
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y += move;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    //设置调整界面的动画效果
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == thxAlert)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
