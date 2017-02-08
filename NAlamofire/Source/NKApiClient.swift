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
import NLogProtocol
import ObjectMapper

open class NKApiClient: AnyObject {
    open static let kUnauthorizedNotificationName = "UnauthorizedNotificationName"

    public enum ContentType: String {
        case JSON = "application/json"
        case Multipart = "multipart/form-data"
        case FormData
    }

    //public properties
    open let requestTimeout: TimeInterval?
    open let host: String
    open let responseQueue: DispatchQueue

    //private properties
    fileprivate var defaultHeaders = [String:String]()
    fileprivate let acceptableStatusCodes: [Int]
    fileprivate var alamofireManager: Alamofire.SessionManager?

    public init(host: String,
                requestTimeout: TimeInterval? = nil,
                acceptableStatusCodes: [Int] = Array(200..<300),
                responseQueue: DispatchQueue = DispatchQueue.main) {
        self.host = host
        self.requestTimeout = requestTimeout
        self.responseQueue = responseQueue
        self.acceptableStatusCodes = acceptableStatusCodes
        self.alamofireManager = Alamofire.SessionManager(configuration: self.createAlamofireConfiguration(requestTimeout: requestTimeout))
    }

    //public override functions
    open func bussinessErrorFromResponse(_ response: NKAlamofireResponseData) -> NKNetworkErrorType? {
        return NKNetworkErrorType.business(code: response.response?.statusCode ?? 0, debug: "", message: "")
    }

    open func extraUserAgent() -> String? {
        return nil
    }
}

public typealias NKAlamofireResponseData = DataResponse<Data>
//public functions
public extension NKApiClient {
    public func setDefaultHeader(key: String, value: String) {
        self.defaultHeaders[key] = value
    }

    public func removeDefaultHeader(_ key: String) {
        self.defaultHeaders[key] = nil
    }

    //get
    public func get<T: NKMappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.get, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func get<T: Mappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.get, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func get<T: NKMappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.get, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func get<T: Mappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.get, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func get(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?) -> Observable<JSONWrapper> {
        return self.request(.get, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON)
    }

    public func get<T: NKArrayType>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.request(.get, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func get<T: NKArrayType>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.request(.get, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }
    //
    public func get<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func get<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func get<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func get<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func get(_ urlString: String, parameters: [String: Any]? = nil) -> Observable<JSONWrapper> {
        return self.get(urlString, parameters: parameters, additionalHeader: nil)
    }

    public func get<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func get<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.get(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    //delete
    public func delete<T: NKMappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.delete, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func delete<T: Mappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.delete, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func delete<T: NKMappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.delete, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func delete<T: Mappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.delete, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func delete<T: NKArrayType>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.request(.delete, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func delete<T: NKArrayType>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.request(.delete, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON, mappingPath: mappingPath)
    }

    public func delete(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, mappingPath: String? = nil) -> Observable<JSONWrapper> {
        return self.request(.delete, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: URLEncoding.default, contentType: .JSON)
    }
    //
    public func delete<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func delete<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func delete<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func delete<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func delete<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func delete<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil, mappingPath: mappingPath)
    }

    public func delete(_ urlString: String, parameters: [String: Any]? = nil) -> Observable<JSONWrapper> {
        return self.delete(urlString, parameters: parameters, additionalHeader: nil)
    }

