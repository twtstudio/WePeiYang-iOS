//
//  LibraryViewController.h
//  Library
//
//  Created by Qin Yubo on 13-11-4.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryTableCell.h"
#import "data.h"

@interface LibraryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, UIScrollViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UISearchBar *libSearchBar;
@property (weak, nonatomic) IBOutlet UIView *headerBackView;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)backToHome:(id)sender;
- (IBAction)typeChanged:(id)sender;

@end
