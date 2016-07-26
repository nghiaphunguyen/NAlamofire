//
//  NKApiClient.swift
//  NAlamofire
//
//  Created by Nghia Nguyen on 6/27/16.
//  Copyright © 2016 Nghia Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON
import NLog
import ObjectMapper

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
    public func get<T: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.GET, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func get<T: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.GET, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func get<T: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.GET, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func get<T: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.GET, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func get(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?) -> Observable<JSONWrapper> {
        return self.request(.GET, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON)
    }
    
    public func get<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.GET, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func get<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.GET, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    //
    public func get<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func get<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func get<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func get<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func get(urlString: String, parameters: [String: AnyObject]? = nil) -> Observable<JSONWrapper> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil)
    }
    
    public func get<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func get<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    //delete
    public func delete<T: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.DELETE, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func delete<T: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.DELETE, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func delete<T: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.DELETE, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func delete<T: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.DELETE, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func delete<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.DELETE, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func delete<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.DELETE, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func delete(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<JSONWrapper> {
        return self.request(.DELETE, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .URL, contentType: .JSON)
    }
    //
    public func delete<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func delete<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func delete<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func delete<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func delete<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func delete<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }
    
    public func delete(urlString: String, parameters: [String: AnyObject]? = nil) -> Observable<JSONWrapper> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil)
    }
    
    //put
    public func put<T: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.PUT, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.PUT, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.PUT, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.PUT, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.PUT, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.PUT, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType) -> Observable<JSONWrapper> {
        return self.request(.PUT, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType)
    }
    ///
    public func put<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func put(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType) -> Observable<JSONWrapper> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType)
    }
    ///
    public func put<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func put<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func put<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func put<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func put<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func put<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func put(urlString: String, parameters: [String: AnyObject]? = nil) -> Observable<JSONWrapper> {
        return self.put(urlString, parameters: parameters, contentType: .JSON)
    }

    
    //post
    public func post<T: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.POST, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.POST, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.POST, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.POST, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.POST, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.POST, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post(urlString: String, parameters: [String: AnyObject]?, additionalHeader: [String: String]?, contentType: ContentType) -> Observable<JSONWrapper> {
        return self.request(.POST, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: .JSON, contentType: contentType)
    }
    //
    public func post<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }
    
    public func post(urlString: String, parameters: [String: AnyObject]? = nil, contentType: ContentType) -> Observable<JSONWrapper> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType)
    }
    //
    public func post<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func post<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func post<T: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func post<T: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func post<T: NKArrayType where T.Element: NKMappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func post<T: NKArrayType where T.Element: Mappable>(urlString: String, parameters: [String: AnyObject]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }
    
    public func post(urlString: String, parameters: [String: AnyObject]? = nil) -> Observable<JSONWrapper> {
        return self.post(urlString, parameters: parameters, contentType: .JSON)
    }
    
    //request with url
    public func request<T: Mappable>(
        method: Alamofire.Method,
        _ URLString: String,
          parameters: [String: AnyObject]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType,
          mappingPath: String?) -> Observable<T?> {
        return self.request(method,
                            withFullPath: self.host ++ URLString,
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType,
                            mappingPath: mappingPath)
    }
    
    public func request<T: NKMappable>(
        method: Alamofire.Method,
        _ URLString: String,
          parameters: [String: AnyObject]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType,
          mappingPath: String?) -> Observable<T?> {
        return self.request(method,
                            withFullPath: self.host ++ URLString,
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType,
                            mappingPath: mappingPath)
    }
    
    public func request<T: Mappable>(
        method: Alamofire.Method,
        _ URLString: String,
          parameters: [String: AnyObject]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType,
          mappingPath: String?) -> Observable<T> {
        return self.request(method,
                            withFullPath: self.host ++ URLString,
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType,
                            mappingPath: mappingPath)
    }
    
    public func request<T: NKMappable>(
        method: Alamofire.Method,
        _ URLString: String,
          parameters: [String: AnyObject]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType,
          mappingPath: String?) -> Observable<T> {
        return self.request(method,
                            withFullPath: self.host ++ URLString,
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType,
                            mappingPath: mappingPath)
    }
    
    public func request(
        method: Alamofire.Method,
        _ URLString: String,
          parameters: [String: AnyObject]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType) -> Observable<JSONWrapper> {
        return self.request(method,
                            withFullPath: self.host ++ URLString,
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType)
    }
    
    public func request<T: NKArrayType where T.Element: Mappable>(
        method: Alamofire.Method,
        _ URLString: String,
          parameters: [String: AnyObject]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType,
          mappingPath: String?) -> Observable<T> {
        return self.request(method,
                            withFullPath: self.host ++ URLString,
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType,
                            mappingPath: mappingPath)
    }
    
    public func request<T: NKArrayType where T.Element: NKMappable>(
        method: Alamofire.Method,
        _ URLString: String,
          parameters: [String: AnyObject]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType,
          mappingPath: String?) -> Observable<T> {
        return self.request(method,
                            withFullPath: self.host ++ URLString,
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType,
                            mappingPath: mappingPath)
    }
    
    //request with fullpath
    public func request<T: Mappable>(
        method: Alamofire.Method,
        withFullPath fullPath: String,
                     parameters: [String: AnyObject]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType,
                     mappingPath: String?) -> Observable<T?> {
        return self._request(method,
            withFullPath: fullPath,
            parameters: parameters,
            additionalHeaders: additionalHeaders,
            encoding: encoding,
            contentType: contentType).nk_autoMappingObject(mappingPath)
    }
    
    public func request<T: NKMappable>(
        method: Alamofire.Method,
        withFullPath fullPath: String,
                     parameters: [String: AnyObject]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType,
                     mappingPath: String?) -> Observable<T?> {
        return self._request(method,
            withFullPath: fullPath,
            parameters: parameters,
            additionalHeaders: additionalHeaders,
            encoding: encoding,
            contentType: contentType).nk_autoMappingObject(mappingPath)
    }
    
    public func request<T: Mappable>(
        method: Alamofire.Method,
        withFullPath fullPath: String,
                     parameters: [String: AnyObject]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType,
                     mappingPath: String?) -> Observable<T> {
        return self._request(method,
            withFullPath: fullPath,
            parameters: parameters,
            additionalHeaders: additionalHeaders,
            encoding: encoding,
            contentType: contentType).nk_autoMappingObject(mappingPath)
    }
    
    public func request<T: NKMappable>(
        method: Alamofire.Method,
        withFullPath fullPath: String,
                     parameters: [String: AnyObject]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType,
                     mappingPath: String?) -> Observable<T> {
        return self._request(method,
            withFullPath: fullPath,
            parameters: parameters,
            additionalHeaders: additionalHeaders,
            encoding: encoding,
            contentType: contentType).nk_autoMappingObject(mappingPath)
        
    }
    
    public func request<T: NKArrayType where T.Element: Mappable>(
        method: Alamofire.Method,
        withFullPath fullPath: String,
                     parameters: [String: AnyObject]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType,
                     mappingPath: String?) -> Observable<T> {
        let result: Observable<[T.Element]> = self._request(method,
                                                            withFullPath: fullPath,
                                                            parameters: parameters,
                                                            additionalHeaders: additionalHeaders,
                                                            encoding: encoding,
                                                            contentType: contentType).nk_autoMappingArray(mappingPath)
        return result.map {$0 as! T}
    }
    
    public func request<T: NKArrayType where T.Element: NKMappable>(
        method: Alamofire.Method,
        withFullPath fullPath: String,
                     parameters: [String: AnyObject]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType,
                     mappingPath: String?) -> Observable<T> {
        let result: Observable<[T.Element]> = self._request(method,
            withFullPath: fullPath,
            parameters: parameters,
            additionalHeaders: additionalHeaders,
            encoding: encoding,
            contentType: contentType).nk_autoMappingArray(mappingPath)
        return result.map {$0 as! T}
    }

    public func request(
        method: Alamofire.Method,
        withFullPath fullPath: String,
                     parameters: [String: AnyObject]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType) -> Observable<JSONWrapper> {
        return self._request(method,
            withFullPath: fullPath,
            parameters: parameters,
            additionalHeaders: additionalHeaders,
            encoding: encoding,
            contentType: contentType)
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
    
    private func checkAuthorization(error: ErrorType) {
        if let error = error as? NKNetworkErrorType {
            
            if error.errorCode == NKNetworkErrorType.kUnauthorized {
                NSNotificationCenter.defaultCenter().postNotificationName(NKApiClient.kUnauthorizedNotificationName, object: nil)
            }
        }
    }
    
    private func _request(
        method: Alamofire.Method,
        withFullPath fullPath: String,
                     parameters: [String: AnyObject]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType) -> Observable<JSONWrapper> {
        return Observable.create {[unowned self] observer -> Disposable in
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
                    observer.onNext(jsonWrapper)
                    observer.onCompleted()
                case .Failure(let error):
                    switch error.code {
                    case -1009:
                        observer.onError(NKNetworkErrorType.NoNetwork)
                    case NSURLErrorTimedOut:
                        observer.onError(NKNetworkErrorType.Timeout)
                    default:
                        if let error = self?.bussinessErrorFromResponse(response) {
                            observer.onError(error)
                        } else {
                            observer.onError(NKNetworkErrorType.Unspecified(error: response.result.error))
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
                            observer.onError(NKNetworkErrorType.Unspecified(error: error as NSError))
                        }
                })
            }
            
            return AnonymousDisposable {}
        }.doOnError({ (error) in
            self.checkAuthorization(error)
        })
    }
}