//
//  CollectionDetailsViewModel.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 31.10.23.
//

import UIKit
import RxRetroSwift
import RxSwift
import RxCocoa

class CollectionDetailsViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    public func initialize() -> Observable<Array<CollectionDetailsSectionModel>> {
        return Observable.just([])
    }
    
    public func map(_ photos: [PhotoResponse]) -> Array<CollectionDetailsSectionModel> {
        return [CollectionDetailsSectionModel.section(title: "", items: photos.map { .itemCell(item: $0) })]
    }
}
