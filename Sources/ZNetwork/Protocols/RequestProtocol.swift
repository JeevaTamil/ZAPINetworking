//
//  File.swift
//  
//
//  Created by Azhagusundaram Tamil on 30/06/22.
//

import Foundation

/// Type alias used for HTTP request headers.
public typealias ReaquestHeaders = [String: String]
/// Type alias used for HTTP request parameters. Used for query parameters for GET requests and in the HTTP body for POST, PUT and PATCH requests.
public typealias RequestParameters = [String : Any?]
/// Type alias used for the HTTP request download/upload progress.
public typealias ProgressHandler = (Float) -> Void

/// Protocol to which the HTTP requests must conform.
public protocol RequestProtocol {

    /// The path that will be appended to API's base URL.
    var path: String { get }

    /// The HTTP method.
    var method: RequestMethod { get }

    /// The HTTP headers/
    var headers: ReaquestHeaders? { get }

    /// The request parameters used for query parameters for GET requests and in the HTTP body for POST, PUT and PATCH requests.
    var parameters: RequestParameters? { get }

    /// The request type.
    var requestType: RequestType { get }

    /// The expected response type.
    var responseType: ResponseType { get }

    /// Upload/download progress handler.
    var progressHandler: ProgressHandler? { get set }
}
