//
//  wpyStringProcessor.h
//  WePeiYang
//
//  Created by Qin Yubo on 14-3-25.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsContent.h"

@interface FrontEndProcessor : NSObject

+ (NSString *)convertToBootstrapHTMLWithNewsContent:(NewsContent *)newsContent;

@end
