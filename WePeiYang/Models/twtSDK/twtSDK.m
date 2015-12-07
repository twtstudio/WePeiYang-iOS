//
//  twtSDK.m
//  Project Sola
//
//  Created by Qin Yubo on 15/10/28.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "twtSDK.h"
#import "SolaInstance.h"
#import "SolaSessionManager.h"
#import "SolaFoundationKit.h"
#import "AFNetworking.h"

@implementation twtSDK

+ (void)setAppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    [SolaInstance shareInstance].appKey = appKey;
    [SolaInstance shareInstance].appSecret = appSecret;
}

+ (void)getGpaWithTjuUsername:(NSString *)username password:(NSString *)password success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure userCanceledCaptcha:(void (^)())userCanceled {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"tjuuname": username, @"tjupasswd": password}];
    [self getGpaWithParameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    } userCanceledCaptcha:^{
        userCanceled();
    }];
}

+ (void)getGpaWithParameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure userCanceledCaptcha:(void(^)())userCanceled  {
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/tmp/gpa" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic objectForKey:@"raw"] != nil) {
            NSData *captchaData = [[NSData alloc] initWithBase64EncodedString:[dic objectForKey:@"raw"] options:0];
            UIImage *img = [[UIImage alloc] initWithData:captchaData];
            
            UIAlertController *captchaAlert = [UIAlertController alertControllerWithTitle:@"请输入验证码" message:@"\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
            [captchaAlert.view addSubview:({
                UIImageView *view = [[UIImageView alloc] initWithImage:img];
                view.frame = CGRectMake(60, 50, 150, 50);
                view;
            })];
            [captchaAlert addTextFieldWithConfigurationHandler:^(UITextField *captchaField) {
                captchaField.placeholder = @"请输入验证码";
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                userCanceled();
            }];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
                [para setObject:[dic objectForKey:@"token"] forKey:@"token"];
                [para setObject:captchaAlert.textFields[0].text forKey:@"captcha"];
                [self getGpaWithParameters:para success:success failure:failure userCanceledCaptcha:userCanceled];
            }];
            [captchaAlert addAction:cancel];
            [captchaAlert addAction:ok];
            [[SolaFoundationKit topViewController] presentViewController:captchaAlert animated:YES completion:nil];
        } else {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getNewsListWithType:(NewsType)type page:(NSUInteger)page success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http://open.twtstudio.com/api/v1/news/%ld/page/%ld", type, page];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getNewsContentWithIndex:(NSString *)index success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http://open.twtstudio.com/api/v1/news/%@", index];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

@end
