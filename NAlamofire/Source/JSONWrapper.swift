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

public class JSONWrapper : NSObject
{
    public var json:JSON = JSON([String: AnyObject]())
    public var response: Response<NSData, NSError>?
    
    public init(json:JSON , response: Response<NSData, NSError>? = nil) {
        self.json = json
        self.response = response
    }
}