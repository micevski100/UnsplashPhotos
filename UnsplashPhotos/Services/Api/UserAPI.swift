//
//  UserAPI.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation
import RxRetroSwift
import RxSwift
import RxCocoa

class UserAPI: APIBase {
    static let shared = UserAPI()
    
    func getProfile() -> Observable<Result<UserResponse, ErrorModel>> {
        return authGet(path: "me")
    }
    
    func listMyCollections() -> Observable<Result<[CollectionResponse], ErrorModel>> {
        let username = UserDefaults.standard.string(forKey: "username")!
        return authGet(path: "/users/\(username)/collections")
    }
    
    func getLikedPhotos() -> Observable<Result<[PhotoResponse], ErrorModel>> {
        let username = UserDefaults.standard.string(forKey: "username")!
        return authGet(path: "/users/\(username)/likes?per_page=30")
    }
}
