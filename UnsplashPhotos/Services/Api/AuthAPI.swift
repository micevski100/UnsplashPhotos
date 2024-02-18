//
//  AuthAPI.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 9.10.23.
//

import Foundation
import RxRetroSwift
import RxSwift
import RxCocoa
import Alamofire

class AuthAPI: APIBase {
    static let shared = AuthAPI()
    
    func login(code: String) -> Observable<Result<AccessTokenResponse, Error>> {
        let url = "https://unsplash.com/oauth/token"
        let params = [
            "client_id": Constants.AUTH_CLIENT_ID,
            "client_secret": Constants.AUTH_CLIENT_SECRET,
            "redirect_uri": Constants.REDIRECT_URI,
            "code": code,
            "grant_type": Constants.GRANT_TYPE,
        ]

        return Observable.create { observer in
            AF.request(url, method: .post, parameters: params)
                .response { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let json = try JSONDecoder().decode(AccessTokenResponse.self, from: data!)
                            observer.onNext(.successful(json))
                        } catch {
                            observer.onNext(.failure(error))
                        }
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onNext(.failure(error))
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }

    
//    func login(code: String) -> Observable<Result<AccessTokenResponse, ErrorModel>> {
//        
//        let request = RequestModel(
//            httpMethod: .post,
//            path: "oauth/token",
//            payload: [
//                "client_id" : Constants.AUTH_CLIENT_ID,
//                "client_secret": Constants.AUTH_CLIENT_SECRET,
//                "redirect_uri": Constants.REDIRECT_URI,
//                "code": code,
//                "grant_type": Constants.GRANT_TYPE,
//            ],
//            headers: buildJsonHeaders()
//        ).asURLRequest()
//        
//        return caller.call(request)
//    }
}
