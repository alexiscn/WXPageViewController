Pod::Spec.new do |s|
  s.name         = 'WXPageViewController'
  s.version      = '0.0.1'
  s.license = 'MIT'
  s.requires_arc = true
  s.source = { :git => 'https://github.com/alexiscn/WXPageViewController.git', :tag => s.version.to_s }

  s.summary         = 'WXPageViewController'
  s.homepage        = 'https://github.com/alexiscn/WXPageViewController'
  s.license         = { :type => 'MIT' }
  s.author          = { 'alexiscn' => 'alexiscn@example.com' }
  s.platform        = :ios
  s.swift_version   = '5.0'
  s.source_files    =  'Sources/**/*.{swift}'
  s.ios.deployment_target = '12.0'
  
end
