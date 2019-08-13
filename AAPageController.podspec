Pod::Spec.new do |s|

s.name         = "AAPageController"
s.version      = "1.2.0"
s.summary      = "iOS PageController with top tab"

s.homepage     = "https://github.com/Fxxxxxx/AAPageController"
#s.screenshots  = ""

s.license      = { :type => "MIT", :file => "LICENSE" }

s.authors            = { "Aaron Feng" => "e2shao1993@163.com" }

s.swift_version = "5"

s.ios.deployment_target = "8.0"

s.source       = { :git => "https://github.com/Fxxxxxx/AAPageController.git", :tag => s.version }

s.source_files  = "AAPageController/*"

s.requires_arc = true
s.framework = "UIKit"
s.dependency 'SnapKit'

end
