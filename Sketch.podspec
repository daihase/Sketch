Pod::Spec.new do |spec|
  spec.name         = 'Sketch'
  spec.version      = '2.0'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/daihase/Sketch'
  spec.authors      = { 'daihase' => 'daisuke_hasegawa@librastudio.co.jp' }
  spec.summary      = 'Just placing, anyone can make drawing application.'
  spec.source       = { :git => 'https://github.com/daihase/Sketch.git', :tag => spec.version.to_s }
	spec.swift_version = '4.2'
  spec.ios.deployment_target = '9.2'
  spec.source_files = 'Sketch/Classes/**/*'
end
