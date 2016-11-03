Pod::Spec.new do |s|
  s.name         = "NAlamofire"
  s.version      = "1.9.8"
  s.summary      = "NAlamofire is wrapper of Alamofire - it makes use Alamofire easiest way."
  s.homepage     = "http://cornerteam.com"
  s.license      = "MIT"
  s.author       = "Nghia Nguyen"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/nghiaphunguyen/NAlamofire", :tag => s.version}
  s.source_files  = "Classes", "NAlamofire/Source/**/*.{swift}"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.dependency 'NRxSwift', '0.2.10'
  s.dependency 'RxSwift', '2.6.0'
  s.dependency 'Alamofire', '3.5.1'
  s.dependency 'SwiftyJSON', '2.3.2'
  s.dependency 'ObjectMapper', '1.4.0'
  s.dependency 'NLogProtocol', '1.0.0'


end
