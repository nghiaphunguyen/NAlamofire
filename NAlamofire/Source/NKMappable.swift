//
//  NKMappable.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/28/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol NKMappable {
    init?(json: JSON)
}