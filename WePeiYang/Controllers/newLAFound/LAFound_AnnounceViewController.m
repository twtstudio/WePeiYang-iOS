//
//  LAFound_AnnounceViewController.m
//  LostAndFound
//
//  Created by 马骁 on 14-4-14.
//  Copyright (c) 2014年 Mx. All rights reserved.
//
//  Refactor by Qin Yubo

#import "LAFound_AnnounceViewController.h"
#import "LAFound_DataManager.h"
#import "SVProgressHUD.h"

@interface LAFound_AnnounceViewController ()

@end

@implementation LAFound_AnnounceViewController

{
    NSInteger _type;
    UIAlertView *affirmAnnounceAlert;
    
    NSString *titleStr;
    NSString *placeStr;
    NSString *timeStr;
    NSString *nameStr;
    NSString *phoneStr;
    NSString *contentStr;
}

@synthesize tableView;
@synthesize formController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    formController = [[FXFormController alloc]init];
    formController.tableView = tableView;
    formController.delegate = self;
    formController.form = [[LAFoundAnnounceForm alloc]init];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sendForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(announceButionAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.title = @"发布信息";
    
//    设置segmentedControl
    /*
    NSArray *segmentedControlItems = @[@"失物", @"拾取"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedControlItems];
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setWidth:80 forSegmentAtIndex:0];
    [segmentedControl setWidth:80 forSegmentAtIndex:1];
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;*/
    
    // 初值，如果为这个值表示 _type 没有被选择
    _type = 99;
    
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)isGetAllInfo {
    LAFoundAnnounceForm *form = self.formController.form;
    _type = form.type;
    titleStr = form.title;
    placeStr = form.place;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    timeStr = [dateFormatter stringFromDate:form.time];
    nameStr = form.name;
    phoneStr = form.phone.stringValue;
    contentStr = form.content;
    
    if ((titleStr.length > 0) && (placeStr.length > 0) && (timeStr.length > 0) && (phoneStr > 0) && (nameStr > 0) && (contentStr.length > 0) && (_type != 99)) {
        return YES;
    } else {
        return NO;
    }
    return YES;
}

- (void)announceButionAction
{
    if ([self isGetAllInfo]) {
        affirmAnnounceAlert = [[UIAlertView alloc] initWithTitle:@"确认发布" message:@"发布以后就不能修改了哦~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [affirmAnnounceAlert show];
        
    }else {
        [SVProgressHUD showErrorWithStatus:@"信息还没有填写完全哦~" maskType: SVProgressHUDMaskTypeBlack];
    }
}

- (void)announceInfo {

    
    [LAFound_DataManager announceItemInfoWithType:_type title:titleStr place:placeStr time:timeStr phone:phoneStr name:nameStr content:contentStr success:^(id responseObject) {
        if ([responseObject isEqualToString:@"发布成功"]) {
            [SVProgressHUD showSuccessWithStatus:@"消息发布成功！"  maskType: SVProgressHUDMaskTypeBlack];

        } else  if([responseObject isEqualToString:@"发布失败"]){
            [SVProgressHUD showErrorWithStatus:@"消息发布失败！"  maskType: SVProgressHUDMaskTypeBlack];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription maskType: SVProgressHUDMaskTypeBlack];
    }];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == affirmAnnounceAlert)
    {
        if (buttonIndex == 1) {
            [self announceInfo];
        }
    }
}

#pragma mark segmented

- (void)segmentedControlAction:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    if (index == 0) {
        _type = 0;
    } else if(index == 1) {
        _type = 1;
    }
}

- (void)backToHome {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
