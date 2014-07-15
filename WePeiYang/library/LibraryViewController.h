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

@interface LibraryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, UIScrollViewDelegate>

//@property (strong, nonatomic) IBOutlet UITextField *searchField;
//@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)backgroundTap:(id)sender;
//- (IBAction)search:(id)sender;
//- (void)pushLogin:(id)sender;
//- (void)pushRecord:(id)sender;
- (IBAction)backToHome:(id)sender;
- (IBAction)typeChanged:(id)sender;

@end
