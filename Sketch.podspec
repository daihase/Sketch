Pod::Spec.new do |spec|
  spec.name         = 'Sketch'
  spec.version      = '3.0'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/daihase/Sketch'
  spec.authors      = { 'daihase' => 'vermouth.6969@gmail.com' }
  spec.summary      = 'Just placing, anyone can make drawing application.'
  spec.source       = { :git => 'https://github.com/daihase/Sketch.git', :tag => spec.version.to_s }
	spec.swift_version = [5.0]
  spec.ios.deployment_target = '9.2'
  spec.source_files = 'Sketch/Classes/**/*'
end
