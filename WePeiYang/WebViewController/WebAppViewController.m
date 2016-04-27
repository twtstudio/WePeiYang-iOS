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
@import Masonry;

@interface WebAppViewController ()
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) WKWebView *wkWebView;
@property WKWebViewJavascriptBridge *bridge;

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
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
//    _wkWebView.navigationDelegate = self;
    [_wkWebView loadRequest:_request];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _wkWebView.scrollView.bounces = NO;
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    self.view = _wkWebView;
    
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:_wkWebView];
    [_bridge registerHandler:@"tokenHandler_iOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback([[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_SAVE_KEY]);
    }];
    [_bridge registerHandler:@"navigationHandler_iOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
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

- (void)webView: (WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation: (WKNavigation *)navigation{
    
}

-(void)webView:(WKWebView *)webView didFailNavigation: (WKNavigation *)navigation withError:(NSError *)error {
    
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