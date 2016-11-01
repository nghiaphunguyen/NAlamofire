//
//  NKNetworkErrorType.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public enum NKNetworkErrorType: Error {
    public static let kNoNetwork = -1
    public static let kTimeout = -2
    public static let kUnauthorized = 401
    public static let kUnspecified = -3
    
    case noNetwork
    case timeout
    case business(code: Int, debug:String, message:String)
    case unspecified(error: Error?)
    
    public var errorCode: Int {
        switch self {
        case .noNetwork:
            return -NKNetworkErrorType.kNoNetwork
        case .timeout:
            return -NKNetworkErrorType.kTimeout
        case .business(let code, _, _):
            return code
        case .unspecified(_):
            return -NKNetworkErrorType.kUnspecified
        }
    }
}
