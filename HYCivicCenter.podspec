#
# Be sure to run `pod lib lint HYCivicCenter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HYCivicCenter' # 库名称
  s.version          = '0.1.1' # 库的版本号，我们每次发新版本的时候版本号需要对应修改
  s.summary          = 'A short description of HYCivicCenter.' # 库的简单描述

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  # 主页
  s.homepage         = 'https://github.com/chensunwang/HYCivicCenter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  
  # 遵循的协议
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
  # 作者
  s.author           = { 'chensunwang' => '1172665780@qq.com' }
  
  # 库的git地址，tag就是对应的版本，注意这个tag就是发布的时候的版本，我们引用第三方库时，有时需要指定版本，对应的就是这个版本号
  s.source           = { :git => 'https://github.com/chensunwang/HYCivicCenter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

# 下面配置依赖的资源、库、配置等
  
  # 工程依赖系统版本
  s.ios.deployment_target = '9.0'
  
  # 是否是静态库 这个地方很重要 假如不写这句打出来的包 就是动态库 不能使用 一运行会报错 image not found
  s.static_framework = true
  
  # arc和mrc选项
  s.requires_arc = true
  
  # 链接设置 重要
  # s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}

  # 你的远吗位置，源文件 包含 h、m
  s.source_files = 'HYCivicCenter/Classes/**/*'
  
  # 调试公开所有的头文件 这个地方下面的头文件 如果是在Example中调试 就公开全部，需要打包就只公开特定的h文件
  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  # 需要对外开放的头文件  打包只公开特定的头文件
  s.public_header_files = 'HYCivicCenter/Classes/Headers/*.h'
    
  # 资源、比如图片、音频文件等
  s.resource_bundles = {
    # 这是个数组，可以添加其他bundle
    'HYCivicCenter' => ['HYCivicCenter/Assets/*.png']
  }
  
  # 表示依赖系统的框架(多个)
  # s.frameworks = 'UIKit', 'MapKit'
  
  # 表示依赖的系统类库(多个) 注意:系统类库不需要写全名 去掉开头的lib
  # s.libraries = 'stdc++','sqlite3'
  
  # 依赖的第三方/自己的framework
  s.ios.vendored_frameworks = 'HYCivicCenter/Classes/NetWorkIDCard/CTID_Verification.framework'
  
  # 表示依赖第三方/自己的静态库（比如libWeChatSDK.a）
  # 依赖的第三方的或者自己的静态库文件必须以lib为前缀进行命名，否则会出现找不到的情况，这一点非常重要
  # s.vendored_libraries = 'HYCivicCenter/Classes/libFaceSSDKLib.a'
  # s.vendored_libraries = 'HYCivicCenter/Classes/openssl/include/*.{a}'
  s.vendored_libraries = 'HYCivicCenter/Classes/BDFaceSDK/libFaceSSDKLib.a'
  
  # 载入第三方.a头文件
  s.xcconfig = {
      'USER_HEADER_SEARCH_PATHS' => 'HYCivicCenter/Classes/BDFaceSDK/include/*.{h}'
  }
  
  # 依赖第三方开源框架(多个)
   s.dependency 'AFNetworking'
   s.dependency 'AlipaySDK-iOS'
   s.dependency 'Masonry'
   s.dependency 'MJRefresh'
   s.dependency 'MJExtension'
   s.dependency 'WechatOpenSDK'
   s.dependency 'SDWebImage'
   s.dependency 'SVProgressHUD'
   s.dependency 'TZImagePickerController', '~> 3.8.3'
      
end
