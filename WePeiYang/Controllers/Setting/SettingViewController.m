//
//  SettingViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/10.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "SettingViewController.h"
#import "data.h"
#import "wpyCacheManager.h"
#import "GPATableViewController.h"
#import "MsgDisplay.h"

@interface SettingViewController ()

@end

@implementation SettingViewController {
    NSArray *settingArr;
    NSArray *titleArr;
    NSArray *footerArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.clearsSelectionOnViewWillAppear = YES;
    
    settingArr = @[@[@"清除 GPA 登录"], @[@"关于微北洋", @"关于我们"]];
    titleArr = @[@"设置", @"关于"];
    footerArr = @[@"", @"WePeiyang beta\n2015 TWT Studio"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)clearGPACache {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除" message:@"确定要清除 GPA 登录及缓存吗？" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [wpyCacheManager removeCacheDataForKey:GPA_USER_NAME_CACHE];
        [wpyCacheManager removeCacheDataForKey:GPA_CACHE];
        [MsgDisplay showSuccessMsg:@"GPA 缓存及登录已清除"];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:clearAction];
    [alert addAction:cancel];
    [alert setModalPresentationStyle:UIModalPresentationPopover];
    alert.popoverPresentationController.permittedArrowDirections = 0;
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = self.view.frame;
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return settingArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)settingArr[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleTableViewIdentifier" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSArray *arr = settingArr[0];
        cell.textLabel.text = arr[indexPath.row];
    } else if (indexPath.section == 1) {
        NSArray *arr = settingArr[1];
        cell.textLabel.text = arr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return titleArr[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return footerArr[section];
}

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            [self clearGPACache];
        }
    } else if (section == 1) {
        if (row == 0) {
            [self performSegueWithIdentifier:@"pushAbout" sender:nil];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
