#NAlamofire
**NAlamofire** - the easy way to convert directly the request to object, array objects via RxSwift in a few lines code.

Referenced libs:
  1. [Alamofire](https://github.com/Alamofire/Alamofire)
  2. [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
  3. [NRxSwift](https://github.com/nghiaphunguyen/NRxSwift)
  4. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
  5. [NLogProtocol](https://github.com/nghiaphunguyen/NLogProtocol)

###INSTALLATION
Use version 1.9.7 for swift 2.3 

####Pod
```bash
use_frameworks!
pod 'NAlamofire'
```

###USAGE
```swift
import ObjectMapper
import NAlamofire

//Object must be conformed to Mappable or NKMappable.
struct Item: Mappable {
    private enum Key: String, NKAlamofireKey {
        case id, name
    }

    var id: Int = 0
    var name: String = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map[Key.id]
        name <- map[Key.name]
    }
}

//create API client
let apiClient = NKApiClient(host: "https://server.com")

// create items observable
let itemsObservable: Observable[Item]> = apiClient.get("items")

//subscrible observable to get objects
itemsObservable.subscrible(onNext: { items in
})

```

###NKApiClient
This is wrapper of Alamofire Manager to help you make a request easier (get/post/put/delete). Support multipart/formdata type.

####Public apis:
```swift
    public func setDefaultHeader(key:value:)
    public func removeDefaultHeader(key:)
    public func extraUserAgent()
    open func bussinessErrorFromResponse(_:) // override to customize bussinessError. See also at NKNetworkErrorType.
```

Subscribe notification name **NKApiClient.kUnauthorizedNotificationName** to handle unauthorization case.

###Print request and response data
Make the logger conform to NLogProtocol to print request and response data.

```swift
    import NLogProtocol

    struct CustomNLog: NLogProtocol {//See apis at NLogProtocol}

    NKLOG = CustomNLog.self
```

####Thanks @khoinguyenvu and @trinhngocthuyen for your constribution.
