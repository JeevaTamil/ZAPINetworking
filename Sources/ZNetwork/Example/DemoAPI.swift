//
//  File.swift
//  
//
//  Created by Azhagusundaram Tamil on 30/06/22.
//

import Foundation

enum PostEndPoint {
    case getAllPost
    case getPost(_: String)
}

extension PostEndPoint: RequestProtocol {
    var path: String {
        switch self {
            
        case .getAllPost:
            return "/posts"
        case .getPost(let id):
            return "/posts/\(id)"
        }
    }
    
    var method: RequestMethod {
        .get
    }
    
    var headers: ReaquestHeaders? {
        return nil
    }
    
    var parameters: RequestParameters? {
        nil
    }
    
    var requestType: RequestType {
        .data
    }
    
    var responseType: ResponseType {
        .json
    }
    
    var progressHandler: ProgressHandler? {
        get {
            nil
        }
        set(newValue) {
            
        }
    }
}

class ViewModel {
    
    
    func getAllPosts() {
        let getAllPost = PostEndPoint.getAllPost
        let urlRequest = getAllPost.urlRequest(with: APIEnvironment.live)
        
    }
    
}


enum APIEnvironment {
    case dev, live
}

extension APIEnvironment: EnvironmentProtocol {
    var headers: ReaquestHeaders? {
        return [
            "Content-Type" : "application/json"
        ]
    }
    
    var baseURL: String {
        switch self {
        case .live:
            return "https://jsonplaceholder.typicode.com"
        case .dev:
            return "https://jsonplaceholder.typicode.com"
        }
    }
    
    
}
