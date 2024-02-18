//
//  HomeViewModel.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import RxRetroSwift
import RxSwift
import RxCocoa


class HomeViewModel: NSObject {
    
    private var data = BehaviorRelay(value: [HomeSectionModel]())
    private let disposeBag = DisposeBag()
    
    public func initialize() -> Observable<Array<HomeSectionModel>> {
        return data.asObservable()
    }
    
    public func updatePhoto(_ photo: PhotoResponse) {
        var sections = data.value
        for (sectionIdx, section) in sections.enumerated() {
            for (rowIdx, row) in section.items.enumerated() {
                guard row.item.id == photo.id else { continue }
                
                var updatedSections = section.items
                updatedSections[rowIdx] = .PhotoCell(collectionResponse: row.collection, item: photo, withCornerRadius: row.withCornerRadius)
                sections[sectionIdx] = .Section(title: section.title, shape: section.shape, items: updatedSections)
                data.accept(sections)
                return
            }
        }
    }
    
    
    public func map(_ collections: [(CollectionResponse, [PhotoResponse])])  {
        let sections: [HomeSectionModel] = [
            .Section(title: collections[0].0.title,
                     shape: .landscape,
                     items: collections[0].1.map { .PhotoCell(collectionResponse: collections[0].0,
                                                              item: $0,
                                                              withCornerRadius: false) }
            ),
            .Section(title: collections[1].0.title,
                     shape: .potraitMedium,
                     items: collections[1].1.map { .PhotoCell(collectionResponse: collections[1].0,
                                                              item: $0,
                                                              withCornerRadius: false) }
            ),
            .Section(title: collections[2].0.title,
                     shape: .singleCardSmall,
                     items: [.SingleCardCell(collectionResponse: collections[2].0, item: collections[2].1[0])]
            ),
            .Section(title: collections[3].0.title,
                     shape: .potraitMedium,
                     items: collections[3].1.map { .PhotoCell(collectionResponse: collections[3].0,
                                                              item: $0,
                                                              withCornerRadius: true) }
            ),
            .Section(title: collections[4].0.title,
                     shape: .potraitLarge,
                     items: collections[4].1.map { .PhotoCell(collectionResponse: collections[4].0,
                                                              item: $0,
                                                              withCornerRadius: true) }
            ),
            .Section(title: collections[5].0.title,
                     shape: .singleCardSmall,
                     items: [.SingleCardCell(collectionResponse: collections[5].0, item: collections[5].1[0])]
            ),
            .Section(title: collections[6].0.title,
                     shape: .potraitMedium,
                     items: collections[6].1.map { .PhotoCell(collectionResponse: collections[6].0,
                                                              item: $0,
                                                              withCornerRadius: true) }
            ),
            .Section(title: collections[7].0.title,
                     shape: .singleCardLarge,
                     items: [.SingleCardCell(collectionResponse: collections[7].0, item: collections[7].1[0])]
            ),
            .Section(title: collections[8].0.title,
                     shape: .potraitLarge,
                     items: collections[8].1.map { .PhotoCell(collectionResponse: collections[8].0,
                                                              item: $0,
                                                              withCornerRadius: true) }
            )
        ]
        
        data.accept(sections)
    }
}
