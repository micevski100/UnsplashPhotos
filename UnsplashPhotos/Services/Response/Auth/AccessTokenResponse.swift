//
//  AccessTokenResponse.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 11.10.23.
//

import Foundation

struct AccessTokenResponse: Codable {
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: Double
}
