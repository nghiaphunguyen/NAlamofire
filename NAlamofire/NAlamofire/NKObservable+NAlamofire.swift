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
}