    //put
    public func put<T: Mappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.put, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: NKMappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.put, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: Mappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.put, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: NKMappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.put, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: NKArrayType>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.request(.put, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: NKArrayType>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.request(.put, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func put(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType) -> Observable<JSONWrapper> {
        return self.request(.put, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType)
    }
    ///
    public func put<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func put<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func put(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType) -> Observable<JSONWrapper> {
        return self.put(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType)
    }
    ///
    public func put<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func put<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func put<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func put<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func put<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func put<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.put(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func put(_ urlString: String, parameters: [String: Any]? = nil) -> Observable<JSONWrapper> {
        return self.put(urlString, parameters: parameters, contentType: .JSON)
    }


    //post
    public func post<T: Mappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.post, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: NKMappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.request(.post, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: Mappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.post, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: NKMappable>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.request(.post, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: NKArrayType>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.request(.post, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: NKArrayType>(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.request(.post, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType, mappingPath: mappingPath)
    }

    public func post(_ urlString: String, parameters: [String: Any]?, additionalHeader: [String: String]?, contentType: ContentType) -> Observable<JSONWrapper> {

        return self.request(.post, urlString, parameters: parameters, additionalHeaders: additionalHeader, encoding: JSONEncoding.default, contentType: contentType)
    }
    //
    public func post<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T?> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func post<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType, mappingPath: mappingPath)
    }

    public func post(_ urlString: String, parameters: [String: Any]? = nil, contentType: ContentType) -> Observable<JSONWrapper> {
        return self.post(urlString, parameters: parameters, additionalHeader: nil, contentType: contentType)
    }
    //
    public func post<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func post<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T?> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func post<T: NKMappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func post<T: Mappable>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func post<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> where T.Element: NKMappable {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func post<T: NKArrayType>(_ urlString: String, parameters: [String: Any]? = nil, mappingPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        return self.post(urlString, parameters: parameters, contentType: .JSON, mappingPath: mappingPath)
    }

    public func post(_ urlString: String, parameters: [String: Any]? = nil) -> Observable<JSONWrapper> {
        return self.post(urlString, parameters: parameters, contentType: .JSON)
    }

    //request with url
    public func request<T: Mappable>(
        _ method: HTTPMethod,
        _ URLString: String,
          parameters: [String: Any]?,
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
        _ method: HTTPMethod,
        _ URLString: String,
          parameters: [String: Any]?,
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
        _ method: HTTPMethod,
        _ URLString: String,
          parameters: [String: Any]?,
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
        _ method: HTTPMethod,
        _ URLString: String,
          parameters: [String: Any]?,
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
        _ method: HTTPMethod,
        _ URLString: String,
          parameters: [String: Any]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType) -> Observable<JSONWrapper> {
        return self.request(method,
                            withFullPath: (self.host ++ URLString) + "/",
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType)
    }

    public func request<T: NKArrayType>(
        _ method: HTTPMethod,
        _ URLString: String,
          parameters: [String: Any]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType,
          mappingPath: String?) -> Observable<T> where T.Element: Mappable {
        return self.request(method,
                            withFullPath: (self.host ++ URLString) + "/",
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType,
                            mappingPath: mappingPath)
    }

    public func request<T: NKArrayType>(
        _ method: HTTPMethod,
        _ URLString: String,
          parameters: [String: Any]?,
          additionalHeaders: [String : String]?,
          encoding: ParameterEncoding,
          contentType: ContentType,
          mappingPath: String?) -> Observable<T> where T.Element: NKMappable {
        return self.request(method,
                            withFullPath: (self.host ++ URLString) + "/",
                            parameters: parameters,
                            additionalHeaders: additionalHeaders,
                            encoding: encoding,
                            contentType: contentType,
                            mappingPath: mappingPath)
    }

    //request with fullpath
    public func request<T: Mappable>(
        _ method: HTTPMethod,
        withFullPath fullPath: String,
                     parameters: [String: Any]?,
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
        _ method: HTTPMethod,
        withFullPath fullPath: String,
                     parameters: [String: Any]?,
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
        _ method: HTTPMethod,
        withFullPath fullPath: String,
                     parameters: [String: Any]?,
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
        _ method: HTTPMethod,
        withFullPath fullPath: String,
                     parameters: [String: Any]?,
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

    public func request<T: NKArrayType>(
        _ method: HTTPMethod,
        withFullPath fullPath: String,
                     parameters: [String: Any]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType,
                     mappingPath: String?) -> Observable<T> where T.Element: Mappable {
        let result: Observable<[T.Element]> = self._request(method,
                                                            withFullPath: fullPath,
                                                            parameters: parameters,
                                                            additionalHeaders: additionalHeaders,
                                                            encoding: encoding,
                                                            contentType: contentType).nk_autoMappingArray(mappingPath)
        return result.map {$0 as! T}
    }

    public func request<T: NKArrayType>(
        _ method: HTTPMethod,
        withFullPath fullPath: String,
                     parameters: [String: Any]?,
                     additionalHeaders: [String : String]?,
                     encoding: ParameterEncoding,
                     contentType: ContentType,
                     mappingPath: String?) -> Observable<T> where T.Element: NKMappable {
        let result: Observable<[T.Element]> = self._request(method,
            withFullPath: fullPath,
            parameters: parameters,
            additionalHeaders: additionalHeaders,
            encoding: encoding,
            contentType: contentType).nk_autoMappingArray(mappingPath)
        return result.map {$0 as! T}
    }

    public func request(
        _ method: HTTPMethod,
        withFullPath fullPath: String,
                     parameters: [String: Any]?,
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
    func createAlamofireConfiguration(requestTimeout: TimeInterval?) -> URLSessionConfiguration {
        // add extra user agent
        let userAgentKey = "User-Agent"
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        if let originUserAgent = defaultHeaders[userAgentKey], let extraUserAgent = self.extraUserAgent() {
                defaultHeaders[userAgentKey] = originUserAgent + "##" + extraUserAgent
        }

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        if let requestTimeout = requestTimeout {
            configuration.timeoutIntervalForRequest = requestTimeout
        }

        return configuration
    }

    func checkAuthorization(_ error: Error) {
        if let error = error as? NKNetworkErrorType {

            if error.errorCode == NKNetworkErrorType.kUnauthorized {
                NotificationCenter.default.post(name: Notification.Name(rawValue: NKApiClient.kUnauthorizedNotificationName), object: nil)
            }
        }
    }

    func _request(
        _ method: HTTPMethod,
        withFullPath fullPath: String,
                     parameters: [String: Any]?,
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

            headers["Content-Type"] = contentType == .JSON ? contentType.rawValue : nil
            let parameterString = String(format: "%@", (parameters == nil) ? "[no params]" : parameters!)

            let requestCode = "\(NSDate().timeIntervalSince1970)"
            NKLog.server("[\(requestCode)] \(method) \(URLString) \(headers) \(parameterString)")


            let completion: (NKAlamofireResponseData) -> Void = {[weak self](response) -> Void in
                let json = JSON(data: response.data ?? Data())
                NKLog.server("[\(requestCode)] \(response.response?.statusCode ?? 0) \(URLString) \(json) \(response.result.error?.localizedDescription ?? "")")

                switch response.result {
                case .success(_):
                    let jsonWrapper = JSONWrapper(json: json, response: response)
                    observer.onNext(jsonWrapper)
                    observer.onCompleted()
                case .failure(let error):
                    if let error = error as? URLError {
                        switch error.errorCode {
                        case -1009:
                            observer.onError(NKNetworkErrorType.noNetwork)
                            return
                        case NSURLErrorTimedOut:
                            observer.onError(NKNetworkErrorType.timeout)
                            return
                        default: break
                        }
                    }

                    if let error = self?.bussinessErrorFromResponse(response) {
                        observer.onError(error)
                    } else {
                        observer.onError(NKNetworkErrorType.unspecified(error: response.result.error))
                    }
                }
            }

            switch contentType {
            case .JSON, .FormData:
                self.alamofireManager?
                    .request(URLString,
                             method: method,
                             parameters: parameters,
                             encoding: encoding,
                             headers: headers)
                    .validate(statusCode: self.acceptableStatusCodes)
                    .responseData(queue: self.responseQueue, completionHandler: completion)

            case .Multipart:
                self.alamofireManager?.upload(multipartFormData: { (multipart) in

                    guard let params = parameters else {
                        return
                    }

                    for (key, value) in params {
                        if let value = value as? URL {
                            multipart.append(value, withName: key)
                            continue
                        }

                        var data: Data? = nil

                        if let value = value as? String {
                            data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        }
                        if (value as AnyObject).isKind(of: NSString.self) {
                            
                        }

                        if let value = value as? Data {
                            data = value
                        }

                        if let data = data {
                            multipart.append(data, withName: key)
                        }
                    }

                    }, to: URLString, method: method, headers: headers, encodingCompletion: { (encodingResult) in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.validate().validate(statusCode: self.acceptableStatusCodes)
                            .responseData(queue: self.responseQueue, completionHandler: completion)
                        case .failure(let error):
                            observer.onError(NKNetworkErrorType.unspecified(error: error))
                        }
                })
            }

            return Disposables.create {}
            }.do(onError: { (error) in
            self.checkAuthorization(error)
        })
    }
}
