//
//  UserResponse.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation

struct UserResponse: Codable {
    var id: String
    var updated_at: String
    var username: String
    var first_name: String?
    var last_name: String?
    var bio: String?
    var location: String?
    var total_likes: Int
    var total_photos: Int
    var total_collections: Int
    var followed_by_user: Bool?
    var downloads: Int?
    var email: String?
    var profile_image: UserProfileImageResponse
    var followers_count: Int?
    var following_count: Int?
    var instagram_username: String?
    var twitter_username: String?
}

struct UserProfileImageResponse: Codable {
    var small: String?
}
