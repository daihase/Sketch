#
# Be sure to run `pod lib lint Sketch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Sketch'
  s.version          = '1.0.0'
  s.summary          = 'Just placing, anyone can make drawing application.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
DoodleKit has the basic functions for drawing from the beginning. Anyone can easily create drawing iOS Applications.
                       DESC

  s.homepage         = 'https://github.com/daihase/Sketch'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daihase' => 'daisuke_hasegawa@librastudio.co.jp' }
  s.source           = { :git => 'https://github.com/daihase/DoodleKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'Sketch/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Sketch' => ['Sketch/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
