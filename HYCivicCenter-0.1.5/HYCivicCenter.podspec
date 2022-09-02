Pod::Spec.new do |s|
  s.name = "HYCivicCenter"
  s.version = "0.1.5"
  s.summary = "HYCivicCenter."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"chensunwang"=>"1172665780@qq.com"}
  s.homepage = "https://github.com/chensunwang/HYCivicCenter"
  s.description = "HYCivicCenter: \u6570\u5B57\u5E02\u6C11."
  s.requires_arc = true
  s.xcconfig = {"OTHER_LDFLAGS"=>"$(inherited) -ObjC", "USER_HEADER_SEARCH_PATHS"=>"HYCivicCenter/Classes/BDFaceSDK/include/*.{h}"}
  s.source = { :path => '.' }

  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'ios/HYCivicCenter.embeddedframework/HYCivicCenter.framework'
end
