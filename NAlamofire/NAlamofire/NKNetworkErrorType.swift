//
//  NKNetworkErrorType.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public enum NKNetworkErrorType: ErrorType {
    public static let kNoNetwork = -1
    public static let kTimeout = -2
    public static let kUnauthorized = 401
    public static let kUnspecified = -3
    
    case NoNetwork
    case Timeout
    case Business(code: Int, debug:String, message:String)
    case Unspecified(error: NSError?)
    
    public var errorCode: Int {
        switch self {
        case .NoNetwork:
            return -NKNetworkErrorType.kNoNetwork
        case .Timeout:
            return -NKNetworkErrorType.kTimeout
        case .Business(let code, _, _):
            return code
        case .Unspecified(_):
            return -NKNetworkErrorType.kUnspecified
        }
    }
}