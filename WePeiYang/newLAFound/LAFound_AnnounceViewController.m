//
//  LAFound_AnnounceViewController.m
//  LostAndFound
//
//  Created by 马骁 on 14-4-14.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import "LAFound_AnnounceViewController.h"
#import "LAFound_DataManager.h"
#import "SVProgressHUD.h"

@interface LAFound_AnnounceViewController ()

@end

@implementation LAFound_AnnounceViewController
{
    NSInteger _type;
    UIAlertView *affirmAnnounceAlert;
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
    // Do any additional setup after loading the view from its nib.
    self.contentTexeView.delegate = self;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sendForNav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(announceButionAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
//    设置segmentedControl
    NSArray *segmentedControlItems = @[@"失物", @"拾取"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedControlItems];
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setWidth:80 forSegmentAtIndex:0];
    [segmentedControl setWidth:80 forSegmentAtIndex:1];
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;
    
//    设置textView边框
    self.contentTexeView.layer.borderWidth = 1.0;
    self.contentTexeView.layer.cornerRadius = 5.0;
    self.contentTexeView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.15].CGColor;
        
//  更改datapick
    self.timeTextField.inputView = self.datePicker;
    self.timeTextField.inputAccessoryView = self.pickerToolBar;
    
    NSTimeInterval aMonthInderval = 30*24*60*60;
    NSDate *nowDate = [NSDate date];
    NSDate *lastMonthFromNow = [NSDate dateWithTimeInterval:-aMonthInderval sinceDate:nowDate];
    [self.datePicker setMinimumDate:lastMonthFromNow];
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    
    
//    设置placeHolder
    
    
//    设置textField的代理
    self.titleTextField.delegate = self;
    self.placeTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.nameTextField.delegate = self;
    
    
    
//    自定义触摸手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardByTap)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    //NSTimer *timerforScrollView;
    //timerforScrollView =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(forScrollView)userInfo:nil repeats:NO];
    
    _type = 0;
    
    
}

- (void)forScrollView{
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-40)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isGetAllInfo
{
    [self.view endEditing:YES];
    if ((self.titleTextField.text.length > 0) && (self.placeTextField.text.length > 0) && (self.timeTextField.text.length > 0) && (self.phoneTextField.text.length > 0) && (self.nameTextField.text.length > 0) && (self.contentTexeView.text.length > 0)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)announceButionAction
{
    if ([self isGetAllInfo]) {
        affirmAnnounceAlert = [[UIAlertView alloc] initWithTitle:@"确认发布" message:@"发布以后就不能修改了哦~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [affirmAnnounceAlert show];
        
    }else {
        [SVProgressHUD showErrorWithStatus:@"信息还没有填写完全哦~"];
    }
}


- (void)announceInfo
{

    
    [LAFound_DataManager announceItemInfoWithType:_type title:self.titleTextField.text place:self.placeTextField.text time:self.timeTextField.text phone:self.phoneTextField.text name:self.nameTextField.text content:self.contentTexeView.text success:^(id responseObject) {
        if ([responseObject isEqualToString:@"发布成功"]) {
            [SVProgressHUD showSuccessWithStatus:@"消息发布成功！"];
            [self.titleTextField setText:@""];
            [self.placeTextField setText:@""];
            [self.timeTextField setText:@""];
            [self.nameTextField setText:@""];
            [self.phoneTextField setText:@""];
            [self.contentTexeView setText:@""];

            
        } else  if([responseObject isEqualToString:@"发布失败"]){
            [SVProgressHUD showErrorWithStatus:@"消息发布失败！"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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
        self.titleTextField.placeholder = @"标题（丢失物品、特点）";
        self.placeTextField.placeholder = @"丢失地点";
        self.timeTextField.placeholder = @"丢失时间";
    }else if(index == 1){
        _type = 1;
        self.titleTextField.placeholder = @"标题（拾取物品、特点）";
        self.placeTextField.placeholder = @"拾取地点";
        self.timeTextField.placeholder = @"拾取时间";
    }
}

#pragma mark 屏幕滚动

- (void)offsetScrollViewByTapingTextView:(BOOL)up
{
    if (up) {
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scrollView setContentOffset:CGPointMake(0, 90)];
        [UIView commitAnimations];
    } else if (!up){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-40)];
//        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [UIView commitAnimations];
    }
}


#pragma mark textView的代理方法
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self offsetScrollViewByTapingTextView:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self offsetScrollViewByTapingTextView:NO];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        //self.textViewPlaceHolderLabel.hidden = YES;
    } else {
        //self.textViewPlaceHolderLabel.hidden = NO;
    }
}
#pragma mark texiField的代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark 手势触发

- (void)hideKeyboardByTap
{
    [self.view endEditing:YES];
}

#pragma mark datapicker ButtonAction
- (IBAction)cancelPicker:(id)sender
{
    if ([self.view endEditing:NO]) {
        NSLocale *dataLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"AppleLanguages"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dataFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd HH:mm" options:0 locale:dataLocale];
        [formatter setDateFormat:dataFormat];
        [formatter setLocale:dataLocale];
        self.timeTextField.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.datePicker.date]];
    }
}

- (void)backToHome
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

@end
