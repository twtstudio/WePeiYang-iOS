//
//  NewsContent.h
//  WePeiYang
//
//  Created by Qin Yubo on 15/12/6.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsContent : NSObject

@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *reviewer;
@property (strong, nonatomic) NSString *photographer;
@property (strong, nonatomic) NSString *visitCount;
@property (strong, nonatomic) NSArray *comments;

@end
