//
//  SearchCollectionsResponse.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation

struct SearchCollectionsResponse: Codable {
    var total: Int
    var results: [CollectionResponse]
}
