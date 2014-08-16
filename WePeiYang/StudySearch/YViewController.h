//
//  YViewController.h
//  StudySearch
//
//  Created by yong.h on 13-10-2.
//  Copyright (c) 2013年 yong.h. Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define DaysPicker
#define StartTimePicker 0
#define EndTimePicker 1
#define BuildingsPicker 2

@interface YViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NSURLConnectionDataDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

- (IBAction)btnTest:(UIButton *)sender;
- (IBAction)toggleControls:(id)sender;
- (IBAction)backToStart:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *studySearchPickerView;
@property (retain, nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UIView *headerBackView;

@property (strong, nonatomic) NSMutableArray *searchResultsArray;
//@property (strong, nonatomic) NSMutableData *received;

@end
