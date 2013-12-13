workspace 'BOString'

xcodeproj 'Examples/BOStringDemo'

target 'BOStringDemo_OSX', :exclusive => false do
  platform :osx, '10.9'
  pod 'BOString', :path => './'
end

target 'BOStringDemo_iOS', :exclusive => false do
  platform :ios, '6.0'
  pod 'BOString', :path => './'
end

target 'BOStringTests_OSX', :exclusive => true do
  platform :osx, '10.9'
  pod 'Specta'
  pod 'Expecta'
end

target 'BOStringTests_iOS', :exclusive => true do
  pod 'Specta'
  pod 'Expecta'
end

