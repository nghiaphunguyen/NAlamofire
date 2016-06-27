//
//  NKAlamofireUtils.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

infix operator ++ {}
public func ++(left: String, right: String) -> String {
    return (left as NSString).stringByAppendingPathComponent(right)
}
