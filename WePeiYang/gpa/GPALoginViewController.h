//
//  GPALoginViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-10.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPALoginViewController : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwdField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)login:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
