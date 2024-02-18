//
//  ErrorModel.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 7.10.23.
//

import Foundation
import RxRetroSwift

struct ErrorModel: HasErrorInfo, Codable, Error {
    
    var subcode: String?
    var errors: Array<String>?
    var error_type: String?
    var app_message: String?
    var message: String?
    
    // HasErrorInfo members
    var errorCode: Int?
    var errorDetail: String?
    
    enum CodingKeys: String, CodingKey {
        case subcode
        case errors
        case error_type
        case errorCode
        case errorDetail
        case app_message
        case message
    }
    
    init() { }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        subcode = try values.decodeIfPresent(String.self, forKey: .subcode)
        
        if values.contains(.errors) {
            errors = try values.decode(Array<String>.self, forKey: .errors)
        }
        
        error_type = try values.decodeIfPresent(String.self, forKey: .error_type)
        errorCode = try values.decodeIfPresent(Int.self, forKey: .errorCode)
        errorDetail = try values.decodeIfPresent(String.self, forKey: .errorDetail)
        app_message = try values.decodeIfPresent(String.self, forKey: .app_message)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(subcode, forKey: .subcode)
        try container.encode(errors, forKey: .errors)
        try container.encodeIfPresent(error_type, forKey: .error_type)
        try container.encodeIfPresent(app_message, forKey: .app_message)
        try container.encodeIfPresent(errorCode, forKey: .errorCode)
        try container.encodeIfPresent(errorDetail, forKey: .errorDetail)
        try container.encodeIfPresent(message, forKey: .message)
    }
}

struct ErrorModelItem: Codable {
    var message: String
    var error_type: String
}
