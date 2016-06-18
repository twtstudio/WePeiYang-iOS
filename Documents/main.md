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
let THIS_IS_A_MACRO "realString"
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

## 账户管理

## 消息显示

## 前端处理

## UIActivity

# 其他

## 新闻详情页面

