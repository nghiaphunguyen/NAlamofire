# NAlamofire
**NAlamofire** - the easy way to convert directly the request to object, array objects via RxSwift in a few lines code. It is wrapper of [Alamofire](https://github.com/Alamofire/Alamofire).

**Some referenced libs :**
1. [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
2. [NRxSwift](https://github.com/nghiaphunguyen/NRxSwift)
3. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
4. [NLogProtocol](https://github.com/nghiaphunguyen/NLogProtocol)

#INSTALLATION

### Pod
```bash
use_frameworks!
pod 'NAlamofire'
```

#USAGE
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

    init?(_ map: Map) {}

    mutating func mapping(map: Map) {
        id <- map[Key.id]
        name <- map[Key.name]
    }
}

//create API client
let apiClient = NKApiClient(host: "https://server.com")

// create items observable
let itemsObservable: Observable[Item]> = apiClient.get("items")

//subscrible observables to get objects
itemsObservable.subscrible(onNext: { items in
})

```

#NKApiClient
####This is wrapper of Alamofire Manager to help you make a request easier (get/post/put/delete). Support multipart/formdata type.

####Public apis:
```swift
    public func setDefaultHeader(key:value:)
    public func removeDefaultHeader(key:)
    public func extraUserAgent()
    open func bussinessErrorFromResponse(_:) // override to customize bussinessError. See also at NKNetworkErrorType.
``` 

#####Subscribe notification name *NKApiClient.kUnauthorizedNotificationName* to handle unauthorization case.

#Print request and response data
```swift
    import NLogProtocol

    struct CustomNLog: NLogProtocol {//See apis at NLogProtocol}

    NKLOG = CustomNLog.self
```

####Thanks @khoinguyenvu and @trinhngocthuyen for your constribution.
