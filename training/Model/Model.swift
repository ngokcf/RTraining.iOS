//
//  Model.swift
//  training
//
//  Created by shota.nagao on 2017/08/31.
//  Copyright © 2017年 training. All rights reserved.
//

import Himotoki

struct Repository: Decodable {
    
    public let id: Int
    public let subject: String
    public let body: String
    
    static func decode(_ e: Extractor) throws -> Repository {
        return try Repository(
            id: e <| "id",
            subject: e <| "subject",
            body: e <| "body"
        )
    }
    
}
