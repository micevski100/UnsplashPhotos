//
//  LikedViewModel.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import RxRetroSwift
import RxSwift
import RxCocoa


class LikedViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    public func initialize() -> Observable<Array<LikedSectionModel>> {
        return Observable.just([])
    }
    
    public func map(_ photos: [PhotoResponse]) -> Array<LikedSectionModel> {
        return [.Section(title: "", items: photos.map { .ItemCell(item: $0) })]
    }
}

