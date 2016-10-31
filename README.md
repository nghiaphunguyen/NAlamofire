# NAlamofire
**NAlamofire** - the easy way to convert directly the request to object, array objects via RxSwift. It is wrapper of [Alamofire](https://github.com/Alamofire/Alamofire).

**Some other libs is used in this lib:**
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
final class Item: Mappable {
    var id: Int = 0
    var name: String = ""
    required init?(_ map: Map) {}

    func mapping(map: Map) {
        id    <- map["id"]
        name  <- map["name"]
    }
}

//create API client
let apiClient = NKApiClient(host: "https://server.com")

//convert request to object, array objects

//get items
let itemsObservable: Observable[Item]> = apiClient.get("items")

//get item
let itemObservable: Observable<Item> = apiClient.get("item/\(id)")

//subscrible observables to get objects
itemsObservable.subscrible(onNext: { items in
})

itemsObservable.subscrible(onNext: { item in
})

```

#NKApiClient
**This is wrapper of Alamofire Manager to help you make a request easier (get/post/put/delete). Support multipart/formdata type.**

**Public apis:**
```swift
    public func setDefaultHeader(key:value:)
    public func removeDefaultHeader(key:)
    public func extraUserAgent()
    open func bussinessErrorFromResponse(_:) // override to custom bussinessError. See also at NKNetworkErrorType.
    
``` 
