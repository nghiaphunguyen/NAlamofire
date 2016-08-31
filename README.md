# NAlamofire 0.1
**NAlamofire** the fastest way to get responses from API via RxSwift. It is wrapper of [Alamofire](https://github.com/Alamofire/Alamofire).

**Some other libs is used in this lib:**
1. [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
2. [NRxSwift](https://github.com/nghiaphunguyen/NRxSwift)
3. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
4. [NLog](https://github.com/nghiaphunguyen/NLog)

# CHANGE LOG

**v0.5.9**

# INSTALLATION

### Pod
```bash
use_frameworks!

pod 'NAlamofire'
```

### Carthage
```bash
github 'nghiaphunguyen/NAlamofire'
```

# USAGE

```swift
import ObjectMapper
import SwiftyJSON
import NAlamofire
```

##### Example
```swift
final class Item: Mappable {
    var id: Int = 0
    var name: String = ""
    required init?(_ map: Map) {}

    func mapping(map: Map) {
        id    <- map["id"]
        name  <- map["name"]
    }
}

let apiClient = NKApiClient("https://server.com")

let itemsObservable: Observable<[Item]> = apiClient.get("items")
itemsObservable.subscribleNext { items in
    // do somthing
}.addDisposable(self.disposeBag)

```
