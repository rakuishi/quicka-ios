platform :ios, "15.0"

target 'Quicka' do
  pod 'SDWebImage', '~> 5.19.7', :inhibit_warnings => true
  pod 'Realm', '~> 10.54.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end