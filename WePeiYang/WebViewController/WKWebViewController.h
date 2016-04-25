//
//  WKWebViewController.h
//  
//
//  Created by Allen X on 4/13/16.
//
//

#import <UIKit/UIKit.h>
#import "WebKit/WebKit.h"

@interface WKWebViewController : UIViewController

- (instancetype)initWithAddress:(NSString*)URLString;
- (instancetype)initWithURL:(NSURL *)pageURL;
- (instancetype)initWithURLRequest: (NSURLRequest*)request;

@end
