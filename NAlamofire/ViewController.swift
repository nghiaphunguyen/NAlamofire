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
import RxSwift
import NLogProtocol
import Alamofire

struct NLog: NKLogProtocol {
    static func debug(_ message: String, _ tag: String, color: UIColor?, file: String, function: String, line: Int) {
        print("\(message)")
    }
    
    static func info(_ message: String, _ tag: String, color: UIColor?, file: String, function: String, line: Int) {
        
    }
    
    static func server(_ message: String, _ tag: String, color: UIColor?, file: String, function: String, line: Int) {
        print("\(message)")
    }
    
    static func warning(_ message: String, _ tag: String, color: UIColor?, file: String, function: String, line: Int) {
        
    }
    
    static func error(_ message: String, _ tag: String, color: UIColor?, file: String, function: String, line: Int) {
        
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NKLOG = NLog.self
        
        let client = NKApiClient(host: "http://risechime.huyvo.me/")
        
        let username = "nghia111111114@gmail.com"
        let password = "nghia123"
        let params =  ["username": username, "email": username, "password1": password, "password2": password]
//        let registration: Observable<JSONWrapper> = client.request(.post, "http://risechime.huyvo.me/rest-auth/registration/", parameters: params, additionalHeaders: nil, encoding: URLEncoding.default, contentType: .FormData)
        let registration: Observable<JSONWrapper> = client.post("rest-auth/registration/", parameters: params, contentType: .JSON)
        
        registration.subscribe()
        
//        Alamofire.SessionManager.default.request("http://risechime.huyvo.me/rest-auth/registration/", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).validate().responseData { (response) in
//            if let data = response.result.value {
//                let json = JSON(data: data)
//                print("result: \(json)")
//            } else {
//                print("error: \(response.result.error)")
//            }
//        }
                
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

