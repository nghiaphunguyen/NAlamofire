//
//  NKApiClient.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import NRxSwift
import RxSwift
import Alamofire
import SwiftyJSON
import NLog

public class NKApiClient: AnyObject {
    public static let kUnauthorizedNotificationName = "UnauthorizedNotificationName"
    
    public enum ContentType: String {
        case JSON = "application/json"
        case Multipart = "multipart/form-data"
    }
    
    //public properties
    public let requestTimeout: NSTimeInterval?
    public let host: String
    public let responseQueue: dispatch_queue_t
    
    //private properties
    private var defaultHeaders = [String:String]()
    
    private var alamofireManager: Alamofire.Manager?
    
    public init(host: String,
                requestTimeout: NSTimeInterval? = nil,
                responseQueue: dispatch_queue_t = dispatch_get_main_queue()) {
        self.host = host
        self.requestTimeout = requestTimeout
        self.responseQueue = responseQueue
        self.alamofireManager = Alamofire.Manager(configuration: self.createAlamofireConfiguration(requestTimeout: requestTimeout))
    }
    
    //public override functions
    public func bussinessErrorFromResponse(response: NKAlamofireResponseData) -> NKNetworkErrorType? {
        return NKNetworkErrorType.Business(code: response.response?.statusCode ?? 0, debug: "", message: "")
    }
    
    public func extraUserAgent() -> String? {
        return nil
    }
}

public typealias NKAlamofireResponseData = Response<NSData, NSError>
//public functions
public extension NKApiClient {
    public func addDefaultHeader(key: String, value: String) {
        self.defaultHeaders[key] = value
    }
    
    public func removeDefaultHeader(key: String) {
        self.defaultHeaders[key] = nil
    }
    
    //get
    public func get(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?) -> NKObservable {
        return self.request(.GET, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON)
    }
    
    public func get(urlString: String, parameters: [String: AnyObject]? = nil) -> NKObservable {
        return self.get(urlString, parameters: parameters, additionalHeader: nil)
    }
    
    //delete
    public func delete(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?) -> NKObservable {
        return self.request(.DELETE, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON)
    }
    
    public func delete(urlString: String, parameters: [String: AnyObject]? = nil) -> NKObservable {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil)
    }
    
    //put
    public func put(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType) -> NKObservable {
        return self.request(.PUT, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType)
    }
    
    public func put(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType) -> NKObservable {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType)
    }
    
    public func put(urlString: String, parameters: [String: AnyObject]? = nil) -> NKObservable {
        return self.put(urlString, parameters: parameters, contentType: .JSON)
    }
    
    //post
    public func post(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType) -> NKObservable {
        return self.request(.POST, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType)
    }
    
    public func post(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType) -> NKObservable {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType)
    }
    
    public func post(urlString: String, parameters: [String: AnyObject]? = nil) -> NKObservable {
        return self.post(urlString, parameters: parameters, contentType: .JSON)
    }
    
    public func request(
        method: Alamofire.Method,
        _ URLString: String,
                 parameters: [String: AnyObject]?,
                 additionalHeaders: [String : String]?,
                 encoding: ParameterEncoding,
                 contentType: ContentType) -> NKObservable {
        return self.request(method,
                            withFullPath: self.host ++ URLString,
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType)
    }
    
    public func request(
        method: Alamofire.Method,
        withFullPath fullPath: String,
          parameters: [String: AnyObject]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType) -> NKObservable {
        return NKObservable.nk_create {[unowned self] observer in
            let URLString = fullPath
            
            var headers = self.defaultHeaders
            if let additionalHeader = additionalHeaders {
                for (key, value) in additionalHeader {
                    headers[key] = value
                }
            }
            
            headers["Content-Type"] = contentType == .Multipart ? nil : contentType.rawValue
            let parameterString = String(format: "%@", (parameters == nil) ? "[no params]" : parameters!)
            
            let requestCode = "\(NSDate().timeIntervalSince1970)"
            NLog.server("[\(requestCode)] \(method) \(URLString) \(headers) \(parameterString)")
            
            let completion: Response<NSData, NSError> -> Void = {[weak self](response) -> Void in
                let json = JSON(data: response.data ?? NSData())
                NLog.server("[\(requestCode)] \(response.response?.statusCode ?? 0) \(URLString) \(json) \(response.result.error?.localizedDescription ?? "")")
                
                switch response.result {
                case .Success(_):
                    let jsonWrapper = JSONWrapper(json: json, response: response)
                    observer.nk_setValue(jsonWrapper)
                case .Failure(let error):
                    switch error.code {
                    case -1009:
                        observer.nk_setError(NKNetworkErrorType.NoNetwork)
                    case NSURLErrorTimedOut:
                        observer.nk_setError(NKNetworkErrorType.Timeout)
                    default:
                        if let error = self?.bussinessErrorFromResponse(response) {
                            observer.nk_setError(error)
                        } else {
                            observer.nk_setError(NKNetworkErrorType.Unspecified(error: response.result.error))
                        }
                    }
                }
            }
            
            switch contentType {
            case .JSON:
                self.alamofireManager?.request(method,
                    URLString,
                    parameters: parameters,
                    encoding: encoding,
                    headers: headers)
                    .validate()
                    .responseData(queue: self.responseQueue, completionHandler: completion)
                
            case .Multipart:
                self.alamofireManager?.upload(method, URLString, headers: headers, multipartFormData: { (multipart) in
                    guard let params = parameters else {
                        return
                    }
                    
                    for (key, value) in params {
                        if value.isKindOfClass(NSURL.self) {
                            multipart.appendBodyPart(fileURL: value as! NSURL, name: key)
                            continue
                        }
                        
                        var data: NSData? = nil
                        
                        if value.isKindOfClass(NSString.self) {
                            data = value.dataUsingEncoding(NSUTF8StringEncoding)
                        }
                        
                        if value.isKindOfClass(NSData.self) {
                            data = value as? NSData
                        }
                        
                        if let data = data {
                            multipart.appendBodyPart(data: data, name: key)
                        }
                    }

                    
                    }, encodingCompletion: { (encodingResult) -> Void in
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.validate().responseData(queue: self.responseQueue, completionHandler: completion)
                        case .Failure(let error):
                            observer.nk_setError(NKNetworkErrorType.Unspecified(error: error as NSError))
                        }
                })
            }
        }.nk_continueWithCloure({ (element) -> Observable<NKResult> in
            return self.checkAuthorizationObservable(element)
        })
    }
    
}

//private functions
private extension NKApiClient {
    private func createAlamofireConfiguration(requestTimeout requestTimeout: NSTimeInterval?) -> NSURLSessionConfiguration {
        // add extra user agent
        let userAgentKey = "User-Agent"
        var defaultHeaders = Manager.defaultHTTPHeaders
        if let originUserAgent = defaultHeaders[userAgentKey], extraUserAgent = self.extraUserAgent() {
                defaultHeaders[userAgentKey] = originUserAgent + "##" + extraUserAgent
        }
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        if let requestTimeout = requestTimeout {
            configuration.timeoutIntervalForRequest = requestTimeout
        }
        
        return configuration
    }
    
    private func checkAuthorizationObservable(result: NKResult) -> NKObservable {
        return NKObservable.nk_create({ (observer) in
            if let error = result.error as? NKNetworkErrorType {
                
                if error.errorCode == NKNetworkErrorType.kUnauthorized {
                    NSNotificationCenter.defaultCenter().postNotificationName(NKApiClient.kUnauthorizedNotificationName, object: nil)
                }
                
                observer.nk_setError(error)
            }
            
            return observer.nk_setValue(result.value)
        })
    }
}