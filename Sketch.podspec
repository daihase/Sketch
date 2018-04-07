Pod::Spec.new do |spec|
  spec.name         = 'Sketch'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/daihase/Sketch'
  spec.authors      = { 'daihase' => 'daisuke_hasegawa@librastudio.co.jp' }
  spec.summary      = 'Just placing, anyone can make drawing application.'
  spec.source       = { :git => 'https://github.com/daihase/Sketch.git', :tag => spec.version.to_s }
  spec.source_files = 'Sketch/Classes/**/*'
end
