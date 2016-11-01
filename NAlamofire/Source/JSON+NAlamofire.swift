//
//  JSON+NAlamofire.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

public protocol NKAlamofireKey: JSONSubscriptType {
    var rawValue: String {get}
}

public extension ObjectMapper.Map {
    public subscript (key: NKAlamofireKey) -> ObjectMapper.Map {
        return self[key.rawValue]
    }
    public subscript (key: NKAlamofireKey, nested nested: Bool) -> ObjectMapper.Map {
        return self[key.rawValue, nested: nested]
    }
    public subscript (key: NKAlamofireKey, ignoreNil ignoreNil: Bool) -> ObjectMapper.Map {
        return self[key.rawValue, ignoreNil: ignoreNil]
    }
    public subscript (key: NKAlamofireKey, nested nested: Bool, ignoreNil ignoreNil: Bool) -> ObjectMapper.Map {
        return self[key.rawValue, nested: nested, ignoreNil: ignoreNil]
    }
}

public extension NKAlamofireKey {
    public var jsonKey: JSONKey {
        return JSONKey.key(self.rawValue)
    }
}

public extension JSON {
    public func nk_mappingObject<T>(_ keyPath: String? = nil) -> T? where T: Mappable {
        let json: [String: Any]?
        
        if let keyPath = keyPath?.components(separatedBy: ".").map({$0 as JSONSubscriptType}) {
            json = self[keyPath].dictionaryObject
        } else {
            json = self.dictionaryObject
        }
        let result: T?
        if let json = json {
            result = Mapper<T>().map(JSON: json)
        } else {
            result = nil
        }
        
        return result
    }
    
    public func nk_mappingArray<T>(_ keyPath: String? = nil) -> [T] where T: Mappable {
        let arrayJson: JSON
        if let keyPath = keyPath?.components(separatedBy: ".").map({$0 as JSONSubscriptType}) {
            arrayJson = self[keyPath]
        } else {
            arrayJson = self
        }
        
        var result = [T]()
        for (_, json) in arrayJson {
            if let object: T = json.nk_mappingObject() {
                result.append(object)
            }
        }
        
        return result
    }
    
    public func nk_mappingObject<T>(_ keyPath: String? = nil) -> T? where T: NKMappable {
        let json: JSON
        if let keyPath = keyPath?.components(separatedBy:".").map({$0 as JSONSubscriptType}) {
            json = self[keyPath]
        } else {
            json = self
        }
        
        return T.init(json: json)
    }
    
    public func nk_mappingArray<T>(_ keyPath: String? = nil) -> [T] where T: NKMappable {
        let arrayJson: JSON
        if let keyPath = keyPath?.components(separatedBy:".").map({$0 as JSONSubscriptType}) {
            arrayJson = self[keyPath]
        } else {
            arrayJson = self
        }
        
        var result = [T]()
        for (_, json) in arrayJson {
            if let object: T = json.nk_mappingObject() {
                result.append(object)
            }
        }
        
        return result
    }
}
