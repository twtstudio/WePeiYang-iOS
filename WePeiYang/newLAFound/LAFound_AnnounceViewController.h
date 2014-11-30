//
//  LAFound_AnnounceViewController.h
//  LostAndFound
//
//  Created by 马骁 on 14-4-14.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LAFound_AnnounceViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *placeTextField;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *contentTexeView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *pickerToolBar;
//@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceHolderLabel;

- (IBAction)cancelPicker:(id)sender;

@end
