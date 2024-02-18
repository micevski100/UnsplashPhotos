//
//  RequestCallerExtensions.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 9.10.23.
//

import Foundation
import RxRetroSwift
import RxSwift
import RxCocoa

extension RequestCaller {
    public func call<ItemModel:Decodable, DecodableErrorModel:DecodableError>(_ request: URLRequest?)
      -> Observable<Result<ItemModel, DecodableErrorModel>> {
        if (request == nil) {
            return Observable.never()
        }
        return self.call(request!)
    }
}

