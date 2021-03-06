Pod::Spec.new do |s|
  s.name         = "NAlamofire"
  s.version      = "2.0.11"
  s.summary      = "NAlamofire is wrapper of Alamofire - it makes use Alamofire easiest way."
  s.homepage     = "http://cornerteam.com"
  s.license      = "MIT"
  s.author       = "Nghia Nguyen"
  s.platform     = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/nghiaphunguyen/NAlamofire", :tag => s.version}
  s.source_files  = "Classes", "NAlamofire/Source/**/*.{swift}"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.dependency 'NRxSwift'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
  s.dependency 'ObjectMapper'
  s.dependency 'NLogProtocol'

end
