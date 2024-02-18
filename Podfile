# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'UnsplashPhotos' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UnsplashPhotos
  pod 'SnapKit'
  pod 'Alamofire', '~> 5.0'
  pod 'Kingfisher', '~> 7.0'
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod 'RxDataSources', '~> 4.0.1'
  pod 'RxRetroSwift'
  pod 'Toaster'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
end
