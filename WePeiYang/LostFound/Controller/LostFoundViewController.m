//
//  LostFoundViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 16/2/13.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

#import "LostFoundViewController.h"
#import "LostFoundTableViewController.h"
#import "BlocksKit+UIKit.h"

@interface LostFoundViewController ()

@end

@implementation LostFoundViewController

- (instancetype)init {
    self = [super init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self) {
        self.viewControllerClasses = @[[LostFoundTableViewController class], [LostFoundTableViewController class]];
        self.titles = @[@"丢失", @"捡到"];
        self.keys = [@[@"type", @"type"] mutableCopy];
        self.values = [@[@0, @1] mutableCopy];
        
        // customization
        self.pageAnimatable = YES;
        self.titleSizeSelected = 15.0;
        self.titleSizeNormal = 15.0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleColorSelected = [UIColor colorWithRed:113/255.0 green:168/255.0 blue:57/255.0 alpha:1.0];
        self.titleColorNormal = [UIColor darkGrayColor];
        self.menuItemWidth = 100;
        self.bounces = YES;
        self.menuHeight = MENU_VIEW_HEIGHT;
        self.menuViewBottom = -(self.menuHeight + 64.0);
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:113/255.0 green:168/255.0 blue:57/255.0 alpha:1.0];
    self.title = @"失物招领";
    
    // Appearance Customization
    self.menuView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.menuView.layer.shadowOffset = CGSizeMake(0, 0.1);
    self.menuView.layer.shadowOpacity = 1;
    self.menuView.layer.shadowRadius = 0.5;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemCompose handler:^(id sender) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *lostAction = [UIAlertAction actionWithTitle:@"丢失物品" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *foundAction = [UIAlertAction actionWithTitle:@"捡到物品" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:lostAction];
        [alertController addAction:foundAction];
        [alertController addAction:cancelAction];
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        alertController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        alertController.popoverPresentationController.sourceView = self.view;
        alertController.popoverPresentationController.barButtonItem = (UIBarButtonItem *)sender;
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    self.navigationItem.rightBarButtonItem = addBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
