//
//  AddPhotoPopUpViewModel.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit
import RxSwift
import RxCocoa

class AddPhotoPopUpViewModel {
    
    private let disposeBag = DisposeBag()
    
    public func initialize() -> Observable<Array<AddPhotoPopUpSectionModel>> {
        let sections: [AddPhotoPopUpSectionModel] = []
        return Observable.just(sections)
    }
    
    func fetch() -> Observable<Array<AddPhotoPopUpSectionModel>> {
        return UserAPI.shared.listMyCollections().map { result in
            let items = result.value?.map { AddPhotoPopUpItem.ItemCell(item: $0) }
            return [AddPhotoPopUpSectionModel.Section(items: items ?? [])]
        }
    }
}
