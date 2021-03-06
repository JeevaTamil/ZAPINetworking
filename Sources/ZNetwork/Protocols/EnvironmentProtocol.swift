//
//  File.swift
//  
//
//  Created by Azhagusundaram Tamil on 30/06/22.
//

import Foundation

/// Protocol to which environments must conform.
public protocol EnvironmentProtocol {
    /// The default HTTP request headers for the environment.
    var headers: ReaquestHeaders? { get }

    /// The base URL of the environment.
    var baseURL: String { get }
}
