//
//  FeedbackViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-12.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<NSURLConnectionDataDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *numberField;
@property (strong, nonatomic) IBOutlet UITextField *deviceStatusField;
@property (strong, nonatomic) IBOutlet UITextField *deviceVersionField;
@property (strong, nonatomic) IBOutlet UITextView *feedbackView;

//@property (strong, nonatomic) NSMutableData *response;

- (IBAction)backgroundTap:(id)sender;

@end
