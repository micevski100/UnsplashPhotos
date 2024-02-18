//
//  CollectionsAPI.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation
import RxRetroSwift
import RxSwift
import RxCocoa

class CollectionsAPI: APIBase {
    static let shared = CollectionsAPI()
    
    func listCollections(page: Int = 1, per_page: Int = 10) -> Observable<Result<[CollectionResponse], ErrorModel>> {
        let path = "collections"
        var query = ""
        
        query = self.addQuery(path: query, parameter: "page=\(page)")
        query = self.addQuery(path: query, parameter: "per_page=\(per_page)")
        
        return authGet(path: path + query)
    }
    
    func getCollection(id: String) -> Observable<Result<CollectionResponse, ErrorModel>> {
        return authGet(path: "collections/\(id)")
    }
    
    func getCollectionPhotos(id: String) -> Observable<Result<[PhotoResponse], ErrorModel>> {
        return authGet(path: "collections/\(id)/photos")
    }
    
    func deleteCollection(id: String) -> Observable<Result<RawResponse, ErrorModel>> {
        return authDelete(path: "collections/\(id)")
    }
    
    func createCollection(_ title: String, _ description: String?) -> Observable<Result<RawResponse, ErrorModel>> {
        let payload: [String:Any?] = [
            "title":title,
            "description":description,
            "private":true
        ]
        return authPost(path: "collections", payload: payload)
    }
    
    func updateCollection(_ id: String, _ title: String?, _ description: String?) -> Observable<Result<CollectionResponse, ErrorModel>> {
        let payload: [String: Any?] = [
            "title":title,
            "description":description,
            "private":true
        ]
        
        return authPut(path: "collections/\(id)", payload: payload)
    }
    
    func addPhotoToCollection(collectionId: String, photoId: String) -> Observable<Result<RawResponse, ErrorModel>> {
        let payload: [String: Any?] = [
            "photo_id": photoId
        ]
        
        return authPost(path: "collections/\(collectionId)/add", payload: payload)
    }
}
