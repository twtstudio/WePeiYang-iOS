//
//  LAFoundQueryDetailViewController.m
//  LostAndFound
//
//  Created by 马骁 on 14-4-15.
//  Modified by Qin Yubo
//  Copyright (c) 2014年 Mx. All rights reserved.
//

#import "LAFound_QueryDetailViewController.h"
#import "SVProgressHUD.h"
#import "WePeiYang-Swift.h"

@interface LAFound_QueryDetailViewController ()

@end

@implementation LAFound_QueryDetailViewController {
    NSDictionary *_dic;
    NSMutableArray *_tempCollectionArray;
    NSString *shareContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"详细信息";
    
    self.titleTextField.text = [_dic valueForKey:@"title"];
    self.placeTextField.text = [_dic valueForKey:@"place"];
    self.timeTextField.text = [_dic valueForKey:@"time"];
    self.nameTextField.text = [_dic valueForKey:@"name"];
    self.phoneTextField.text = [_dic valueForKey:@"phone"];
    self.contentTextView.text = [_dic valueForKey:@"content"];
    self.updataDateTextField.text = [_dic valueForKey:@"created_at"];
    
    if (!self.isCollectionDetail) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LAFound_QueryListViewController:(LAFound_QueryListViewController *)qdVC ShowDetailByDataDic:(NSDictionary *)dic
{
    _dic = dic;
}

#pragma mark 取得分享内容文本
- (void)share
{
    NSString *type;
    if ([[_dic valueForKey:@"type"] isEqualToString:@"0"]) {
        type = @"遗失物品,请求帮助";
    } else if([[_dic valueForKey:@"type"] isEqualToString:@"1"]){
        type = @"拾取失物,发布招领";
    }
    shareContent = [[NSString alloc]initWithFormat:@"%@ 标题: %@ 地点: %@ 时间: %@ 发布人姓名: %@ 发布人联系电话: %@ 详细信息: %@", type, [_dic valueForKey:@"title"], [_dic valueForKey:@"place"], [_dic valueForKey:@"time"], [_dic valueForKey:@"name"], [_dic valueForKey:@"phone"], [_dic valueForKey:@"content"]];
    //NSString *shareString = [shareContent substringToIndex:140];
    
    NSString *shareTitle = [_dic objectForKey:@"title"];
    
    NSArray *activityItems = @[shareTitle];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

- (IBAction)call:(id)sender
{
    NSString *phoneNum = [_dic objectForKey:@"phone"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
}


@end
