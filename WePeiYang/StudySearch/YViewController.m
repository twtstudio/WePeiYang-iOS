//
//  YViewController.m
//  StudySearch
//
//  Created by yong.h on 13-10-2.
//  Copyright (c) 2013年 yong.h. Qin Yubo. All rights reserved.
//

#import "YViewController.h"
#import "YStudySearchConst.h"
#import "UIButton+Bootstrap.h"
#import "data.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define DEVICE_IS_IPHONE5 (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON)

@interface YViewController ()



@end

@implementation YViewController

{
    UIAlertView *shareAlert;
    UIColor *studyTintColor;
}

//@synthesize received;
@synthesize studySearchPickerView;
@synthesize searchResultsArray;
@synthesize startBtn;
@synthesize headerBackView;

-(void)loadView
{
    [super loadView];
    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    studyTintColor = [UIColor colorWithRed:0/255.0f green:127/255.0f blue:191/255.0f alpha:1.0f];;
    [[UISegmentedControl appearance]setTintColor:[UIColor whiteColor]];
    [[UIButton appearance]setTintColor:[UIColor whiteColor]];
    headerBackView.backgroundColor = studyTintColor;
    
    //初始化可变数组
    self.searchResultsArray = [[NSMutableArray alloc] initWithObjects:nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]init];
    segmentedControl.momentary = YES;
    [self searchResultsTableView].hidden = YES;
    
    //取消tableView的分割线和背景
    [self.searchResultsTableView setBackgroundColor:[UIColor clearColor]];
    [self.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger firstSelectedRow = [pickerView selectedRowInComponent:0];
    NSInteger secondSelectedRow = [pickerView selectedRowInComponent:1];
    if (component == 0)
    {
        NSInteger secondRow;
        if (row >= secondSelectedRow)
        {
            if (row == [[YStudySearchConst shareInstance].startTimeArray count] - 1)
            {
                secondRow = row;
            }
            else
            {
                secondRow = row + 1;
            }
        }
        else
        {
            secondRow = secondSelectedRow;
        }
        [pickerView selectRow:secondRow inComponent:1 animated:YES];
    }
    else if (component == 1)
    {
        NSInteger firstRow;
        if (row <= firstSelectedRow)
        {
            if (row == 0)
            {
                firstRow = 0;
            }
            else
            {
                firstRow = row - 1;
            }
        }
        else
        {
            firstRow = firstSelectedRow;
        }
        [pickerView selectRow:firstRow inComponent:0 animated:YES];
    }
}

- (IBAction)toggleControls:(id)sender
{
    switch ([sender selectedSegmentIndex])
    {
        case 0:
            [YStudySearchConst shareInstance].daySelected = @"0";
            break;
        case 1:
            [YStudySearchConst shareInstance].daySelected = @"1";
            break;
        case 2:
            [YStudySearchConst shareInstance].daySelected = @"2";
            break;
        default:
            break;
    }
    [self.searchResultsTableView setHidden:YES];
}


-(void)viewDidUnload
{
    self.studySearchPickerView = nil;
    self.searchResultsTableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    //查询按钮
- (IBAction)btnTest:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    
    [self searchResultsTableView].hidden = NO;
    //分别读出三个PickerView中所选中的值
    NSInteger startTimeSelected = [studySearchPickerView selectedRowInComponent:StartTimePicker];
    NSInteger endTimeSelected = [studySearchPickerView selectedRowInComponent:EndTimePicker];
    NSString *buildingSelected = [[YStudySearchConst shareInstance].buildingsArray objectAtIndex:[studySearchPickerView selectedRowInComponent:BuildingsPicker]];
    
    if (startTimeSelected >= endTimeSelected) {
        
        [SVProgressHUD showErrorWithStatus:@"您选择的自习时间有些错误哦~"];
        
        
    } else {
        //将选中值转化为服务器所能识别的代码
        NSString *timeConvertResult = [self convertTimeWithStartTime:startTimeSelected andEndTime:endTimeSelected];
        NSString *buildingConvertResult = [self convertBuildingStringWith:buildingSelected];
        
        //清空数组以重新载入数据
        if ([self.searchResultsArray count] > 0) {
            [self.searchResultsArray removeAllObjects];
            
        }
        
        NSString *url = @"http://push-mobile.twtapps.net/studyrooms";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"day":        [YStudySearchConst shareInstance].daySelected,
                                     @"class":      timeConvertResult,
                                     @"building":   buildingConvertResult,
                                     @"platform":   @"ios",
                                     @"version":    [data shareInstance].appVersion};
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            [self processReceivedContentData:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"获取自习室失败T^T"];
        }];
    }
}

- (void)processReceivedContentData:(NSDictionary *)convertData {
    if ([convertData count] > 0)
    {
        for (NSDictionary *temp in convertData)
        {
            [self.searchResultsArray addObject:[temp objectForKey:@"room"]];
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.searchResultsTableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"这个时间段里这儿没有自习室了~"];
        });
    }
    
    if ([self.searchResultsArray count] > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchResultsTableView reloadData];
            [self.searchResultsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self.searchResultsTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
        });
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == StartTimePicker)
        return [[YStudySearchConst shareInstance].startTimeArray count];
    else if (component == EndTimePicker)
        return [[YStudySearchConst shareInstance].endTimeArray count];
    else
        return [[YStudySearchConst shareInstance].buildingsArray count];
}

