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
#import "MsgDisplay.h"
#import "AccountManager.h"

@implementation twtSDK

+ (void)setAppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    [SolaInstance shareInstance].appKey = appKey;
    [SolaInstance shareInstance].appSecret = appSecret;
}

+ (void)getGpaWithToken:(NSString *)token success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure userCanceledCaptcha:(void (^)())userCanceled {
    [self getGpaWithParameters:nil token:token success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    } userCanceledCaptcha:^{
        userCanceled();
    }];
}

+ (void)getGpaWithParameters:(NSDictionary *)parameters token:(NSString *)token success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure userCanceledCaptcha:(void(^)())userCanceled  {
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/gpa" token:token parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([[dic objectForKey:@"error_code"] isEqual: @20003]) {
            dic = dic[@"data"];
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
                [self getGpaWithParameters:para token:token success:success failure:failure userCanceledCaptcha:userCanceled];
            }];
            [captchaAlert addAction:cancel];
            [captchaAlert addAction:ok];
            [[SolaFoundationKit topViewController] presentViewController:captchaAlert animated:YES completion:nil];
            [MsgDisplay dismiss];
        } else {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getNewsListWithType:(NewsType)type page:(NSUInteger)page success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
//    NSString *url = [NSString stringWithFormat:@"/news/type/%ld?page=%ld", type, page];
    NSString *url = [NSString stringWithFormat:@"/news/%ld/page/%ld", type, page];
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:url token:[self wpyToken] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getNewsContentWithIndex:(NSString *)index success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"/news/%@", index];
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:url token:[self wpyToken] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)postNewsCommentWithIndex:(NSString *)index content:(NSString *)content success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"/news/comment/%@", index];
    NSDictionary *parameters = @{@"content": content,
                                 @"ip": [SolaFoundationKit IPAddress:YES]};
    [SolaSessionManager solaSessionWithSessionType:SessionTypePOST URL:url token:[self wpyToken] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getTokenWithTwtUserName:(NSString *)twtuname password:(NSString *)twtpasswd success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSDictionary *parameters = @{@"twtuname": twtuname,
                                 @"twtpasswd": twtpasswd};
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/auth/token/get" token:nil parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)refreshTokenWithOldToken:(NSString *)token success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/auth/token/refresh" token:token parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)checkToken:(NSString *)token success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/auth/token/check" token:token parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getClasstableWithToken:(NSString *)token success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/classtable" token:token parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getLostFoundListWithType:(NSInteger)type page:(NSInteger)page success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *url = (type == 0) ? @"/lostfound/lost" : @"/lostfound/found";
    NSDictionary *parameters = @{@"page": @(page)};
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:url token:[self wpyToken] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getLostFoundDetailWithID:(NSString *)index success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"/lostfound/%@", index];
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:url token:[self wpyToken] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)postLostInfoWithTitle:(NSString *)title name:(NSString *)name time:(NSDate *)time place:(NSString *)place phone:(NSString *)phone content:(NSString *)content lostType:(NSString *)lostType otherTag:(NSString *)otherTag success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSDictionary *parameters = @{@"title": title,
                                 @"name": name,
                                 @"time": @([time timeIntervalSince1970]),
                                 @"place": place,
                                 @"phone": phone,
                                 @"content": content,
                                 @"lost_type": lostType,
                                 @"other_tag": otherTag};
    [SolaSessionManager solaSessionWithSessionType:SessionTypePOST URL:@"/lostfound/lost" token:[self wpyToken] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)postFoundInfoWithTitle:(NSString *)title name:(NSString *)name time:(NSDate *)time place:(NSString *)place phone:(NSString *)phone content:(NSString *)content foundPic:(NSString *)foundPic success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSDictionary *parameters = @{@"title": title,
                                 @"name": name,
                                 @"time": @([time timeIntervalSince1970]),
                                 @"place": place,
                                 @"phone": phone,
                                 @"content": content,
                                 @"found_pic": foundPic};
    [SolaSessionManager solaSessionWithSessionType:SessionTypePOST URL:@"/lostfound/found" token:[self wpyToken] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getLibrarySearchResultWithTitle:(NSString *)title page:(NSInteger)page success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *titleString = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"/library/book"];
    NSDictionary *parameters = @{@"title": titleString,
                                 @"page": @(page)};
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:url token:[self wpyToken] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getLibraryReaderRank:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/lib/rank/reader" token:[self wpyToken] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (void)getLibraryBookRank:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [SolaSessionManager solaSessionWithSessionType:SessionTypeGET URL:@"/lib/rank/book" token:[self wpyToken] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

+ (NSString *)wpyToken {
    return [AccountManager tokenExists] ? [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY] : nil;
}

@end
