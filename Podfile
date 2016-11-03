# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NAlamofire' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'NLogProtocol', '1.0.1'
pod 'Alamofire', '3.5.1'
pod 'ObjectMapper', '1.4.0'
pod 'SwiftyJSON', '2.3.2'
pod 'NRxSwift', '0.2.10'
pod 'RxSwift', '2.6.0'
  # Pods for NAlamofire

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = '-DDEBUG'
                else
                config.build_settings['OTHER_SWIFT_FLAGS'] = ''
            end
        end
    end
end
