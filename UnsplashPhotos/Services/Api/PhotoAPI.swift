//
//  PhotoAPI.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation
import RxRetroSwift
import RxSwift
import RxCocoa

class PhotoAPI: APIBase {
    static let shared = PhotoAPI()
    
    func getPhotos(page: Int = 1, per_page: Int = 10) -> Observable<Result<[PhotoResponse], ErrorModel>> {
        let path = "photos"
        var query = ""
        
        query = self.addQuery(path: query, parameter: "page=\(page)")
        query = self.addQuery(path: query, parameter: "per_page=\(per_page)")
        
        return authGet(path: path + query)
    }
    
    func getPhoto(id: String) -> Observable<Result<PhotoResponse, ErrorModel>> {
        return authGet(path: "photos/\(id)]")
    }
    
    func getRandomPhoto(count: Int = 1) -> Observable<Result<[PhotoResponse], ErrorModel>> {
        let path = "photos/random"
        var query = ""
        
        query = self.addQuery(path: query, parameter: "count=\(count)")
        
        return authGet(path: path + query)
    }
    
    func likePhoto(id: String) -> Observable<Result<LikedPhotoResponse, ErrorModel>> {
        return authPost(path: "photos/\(id)/like", payload: nil)
    }
    
    func dislikePhoto(id: String) -> Observable<Result<LikedPhotoResponse, ErrorModel>> {
        return authDelete(path: "photos/\(id)/like")
    }
}
