//
//  CollectionResponse.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation

struct CollectionResponse: Codable {
    var id: String
    var title: String
    var description: String?
    var total_photos: Int
    var user: UserResponse
    var cover_photo: CoverPhotoResponse?
}

struct CoverPhotoResponse: Codable {
    var id: String
    var urls: PhotoUrlsResponse
}
