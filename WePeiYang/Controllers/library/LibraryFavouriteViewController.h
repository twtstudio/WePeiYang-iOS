//
//  LibraryFavouriteViewController.h
//  WePeiYang
//
//  Created by Qin Yubo on 13-12-14.
//  Copyright (c) 2013年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryFavouriteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *favTableView;
@property (strong, nonatomic) IBOutlet UILabel *noFavLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerBackView;

- (IBAction)backToHome:(id)sender;

@end
