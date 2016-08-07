# 微北洋 iOS 开发文档简介

用于解释一些微北洋 iOS 的规范和坑。

# 语言及代码风格

微北洋使用 Swift 与 Objective-C 混编开发，核心部分封装由于比较早，为 Objective-C，外部 ViewController 绝大部分使用 Swift 开发。之后开发中可自由选择语言，推荐使用 Swift。已有 Objective-C 代码在不存在重大问题的情况下无需重构至 Swift。

代码风格的一些规范如下所示：

## 括号

强力推荐左括号同一行右括号换行。不过也无所谓。

## 宏

Objective-C 中写在`#import`下面，视是否需要暴露决定放在头文件还是实现中。形式：

```objc
#define THIS_IS_A_MACRO @"realString"
```

Swift 中由于取消宏，通过`let`定义，写在`import`下面。形式：

```swift
let THIS_IS_A_MACRO = "realString"
```

## 空格

Objective-C 方法注意在 scope 和返回类型之间有空格：

```objc
- (IBAction)testAction:(id)sender;
```

方法调用的语法之间（尤其嵌套时）也有空格：

```objc
UIViewController *controller = [[UIViewController alloc] init];
```

Swift 注意在名称（参数名、变量名、etc）和类型之间有空格：

```swift
let a: Int = 5
class func getClasstableData(success: (data: AnyObject, termStartTime: Int) -> (), notBinded: () -> (), otherFailure: (errorMsg: String) -> ())
```

调用函数时，参数名和参数之间也有空格：

```swift
otherFailure(errorMsg: dic["message"].stringValue)
```

在数组、字典、集合的定义时，也要注意 key 和 value 之间、元素和元素之间也要在分隔符（:或,）之后有空格隔开，比如：

```swift
dic = ["key1": "value1", "key2": "value2"]
```

同时一般来说二元运算符的两边均有空格，

# 结构

目前微北洋按照不同功能分为不同的 Section，每个 Section 内又按 Model，View，Controller 组织代码与资源。Section 外部，Main 里面放微北洋 app 最关键的不可或缺的部分，Model 里面是封装出来的直接涉及 API 及其他基础层面的代码，Resource 是一些图像和封装好的第三方闭源 SDK 等。

由于 Storyboard 在多人协作时仍具有奇怪的问题，因此每个 Section 仍通过 ViewController 绑定 XIB 的方式开发，代码里手动管理跳转。注意需保持实际文件结构和项目目录结构的一致，便于代码的浏览。

# 本地存储

本地存储主要通过封装好的 wpyCacheManager 和第三方 SQLite wrapper 库 FMDB 实现。需要本地存储的内容主要有：

## 用户设置及调试选项

通过`NSUserDefaults`存储键值。

## 缓存

无需用户删除或修改的文件，通过封装好的 wpyCacheManager 直接存储／调用原始对象进行解析。基本原理是利用`NSKeyedArchiver`和`NSKeyedUnarchiver`保存至 sandbox 的 caches 目录，直接调用各方法。如果需要和 Extension 或 Apple Watch 共享的数据，需保存到 App Group 里，则调用包含 group 的方法。

## 数据库

通过 FMDB 操作 SQLite，将数据库保存到 sandbox 的 documents 目录。可参考 LibraryDataManager.swift 里的实现。注意在 String 里书写 SQL 语句时建议 SQL 关键字全部使用大写。

# 底层封装

## 网络请求

网络请求部分通过`SolaSessionManager`类封装 API 所要求的参数加签、SHA-1、加 HTTP header 等操作，并直接通过 block 传递解析到的对象和`NSURLSessionDataTask`。twtSDK 类通过调用封装的`+ (void)solaSessionWithSessionType:(SessionType)type URL:(NSString *)url token:(NSString *)token parameters:(NSDictionary *)parameters success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;`方法对 API 进行调用，其他各 DataManager 类通过调用 twtSDK 中的方法根据不同情况进行数据解析处理。

TODO：twtSDK 类应抽出为一个单独 .a 库和一个 .h 头文件以方便调用。

在通过`DevKit`类进行数据记录后，`SolaSessionManager`类还具有根据是否打开调试选项而执行将 response 和 request 存储到本地的功能。

## 账户管理

主要通过`AccountManager`类封装的功能。Token 主要通过`NSUserDefaults`存储在本地，同时在 App 加载之后会被写入一个特殊的单例`SolaInstance`中。每次启动会在后台线程验证 token 是否有效，若 token 过期则尝试刷新，若刷新失败则本地删除 token，即恢复未登录状态。

## 消息显示

`MsgDisplay`类。需要注意现在这样可以实现是因为 SVProgressHUD 使用了单例模式，之后如果改用其他组件需根据具体情况进行调整。

## 前端处理

`FrontEndProcessor`类主要是将新闻详情部分返回的 HTML 更改为适配移动端显示的网页内容。首先通过`NSScanner`解析 HTML 中的图片标签，提取地址并将可能为尺寸固定的图片修改为`img-responsive`。`img-responsive`类不仅实现图片的自适应，而且通过 WebViewJavaScriptBridge 可以实现图片点击放大的功能。然后在整个页面之外套一层 Bootstrap 以自适配移动端。最后把 API 返回的标题、来源、审稿等信息也嵌入页面内。JS 和 CSS 文件均直接放入本地，直接在前端中通过`<script src=\"bridge.js\"></script>`无需其他路径。

在需要展示前端的 ViewController（如`NewsContentViewController`），加 UIWebView，实现 WebViewJavaScriptBridge。可以直接在 UIWebView 中加载之前通过`FrontEndProcessor`处理过的 HTML。需要注意的是此时 baseURL 必须为 Bundle 中的资源路径，这样才能加载我们本地的 css 和 js。

```objc
[self.webView loadHTMLString:processedHTML baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
```

## UIActivity

一些针对部分内容的操作可以封装为 UIActivity 的形式通过 UIActivityViewController 调用，这样比较符合系统规范。UIActivity 主要需要实现几个特定方法，随便参考某个已有实现就可以了。
