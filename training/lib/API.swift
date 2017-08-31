//
//  API.swift
//  training
//
//  Created by shota.nagao on 2017/08/31.
//  Copyright © 2017年 training. All rights reserved.
//
import APIKit
import Himotoki

protocol WRequest: Request {
    
}

extension WRequest {
    
    var baseURL: URL {
        return URL(string: "https://training-a0bb4.firebaseapp.com")!
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
    
}

// MARK : - Himotoki

extension WRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}

struct RepositoryRequest: WRequest {
    
    var path: String {
        return "/messages"
    }
    
    typealias Response = [Repository]
    
    var method: HTTPMethod {
        return .get
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> RepositoryRequest.Response {
        return try decodeArray(object)
    }
    
}
