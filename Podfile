# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
pod 'PayPal-iOS-SDK'
target 'PonoAdventure' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  use_frameworks!
  # Pods for PonoAdventure
  pod 'PopupDialog', '~> 0.5'
  pod 'YouTubePlayer'
  pod 'Alamofire', '~> 4.0'
  pod 'Gloss', '~> 1.1'
  pod 'Kingfisher', '~> 3.0'
  pod 'PKHUD'
  pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'
  target 'PonoAdventureTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PonoAdventureUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end

end
