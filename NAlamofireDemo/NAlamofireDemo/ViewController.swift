//
//  ViewController.swift
//  NAlamofireDemo
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import UIKit
import NAlamofire
import RxSwift

class ViewController: UIViewController {
let apiClient = NKApiClient(host: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
        
        // Dispose of any resources that can be recreated.
    }

    func get() -> Observable<JSONWrapper> {
        return apiClient.get("")
    }
    
    func post() -> Observable<JSONWrapper> {
        return apiClient.post("")
    }
    
    func requestVerifyCode (
        telephone: String) -> Observable<JSONWrapper> {
        return apiClient.post("/private/users/request_verify_code", parameters: ["telephone" : telephone])
    }
}

