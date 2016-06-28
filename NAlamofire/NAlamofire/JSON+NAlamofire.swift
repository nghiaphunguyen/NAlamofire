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

public extension JSON {
    public func nk_mappingObject<T where T: Mappable>(keyPath: String? = nil) -> T? {
        let json: [String: AnyObject]?
        if let keyPath = keyPath {
            json = self[keyPath].dictionaryObject
        } else {
            json = self.dictionaryObject
        }
        let result: T?
        if let json = json {
            result = Mapper<T>().map(json)
        } else {
            result = nil
        }
        
        return result
    }
    
    public func nk_mappingArray<T where T: Mappable>(keyPath: String? = nil) -> [T] {
        let arrayJson: JSON
        if let keyPath = keyPath {
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
    
    public func nk_mappingObject<T where T: NKMappable>(keyPath: String? = nil) -> T? {
        let json: JSON
        if let keyPath = keyPath {
            json = self[keyPath]
        } else {
            json = self
        }
        
        return T.init(json: json)
    }
    
    public func nk_mappingArray<T where T: NKMappable>(keyPath: String? = nil) -> [T] {
        let arrayJson: JSON
        if let keyPath = keyPath {
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
