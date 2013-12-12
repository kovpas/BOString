workspace 'BOString'

platform :ios, '6.0'

xcodeproj 'Examples/BOStringDemo'
pod 'BOString', :path => './'

target :test, :exclusive => true do
  link_with 'BOStringTests'
  pod 'Specta'
  pod 'Expecta'
end

