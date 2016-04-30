//
//  WKWebViewController.m
//
//
//  Created by Allen X on 4/13/16.
//
//

#import "WebAppViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "AccountManager.h"
#import "WePeiYang-Swift.h"
#import "SolaFoundationKit.h"
#import "MsgDisplay.h"
@import Masonry;

@interface WebAppViewController ()
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) WKWebView *wkWebView;
@property WKWebViewJavascriptBridge *bridge;
@property UIStatusBarStyle *customPreferredStatusBarStyle;

@end

@implementation WebAppViewController

#pragma mark - Initialization
/*- (void) dealloc {
 [self.wkWebVIew stopLoading];
 self.wkWebVIew.navigationDelegate = nil;
 }*/

- (instancetype)initWithAddress:(NSString *)URLString {
    return [self initWithURL:[NSURL URLWithString:URLString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _customPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return _customPreferredStatusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
//    _wkWebView.navigationDelegate = self;
    [_wkWebView loadRequest:_request];
    //[_wkWebView setCustomUserAgent:[SolaFoundationKit userAgentString]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _wkWebView.scrollView.bounces = NO;
    self.view = _wkWebView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotificationReceived) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotificationReceived) name:@"LoginCancelled" object:nil];
    
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:_wkWebView];
    [_bridge registerHandler:@"tokenHandler_iOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([AccountManager tokenExists]) {
            responseCallback([[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY]);
            NSLog(@"Yay");
        } else {
            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [MsgDisplay showSuccessMsg:@"此应用需要你先登录"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }];
    [_bridge registerHandler:@"navigationHandler_iOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self backAnimated:YES];
        NSSet *websiteDataTypes
        = [NSSet setWithArray:@[
                                WKWebsiteDataTypeDiskCache,
                                WKWebsiteDataTypeOfflineWebApplicationCache,
                                WKWebsiteDataTypeMemoryCache,
                                WKWebsiteDataTypeLocalStorage,
                                WKWebsiteDataTypeCookies,
                                WKWebsiteDataTypeSessionStorage,
                                WKWebsiteDataTypeIndexedDBDatabases,
                                WKWebsiteDataTypeWebSQLDatabases
                                ]];
        //// All kinds of data
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            NSLog(@"Cleared!");
        }];
    }];
    [_bridge registerHandler:@"setStatusBarHandlerBlack_iOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        _customPreferredStatusBarStyle = UIStatusBarStyleDefault;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

/*- (BOOL)shouldAutorotate{
 return NO;
 }*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshNotificationReceived {
    [_wkWebView reload];
}

- (void)backNotificationReceived {
    [self backAnimated:NO];
}

- (void)backAnimated: (BOOL)animated {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animated];
    } else {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}

- (void)webView: (WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation: (WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation: (WKNavigation *)navigation withError:(NSError *)error {
    
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