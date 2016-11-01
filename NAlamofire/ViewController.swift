//
//  ViewController.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 10/17/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

struct Item: Mappable {
    private enum Key: String, NKAlamofireKey {
        case id, name
    }
    
    var id: Int = 0
    var name: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map[Key.id]
        name <- map[Key.name]
    }
}

struct Category: NKMappable {
    
    private enum Key: String, NKAlamofireKey {
        case id, name
    }
    
    let id: Int
    let name: String
    
    init?(json: JSON) {
        guard json[Key.id].int != nil
            && json[Key.name].string != nil else {
            return nil
        }
        
        self.id = json[Key.id].intValue
        self.name = json[Key.name].stringValue
    }
}

