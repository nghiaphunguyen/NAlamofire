//
//  JSONWrapper.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

open class JSONWrapper : NSObject
{
    open var json:JSON = JSON([String: AnyObject]())
    open var response: NKAlamofireResponseData?
    
    public init(json:JSON , response: NKAlamofireResponseData? = nil) {
        self.json = json
        self.response = response
    }
}
