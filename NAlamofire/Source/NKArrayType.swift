//
//  NKArrayType.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 7/18/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation


public protocol NKArrayType {
    associatedtype Element
}

extension Array: NKArrayType {}