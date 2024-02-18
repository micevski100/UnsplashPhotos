//
//  APIBase.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 7.10.23.
//

import Foundation
import RxRetroSwift
import RxSwift
import RxCocoa


extension Encodable {
    var dictionaryValue: [String: Any?]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else { return nil}
        
        return dictionary
    }
}

class APIBase: NSObject {
    
    override init() {
        RequestModel.defaults.baseUrl = Constants.BASE_URL
    }
    
    lazy var caller: RequestCaller = {
        let config = URLSessionConfiguration.default
        if #available(iOS 11.0, *) {
            config.waitsForConnectivity = true
        }
        return RequestCaller(config: config)
    }()
    
    func authGet<T: Decodable>(path: String) -> Observable<Result<T, ErrorModel>> {
        return callWithRefreshingAuth { () in self.buildRequest(path, .get) }
    }
    
    func authPost<T: Decodable>(path: String, payload: [String: Any?]?) -> Observable<Result<T, ErrorModel>> {
        return callWithRefreshingAuth { () in self.buildRequest(path, .post, payload) }
    }
    
    func authPut<T: Decodable>(path: String, payload: [String: Any?]?) -> Observable<Result<T, ErrorModel>> {
        return callWithRefreshingAuth { () in self.buildRequest(path, .put, payload) }
    }
    
    func authDelete<T: Decodable>(path: String) -> Observable<Result<T, ErrorModel>> {
        return callWithRefreshingAuth { () in self.buildRequest(path, .delete) }
    }
    
    func authGet(path: String) -> Observable<Result<RawResponse, ErrorModel>> {
        return callWithRefreshingAuth { () in self.buildRequest(path, .get) }
    }
    
    func authPost(path: String, payload: [String: Any?]?) -> Observable<Result<RawResponse, ErrorModel>> {
        return callWithRefreshingAuth { () in self.buildRequest(path, .post, payload) }
    }
    
    func authPut(path: String, payload: [String: Any?]?) -> Observable<Result<RawResponse, ErrorModel>> {
        return callWithRefreshingAuth { () in self.buildRequest(path, .put, payload) }
    }
    
    func authDelete(path: String) -> Observable<Result<RawResponse, ErrorModel>> {
        return callWithRefreshingAuth { () in self.buildRequest(path, .delete) }
    }
    
    
    private func callWithRefreshingAuth(requestFactory: @escaping () -> URLRequest?) -> Observable<Result<RawResponse, ErrorModel>> {
        let request = requestFactory()
        let obs$: Observable<Result<RawResponse, ErrorModel>> = caller.call(request!)
        
        return obs$.flatMap { (firstResult: Result<RawResponse, ErrorModel>) -> Observable<Result<RawResponse, ErrorModel>> in
            if firstResult.error?.errorCode != 401 {
                return Observable.just(firstResult)
            }
            
            return Observable.just(Result.failure(ErrorModel()))
        }
    }
    
    private func callWithRefreshingAuth<T: Decodable>(requestFactory: @escaping () -> URLRequest?) -> Observable<Result<T, ErrorModel>> {
        let request = requestFactory()
        let obs$ : Observable<Result<T, ErrorModel>> = caller.call(request)
        
        return obs$.flatMap { (firstResult: Result<T, ErrorModel>) -> Observable<Result<T, ErrorModel>> in
            if (firstResult.error?.errorCode != 401) {
                return Observable.just(firstResult)
            }

            return Observable.just(Result.failure(ErrorModel()))
        }
    }
    
    fileprivate func buildRequest(_ path: String, _ httpMethod: RequestModel.HttpMethod, _ payload: [String: Any?]?) -> URLRequest? {
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else { return nil }
        
        return RequestModel(
            httpMethod: httpMethod,
            path: path,
            payload: payload,
            headers: buildAuthHeaders(accessToken).merging(buildJsonHeaders()) { (_, new) in new }
        ).asURLRequest()
    }
    
    fileprivate func buildRequest(_ path: String, _ httpMethod: RequestModel.HttpMethod) -> URLRequest? {
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else { return nil }
        return RequestModel(
            httpMethod: httpMethod,
            path: path,
            headers: buildAuthHeaders(accessToken)
        
        ).asURLRequest()
    }
    
    func buildJsonHeaders() -> [String: String] {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    fileprivate func buildAuthHeaders(_ accessToken: String) -> [String: String] {
        return [
            "Authorization": "Bearer " + accessToken
        ]
    }
    
    func addQuery(path: String, parameter: String) -> String {
        if path == "" {
            return "?\(parameter)"
        } else {
            let r = "\(path)&\(parameter)"
            return r
        }
    }
}



