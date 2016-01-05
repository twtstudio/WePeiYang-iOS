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
#import "wpyDeviceStatus.h"

@interface SettingViewController ()

@end

@implementation SettingViewController {
    NSArray *titleArr;
    NSArray *footerArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.clearsSelectionOnViewWillAppear = YES;
    
    titleArr = @[@"设置", @"关于"];
    footerArr = @[@"", [NSString stringWithFormat:@"微北洋 %@ Build %@\n2015 TWT Studio", [wpyDeviceStatus getAppVersion], [wpyDeviceStatus getAppBuild]]];
    
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

- (void)clearGPACacheFinishBlock:(void(^)())block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除" message:@"确定要清除 GPA 登录信息及缓存吗？" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [wpyCacheManager removeCacheDataForKey:GPA_USER_NAME_CACHE];
        [wpyCacheManager removeCacheDataForKey:GPA_CACHE];
        [MsgDisplay showSuccessMsg:@"GPA 缓存及登录信息已清除"];
        block();
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

- (void)loginGpaFinish:(void(^)())block {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入天大办公网的账号密码" message:@"由于部分原因，暂时无法校验您账号密码是否正确，请保证输入准确无误。\n如反复要求您输入验证码，可能是您输入错误，请注销后重新登录。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入办公网账号";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入办公网密码";
        textField.secureTextEntry = YES;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDictionary *dic = @{@"username": alertController.textFields[0].text,
                              @"password": alertController.textFields[1].text};
        [wpyCacheManager saveCacheData:dic withKey:GPA_USER_NAME_CACHE];
        block();
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleTableViewIdentifier" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [wpyCacheManager cacheDataExistsWithKey:GPA_USER_NAME_CACHE] ? @"注销 GPA 登录信息" : @"登录办公网";
        }
    } else if (indexPath.section == 1) {
        NSArray *arr = @[@"关于微北洋"];
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
            if ([wpyCacheManager cacheDataExistsWithKey:GPA_USER_NAME_CACHE]) {
                [self clearGPACacheFinishBlock:^{
                    [self.tableView reloadData];
                }];
            } else {
                [self loginGpaFinish:^{
                    [self.tableView reloadData];
                }];
            }
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
