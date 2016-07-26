//
//  NKObservable+NAlamofire.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import NRxSwift
import ObjectMapper
import SwiftyJSON

public extension Observable where Element: JSONWrapper {
    public func nk_autoMappingObject<T where T: Mappable>(keyPath: String? = nil) -> Observable<T?> {
        
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T?> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: T? = jsonWrapper.json.nk_mappingObject(keyPath)
            
            return Observable<T?>.just(object)
        })
    }
    
    public func nk_autoMappingObject<T where T: NKMappable>(keyPath: String? = nil) -> Observable<T?> {
        
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T?> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: T? = jsonWrapper.json.nk_mappingObject(keyPath)
            
            return Observable<T?>.just(object)
        })
    }
    
    public func nk_autoMappingObject<T where T: Mappable>(keyPath: String? = nil) -> Observable<T> {
        
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: T? = jsonWrapper.json.nk_mappingObject(keyPath)
            
            guard let obj = object else {
                return Observable<T>.error(NKNetworkErrorType.Unspecified(error: nil))
            }
            
            return Observable<T>.just(obj)
        })
    }
    
    public func nk_autoMappingArray<T where T: Mappable>(keyPath: String? = nil) -> Observable<[T]> {
        return self.flatMapLatest({ (jsonWrapper) -> Observable<[T]> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: [T] = jsonWrapper.json.nk_mappingArray(keyPath)
            
            return Observable<[T]>.just(object)
        })
    }
    
    public func nk_autoMappingObject<T where T: NKMappable>(keyPath: String? = nil) -> Observable<T> {
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: T? = jsonWrapper.json.nk_mappingObject(keyPath)
            
            guard let obj = object else {
                return Observable<T>.error(NKNetworkErrorType.Unspecified(error: nil))
            }
            
            return Observable<T>.just(obj)
        })
    }
    
    public func nk_autoMappingArray<T where T: NKMappable>(keyPath: String? = nil) -> Observable<[T]> {
        return self.flatMapLatest({ (jsonWrapper) -> Observable<[T]> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: [T] = jsonWrapper.json.nk_mappingArray(keyPath)
            
            return Observable<[T]>.just(object)
        })
    }
}

public extension Observable where Element: NKResult {
    public func nk_mappingObject<T where T: Mappable>(type: T.Type, keyPath: String? = nil) -> Observable<Element> {
        return self.nk_continueWithSuccessCloure({ (element) -> Observable<Element> in
            guard let jsonWrapper = (element as NKResult).value as? JSONWrapper else {
                return Observable.just(NKResult(error: NKNetworkErrorType.Unspecified(error: nil))  as! Element)
            }
            
            let result: T? = jsonWrapper.json.nk_mappingObject(keyPath)
            
            return Observable.just(NKResult(value: result) as! Element)
        })
    }
    
    public func nk_mappingArray<T where T: Mappable>(type: T.Type, keyPath: String? = nil) -> Observable<Element> {
        return self.nk_continueWithSuccessCloure({ (element) -> Observable<Element> in
            guard let jsonWrapper = (element as NKResult).value as? JSONWrapper else {
                return Observable.just(NKResult(error: NKNetworkErrorType.Unspecified(error: nil))  as! Element)
            }
            
            let result: [T] = jsonWrapper.json.nk_mappingArray(keyPath)
            return Observable.just(NKResult(value: result) as! Element)
        })
    }
    
    public func nk_mappingObject<T where T: NKMappable>(type: T.Type, keyPath: String? = nil) -> Observable<Element> {
        return self.nk_continueWithSuccessCloure({ (element) -> Observable<Element> in
            guard let jsonWrapper = (element as NKResult).value as? JSONWrapper else {
                return Observable.just(NKResult(error: NKNetworkErrorType.Unspecified(error: nil))  as! Element)
            }
            
            let result: T? = jsonWrapper.json.nk_mappingObject(keyPath)
            
            return Observable.just(NKResult(value: result) as! Element)
        })
    }
    
    public func nk_mappingArray<T where T: NKMappable>(type: T.Type, keyPath: String? = nil) -> Observable<Element> {
        return self.nk_continueWithSuccessCloure({ (element) -> Observable<Element> in
            guard let jsonWrapper = (element as NKResult).value as? JSONWrapper else {
                return Observable.just(NKResult(error: NKNetworkErrorType.Unspecified(error: nil))  as! Element)
            }
            
            let result: [T] = jsonWrapper.json.nk_mappingArray(keyPath)
            return Observable.just(NKResult(value: result) as! Element)
        })
    }
    
    public func nk_mapping(closure: (json: JSON) -> Any?) -> Observable<Element> {
        return self.nk_continueWithSuccessCloure({ (element) -> Observable<Element> in
            guard let json = ((element as NKResult).value as? JSONWrapper)?.json else {
                return Observable.just(NKResult(error: NKNetworkErrorType.Unspecified(error: nil))  as! Element)
            }
            
            return Observable.just(NKResult(value: closure(json: json)) as! Element)
        })
    }
}