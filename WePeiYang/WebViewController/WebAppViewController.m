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
#import "BlocksKit+UIKit.h"

@interface WebAppViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) WKWebView *wkWebView;
@property WKWebViewJavascriptBridge *bridge;
@property UIStatusBarStyle *customPreferredStatusBarStyle;

@end

@implementation WebAppViewController {
    BOOL _flagged;
    UIButton *backBtn;
}

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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return *(_customPreferredStatusBarStyle);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.selectionGranularity = WKSelectionGranularityCharacter;
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    [_wkWebView loadRequest:_request];
    //[_wkWebView setCustomUserAgent:[SolaFoundationKit userAgentString]];
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _wkWebView.scrollView.bounces = NO;
    [_wkWebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    self.view = _wkWebView;
    
    backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(20, 20, 40, 20)];
    [backBtn bk_addEventHandler:^(id sender) {
        [self backAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotificationReceived) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotificationReceived) name:@"LoginCancelled" object:nil];
    
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:_wkWebView];
    [_bridge registerHandler:@"tokenHandler_iOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([AccountManager tokenExists]) {
            responseCallback([[NSUserDefaults standardUserDefaults] stringForKey:TOKEN_SAVE_KEY]);
        } else {
            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [MsgDisplay showErrorMsg:@"此应用需要先登录"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }];
    [_bridge registerHandler:@"navigationHandler_iOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self backAnimated:YES];
    }];
    [_bridge registerHandler:@"setStatusBarHandlerBlack_iOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        _customPreferredStatusBarStyle = (UIStatusBarStyle *)UIStatusBarStyleDefault;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    NSSet *websiteDataTypes
//    = [NSSet setWithArray:@[
//                            WKWebsiteDataTypeDiskCache,
//                            WKWebsiteDataTypeOfflineWebApplicationCache,
//                            WKWebsiteDataTypeMemoryCache,
//                            WKWebsiteDataTypeLocalStorage,
//                            WKWebsiteDataTypeCookies,
//                            WKWebsiteDataTypeSessionStorage,
//                            WKWebsiteDataTypeIndexedDBDatabases,
//                            WKWebsiteDataTypeWebSQLDatabases
//                            ]];
    //// All kinds of data
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        NSLog(@"Cleared!");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_wkWebView removeObserver:self forKeyPath:@"loading"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isKindOfClass:[WKWebView class]] && [keyPath isEqualToString:@"loading"]) {
        BOOL value = change[NSKeyValueChangeNewKey];
        if (value) {
            NSLog(@"Loading finished");
            [_wkWebView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
            [backBtn removeFromSuperview];
        }
    }
}

- (void)refreshNotificationReceived {
    [_wkWebView reload];
}

- (void)backNotificationReceived {
    [self backAnimated:NO];
}

- (void)backAnimated:(BOOL)animated {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animated];
    } else {
        [self trueDismissViewControllerAnimated:animated completion:nil];
    }
}

#pragma mark - Avoiding iOS bug

- (UIViewController *)presentingViewController {
    
    // Avoiding iOS bug. UIWebView with file input doesn't work in modal view controller
    
    if (_flagged) {
        return nil;
    } else {
        return [super presentingViewController];
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    // Avoiding iOS bug. UIWebView with file input doesn't work in modal view controller
    
    if ([viewControllerToPresent isKindOfClass:[UIDocumentMenuViewController class]]
        ||[viewControllerToPresent isKindOfClass:[UIImagePickerController class]]) {
        _flagged = YES;
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)trueDismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    
    // Avoiding iOS bug. UIWebView with file input doesn't work in modal view controller
    
    _flagged = NO;
    [self dismissViewControllerAnimated:flag completion:completion];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
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