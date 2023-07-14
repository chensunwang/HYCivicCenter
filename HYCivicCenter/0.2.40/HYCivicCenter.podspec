#
# Be sure to run `pod lib lint HYCivicCenter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HYCivicCenter' # 库名称
  s.version          = '0.2.40' # 库的版本号，我们每次发新版本的时候版本号需要对应修改
  s.summary          = 'HYCivicCenter.' # 库的简单描述

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        HYCivicCenter: 数字市民.
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
  s.ios.deployment_target = '11.0'
  
  # 指定生成的库
#  s.vendored_frameworks = 'SDK/HYCivicCenter.frameworks'
  
  # 是否是静态库 这个地方很重要 假如不写这句打出来的包 就是动态库 不能使用 一运行会报错 image not found
  s.static_framework = true
  
  # arc和mrc选项
  s.requires_arc = true

  # 你的源码位置，源文件 包含 h、m
  s.source_files = ['HYCivicCenter/Classes/**/*']
  
  # 调试公开所有的头文件 这个地方下面的头文件 如果是在Example中调试 就公开全部，需要打包就只公开特定的h文件
  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  # 需要对外开放的头文件  打包只公开特定的头文件
  s.public_header_files = 'HYCivicCenter/Classes/Headers/*.h'
    
  # 资源、比如图片、音频文件等
  s.resource_bundles = {  # 这是个数组，可以添加其他bundle
    'HYCivicCenter' => ['HYCivicCenter/Assets/*.xcassets']
  }
  
  # 表示依赖系统的框架(多个)
#   s.frameworks = 'UIKit', 'MapKit', 'CoreMotion', 'CFNetwork', 'Foundation', 'CoreGraphics', 'CoreText', 'QuartzCore', 'SystemConfiguration', 'Security'
  
  # 表示依赖的系统类库(多个) 注意:系统类库不需要写全名 去掉开头的lib
#   s.libraries = 'sqlite3.0', 'z', 'c++'
  
  # 依赖的第三方/自己的framework
#  s.ios.vendored_frameworks = 'HYCivicCenter/Classes/NetWorkIDCard/CTID_Verification.framework'
  
  # 依赖的第三方/自己的静态库文件 必须以lib为前缀进行命名，否则会出现找不到的情况，这一点非常重要（比如libWeChatSDK.a）
  # s.vendored_libraries = 'HYCivicCenter/Classes/libWeChatSDK.a'
  # s.vendored_libraries = 'HYCivicCenter/Classes/openssl/include/*.{a}'
#  s.vendored_libraries = 'HYCivicCenter/Classes/BDFaceSDK/*.{a}'
  
  # target 项⽬目配置
  s.xcconfig = {
      "OTHER_LDFLAGS" => "$(inherited) -ObjC" # 如果有分类加上
#      'USER_HEADER_SEARCH_PATHS' => 'HYCivicCenter/Classes/BDFaceSDK/include/*.{h}'  # 载入第三方.a头文件
  }
  
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64' }
  
  # 依赖第三方开源框架(多个)
  s.dependency 'AFNetworking'
  s.dependency 'AlipaySDK-iOS'
  s.dependency 'AntVerify'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'WechatOpenSDK'
  s.dependency 'SDWebImage'
  s.dependency 'SVProgressHUD'
  s.dependency 'TZImagePickerController', '~> 3.8.3'
      
end

# pod更新步骤:

# 1.修改代码/文件

# 2.进入Example文件夹，执行pod install

# 3.版本号更改  s.version = '0.1.1'

# 验证类库 cd 到含有HYCivicCenter.podspec 文件下
# 4.本地校验  pod lib lint HYCivicCenter.podspec --use-libraries --allow-warnings --verbose --no-clean
## --allow-warnings       即使有lint警告也允许推送
## --use-libraries        Linter使用静态库来安装规范
## --use-modular-headers  Lint在安装过程中使用模块化headers
## --verbose              显示更多调试信息
## --no-clean
## --sources              私有库，注意--sources后面也需要加上官方源: --sources='https://code.aliyun.com/mpaas-public/podspecs.git,https://cdn.cocoapods.org/'

# 5.提交代码并打对应的tag（tag和podspec文件中保持一致）
## 5.1  git remote add origin https://github.com/chensunwang/HYCivicCenter.git  第一次才需要
## 5.2  git add .
## 5.3  git commit -m 'change version'        提交变动记录
## 5.4  git push origin master -f             推送代码到远端仓库
## 5.5  git tag -a 0.2.40 -m 'add tag 0.2.40'
## 5.6  git push origin 0.2.40

# 6.远程校验  pod spec lint HYCivicCenter.podspec --use-libraries --allow-warnings --verbose --no-clean

# 7.打包  pod package HYCivicCenter.podspec --force --exclude-deps --no-mangle --embedded
## -force                 强制覆盖之前已经生成过的二进制库
## -embedded              生成静态.framework
## –library               生成静态.a
## –dynamic               生成动态.framework
## –bundle-identifier     动态.framework是需要签名的，所以只有生成动态库的时候需要这个BundleId
## –exclude-deps          不包含依赖的符号表，生成动态库的时候不能包含这个命令，动态库一定需要包含依赖的符号表
## –configuration         表示生成的库是debug还是release，默认是release。–configuration=Debug
## –no-mangle             表示不使用name mangling技术，pod package默认是使用这个技术的。我们能在用pod package生成二进制库的时候会看到终端有输出Mangling symbols和Building mangled framework。表示使用了这个技术。如果你的pod库没有其他依赖的话，那么不使用这个命令也不会报错。但是如果有其他依赖，不使用–no-mangle这个命令的话，那么你在工程里使用生成的二进制库的时候就会报错：Undefined symbols for architecture x86_64
## –subspecs              如果你的pod库有subspec，那么加上这个命名表示只给某个或几个subspec生成二进制库，–subspecs=subspec1,subspec2。 生成的库的名字就是你podspec的名字，如果你想生成的库的名字跟subspec的名字一样，那么就需要修改podspec的名字。这个脚本就是批量生成subspec的二进制库，每一个subspec的库名就是podspecName+subspecName
## –spec-sources          一些依赖的source，如果你有依赖是来自于私有库的，那就需要加上那个私有库的source，默认是cocoapods的Specs仓库。 –spec-sources=private,https://github.com/CocoaPods/Specs.git

##（打包前需要切换Xcode，开发和打包的Xcode不一样，打包完成后需要再切换回来，
## 命令为：sudo xcode-select -s /Applications/Xcode13.4.1.app）

# 移除本地私有索引库:pod repo remove HYCivicCenter
# 添加本地私有索引库:pod repo add HYCivicCenter https://github.com/chensunwang/HYCivicCenter.git

# 8.提交到cocoapods仓库  pod trunk push HYCivicCenter.podspec --use-libraries --allow-warnings
# pod repo push HYCivicCenter HYCivicCenter.podspec --use-libraries --allow-warnings


# 搜索不到上传的库：
# 1.首先移除本地缓存的索引文件  rm ~/Library/Caches/CocoaPods/search_index.json
# 2.更新本地的库到最新  pod repo update