//为了能够使PickerView中的选项居中显示，自定义了每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]init];
    
    if (component == StartTimePicker)
        [label setText:[[YStudySearchConst shareInstance].startTimeArray objectAtIndex:row]];
    else if (component == EndTimePicker)
        [label setText:[[YStudySearchConst shareInstance].endTimeArray objectAtIndex:row]];
    else
        [label setText:[[YStudySearchConst shareInstance].buildingsArray objectAtIndex:row]];
    
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textColor = [UIColor whiteColor];
    
    return label;    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResultsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"studySearchResults";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.searchResultsArray objectAtIndex:[indexPath row]];
    //cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


//将选中的自习室信息转化为服务器可识别的代码
-(NSString *)convertBuildingStringWith:(NSString *)buildingSelected
{
    NSString *stringConvertTo = @"";
    
    if ([buildingSelected isEqualToString:@"04楼"]) {
        stringConvertTo = @"0022";
    } else if ([buildingSelected isEqualToString:@"05楼"]) {
        stringConvertTo = @"1048";
    } else if ([buildingSelected isEqualToString:@"08楼"]) {
        stringConvertTo = @"0045";
    } else if ([buildingSelected isEqualToString:@"12楼"]) {
        stringConvertTo = @"0026";
    } else if ([buildingSelected isEqualToString:@"15楼"]) {
        stringConvertTo = @"0024";
    } else if ([buildingSelected isEqualToString:@"19楼"]) {
        stringConvertTo = @"0032";
    } else if ([buildingSelected isEqualToString:@"23楼"]) {
        stringConvertTo = @"0015";
    } else if ([buildingSelected isEqualToString:@"24楼"]) {
        stringConvertTo = @"1042";
    } else if ([buildingSelected isEqualToString:@"26楼A区"]) {
        stringConvertTo = @"1084";
    } else if ([buildingSelected isEqualToString:@"26楼B区"]) {
        stringConvertTo = @"1085";
    } else if ([buildingSelected isEqualToString:@"西阶"]) {
        stringConvertTo = @"0028";
    }

    return stringConvertTo;
}

//将选中的自习时间数据转化为服务器可识别的代码
-(NSString *)convertTimeWithStartTime:(NSInteger)startTimeSelected andEndTime:(NSInteger)endTimeSelected
{
    NSString *timeConvertTo = @"";
    NSInteger startStudy;
    NSInteger endStudy;
    
    //开始自习
    if(startTimeSelected < 3)
        startStudy = 1;
    else if(startTimeSelected >= 3 && startTimeSelected < 12)
        startStudy = 2;
    else if(startTimeSelected >= 12 && startTimeSelected < 15)
        startStudy = 3;
    else if(startTimeSelected >= 15 && startTimeSelected < 22)
        startStudy = 4;
    else if(startTimeSelected >= 22 && startTimeSelected < 27)
        startStudy = 5;
    else startStudy = 6;
    
    //结束自习
    if(endTimeSelected <= 3)
        endStudy = 1;
    else if(endTimeSelected > 3 && endTimeSelected <= 12)
        endStudy = 2;
    else if(endTimeSelected > 12 && endTimeSelected <= 15)
        endStudy = 3;
    else if(endTimeSelected > 15 && endTimeSelected <= 22)
        endStudy = 4;
    else if(endTimeSelected > 22 && endTimeSelected <= 27)
        endStudy = 5;
    else endStudy = 6;
    
    //判断持续自习的时间，总共几节课
    NSString *studyContinued = [NSString stringWithFormat:@"%d", endStudy - startStudy + 1];
    
    //最终转化结果
    timeConvertTo = [NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:@"%d", startStudy], studyContinued];
    
    //NSLog(@"%@", timeConvertTo);
    
    return timeConvertTo;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [YStudySearchConst shareInstance].classroomSelected = [searchResultsArray objectAtIndex:[indexPath row]];
    shareAlert = [[UIAlertView alloc]initWithTitle:@"告诉小伙伴" message:[NSString stringWithFormat:@"是否要告诉小伙伴们您要去 %@上自习的消息？",[YStudySearchConst shareInstance].classroomSelected] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
    [shareAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == shareAlert)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            nil;
        }
        else
        {
            [self share];
        }
    }
}

- (void)share
{
    NSString *shareItems;
    NSString *classroom = [YStudySearchConst shareInstance].classroomSelected;
    NSString *shareStr = [[NSString alloc]initWithFormat:@"我刚刚查到 %@ 可以上自习，一起去吧！（分享自【微北洋】 https://itunes.apple.com/cn/app/wei-bei-yang/id785509141?mt=8）",classroom];
    shareItems = @[shareStr];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)backToStart:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//关于后台

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:searchResultsArray forKey:@"SaveKey"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    searchResultsArray = [coder decodeObjectForKey:@"SaveKey"];
    [self.searchResultsTableView reloadData];
}

@end
