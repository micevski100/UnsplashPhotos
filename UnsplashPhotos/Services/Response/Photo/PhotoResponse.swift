//
//  PhotoResponse.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation

struct PhotoResponse: Codable {
    var id: String
    var likes: Int
    var liked_by_user: Bool
    var description: String?
    var user: PhotoOwnerResponse
    var urls: PhotoUrlsResponse
}

struct PhotoOwnerResponse: Codable {
    var id: String
    var username: String
    var name: String
    var bio: String?
}

struct PhotoUrlsResponse: Codable {
    var thumb: String
    var full: String
    var raw: String
    var regular: String
}
