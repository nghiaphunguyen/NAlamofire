//
//  NKNetworkErrorType.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

public enum NKNetworkErrorType: ErrorType {
    case NoNetwork
    case Timeout
    case Business(code: Int, debug:String, message:String)
    case Unspecified(error: NSError?)
    
    public var errorCode: Int {
        switch self {
        case .NoNetwork:
            return -1
        case .Timeout:
            return -2
        case .Business(let code, _, _):
            return code ?? -3
        case .Unspecified(_):
            return -4
        }
    }
}