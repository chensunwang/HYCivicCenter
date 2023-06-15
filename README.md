# HYCivicCenter

[![CI Status](https://img.shields.io/travis/chensunwang/HYCivicCenter.svg?style=flat)](https://travis-ci.org/chensunwang/HYCivicCenter)
[![Version](https://img.shields.io/cocoapods/v/HYCivicCenter.svg?style=flat)](https://cocoapods.org/pods/HYCivicCenter)
[![License](https://img.shields.io/cocoapods/l/HYCivicCenter.svg?style=flat)](https://cocoapods.org/pods/HYCivicCenter)
[![Platform](https://img.shields.io/cocoapods/p/HYCivicCenter.svg?style=flat)](https://cocoapods.org/pods/HYCivicCenter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

HYCivicCenter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HYCivicCenter'
```

## How to use HYCivicCenter

1、依赖库： 
```
  pod 'AFNetworking'
  pod 'AlipaySDK-iOS'
  pod 'AntVerify'，必须添加源：source "https://code.aliyun.com/mpaas-public/podspecs.git"
  pod 'Masonry'
  pod 'MJExtension'
  pod 'MJRefresh'
  pod 'WechatOpenSDK'
  pod 'SDWebImage'
  pod 'SVProgressHUD'
  pod 'TZImagePickerController', '~> 3.8.3'
```

2、使用HYCivicCenter之前，需要本地导入百度人脸识别SDK（不包括UI部分，UI部分已在HYCivicCenter库中集成）。不导入的话，页面中涉及人脸识别的事项无法正常使用，导致人脸识别界面黑屏或者白屏。

3、集成HYCivicCenter之后，需要在恰当的地方（比如TabBarController或者AppDelegate）实例化Api，并且传入登录用户的token，具体代码如下：
```
#import "MainApi.h"
```
```
MainApi *mainApi = [MainApi sharedInstance];
mainApi.token = @"XXXXXXXXXXXXXXXXX";
```

4、HYCivicCenter库里面的页面都是使用了我们自己的导航栏（HYNavigationController，默认字体白色），同时也允许用户对导航栏的字体颜色进行自定义，只需要在页面入口初始化的地方，设置hyTitleColor的值即可，示例代码如下：
```
#import "HYGovernmentViewController.h"
```
```
HYHandleAffairsViewController *handleVc = [[HYHandleAffairsViewController alloc] init];
handleVc.hyTitleColor = UIColor.blackColor;
```

## Author

chensunwang, 1172665780@qq.com

## License

HYCivicCenter is available under the MIT license. See the LICENSE file for more info.
