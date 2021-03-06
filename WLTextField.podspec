Pod::Spec.new do |s|

s.name         = "WLTextField"
s.version      = "1.1.0"
s.summary      = "A Lib For TF."
s.description  = <<-DESC
TSTFKit_Swift 文本框的工具类 基于 MXThenAction UIColor
DESC

s.homepage     = "https://github.com/StoneStoneStoneWang/WLTextField"
s.license      = { :type => "MIT", :file => "LICENSE.md" }
s.author             = { "StoneStoneStoneWang" => "yuanxingfu1314@163.com" }
s.platform     = :ios, "9.0"
s.ios.deployment_target = "9.0"

s.swift_version = '5'

s.frameworks = 'UIKit', 'Foundation'

s.source = { :git => "https://github.com/StoneStoneStoneWang/WLTextField.git", :tag => "#{s.version}" }

s.source_files = "Code/**/*.{swift}"

s.dependency 'WLToolsKit'

end


