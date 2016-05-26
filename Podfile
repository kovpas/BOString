workspace 'BOString'

project 'Examples/BOStringDemo'

target 'BOStringDemo_OSX' do
  platform :osx, '10.9'
  pod 'BOString', :path => './'

  target 'BOStringTests_OSX' do
    inherit! :search_paths
    platform :osx, '10.9'
  
    pod 'Specta'
    pod 'Expecta'
  end
end

target 'BOStringDemo_iOS' do
  platform :ios, '6.0'
  pod 'BOString', :path => './'

  target 'BOStringTests_iOS' do
    inherit! :search_paths

    pod 'Specta'
    pod 'Expecta'
  end
end





