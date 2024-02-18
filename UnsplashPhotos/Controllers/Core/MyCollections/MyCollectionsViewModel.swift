//
//  MyCollectionsViewModel.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import RxRetroSwift
import RxSwift
import RxCocoa


class MyCollectionsViewModel: NSObject {
    private var data = BehaviorRelay(value: [MyCollectionsSectionModel]())
    private let disposeBag = DisposeBag()
    
    public func initialize() -> Observable<Array<MyCollectionsSectionModel>> {
        return data.asObservable()
    }
    
    public func map(_ collections: [CollectionResponse]) {
        data.accept([.Section(title: "", items: collections.map { .ItemCell(item: $0) })])
    }
    
    public func remove(_ collectionId: String) {
        var sections = data.value

        for (sectionIdx, section) in sections.enumerated() {
            let updatedItems = section.items.filter { $0.item.id != collectionId }
            sections[sectionIdx] = .Section(title: section.title, items: updatedItems)
        }

        data.accept(sections)
    }
    
    public func updateCollection(_ updatedCollection: CollectionResponse) {
        var sections = data.value
        
        for (sectionIdx, section) in sections.enumerated() {
            if let idx = section.items.firstIndex(where: { it in it.item.id == updatedCollection.id }) {
                var updatedSectionItems = section.items
                updatedSectionItems[idx] = .ItemCell(item: updatedCollection)
                sections[sectionIdx] = .Section(title: section.title, items: updatedSectionItems)
            }
        }

        data.accept(sections)
    }
}
