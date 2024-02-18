//
//  SearchAPI.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import Foundation
import RxRetroSwift
import RxSwift
import RxCocoa

class SearchAPI: APIBase {
    static let shared = SearchAPI()
    
    func searchPhotos(search: String, page: Int = 1, per_page: Int = 10) -> Observable<Result<SearchPhotosResponse, ErrorModel>> {
        let path = "search/photos"
        var query = ""
        
        query = self.addQuery(path: query, parameter: "query=\(search)")
        query = self.addQuery(path: query, parameter: "page=\(page)")
        query = self.addQuery(path: query, parameter: "per_page=\(per_page)")
        
        return authGet(path: path + query)
    }
    
    func searchCollections(search: String, page: Int = 1, per_page: Int = 10) -> Observable<Result<SearchCollectionsResponse, ErrorModel>> {
        let path = "search/collections"
        var query = ""
        
        query = self.addQuery(path: query, parameter: "query=\(search)")
        query = self.addQuery(path: query, parameter: "page=\(page)")
        query = self.addQuery(path: query, parameter: "per_page=\(per_page)")
        
        return authGet(path: path + query)
    }
    
    func searchUsers(search: String, page: Int = 1, per_page: Int = 10) -> Observable<Result<SearchUsersResponse, ErrorModel>> {
        let path = "search/users"
        var query = ""
        
        query = self.addQuery(path: query, parameter: "query=\(search)")
        query = self.addQuery(path: query, parameter: "page=\(page)")
        query = self.addQuery(path: query, parameter: "per_page=\(per_page)")
        
        return authGet(path: path + query)
    }
}
