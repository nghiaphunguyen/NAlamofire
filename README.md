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

struct Category: NKMappable {

    private enum Key: String, NKAlamofireKey {
        case id, name
    }

    let id: Int
    let name: String

    init?(json: JSON) {
        guard json[Key.id].int != nil && json[Key.name].string != nil else {
            return nil
        }

        self.id = json[Key.id].intValue
        self.name = json[Key.name].stringValue
    }
}

//create API client
let apiClient = NKApiClient(host: "https://server.com")

//convert request to object, array objects

//get items
let itemsObservable: Observable[Item]> = apiClient.get("items")

//get category by id
let categoryObservable: Observable<Category> = apiClient.get("category/3")

//subscrible observables to get objects
itemsObservable.subscrible(onNext: { items in
})

categoryObservable.subscrible(onNext: { category in
})

```

#NKApiClient
**This is wrapper of Alamofire Manager to help you make a request easier (get/post/put/delete).**
**Support multipart/formdata type.**

**Public apis:**
```swift
    public func setDefaultHeader(key:value:)
    public func removeDefaultHeader(key:)
    public func extraUserAgent()
    open func bussinessErrorFromResponse(_:) // override to custom bussinessError. See also at NKNetworkErrorType.
    
``` 
