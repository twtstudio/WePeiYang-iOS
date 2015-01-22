//
//  LAFoundQueryDetailViewController.h
//  LostAndFound
//
//  Created by 马骁 on 14-4-15.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAFound_QueryListViewController.h"

@interface LAFound_QueryDetailViewController : UIViewController<LAFound_QueryListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *updataDateTextField;

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property BOOL isCollectionDetail;

- (IBAction)call:(id)sender;

@end
