//
//  NKAlamofireUtils.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation

infix operator ++
func ++(left: String, right: String) -> String {
    var result = (left as NSString).appendingPathComponent(right)
    if let last = right.characters.last, last != "/" {
        result += "/"
    }
    
    return result
}
