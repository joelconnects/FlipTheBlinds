Pod::Spec.new do |s|
  s.name             = 'FlipTheBlinds'
  s.version          = '0.1.1'
  s.summary          = 'An animation transition creating a venetian blinds domino effect'
 
  s.description      = <<-DESC
FlipTheBlinds is an animation transition that creates a venetian blinds domino effect
                       DESC
 
  s.homepage         = 'https://github.com/joelconnects/FlipTheBlinds'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Joel Bell' => 'joelconnects@gmail.com' }
  s.source           = { :git => 'https://github.com/joelconnects/FlipTheBlinds.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'FlipTheBlinds/FTB*.swift'
 
end