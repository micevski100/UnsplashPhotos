//
//  CollectionDetailsSetupCollection.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 31.10.23.
//

import UIKit
import RxDataSources

extension CollectionDetailsController: UICollectionViewDelegate {
    
    func setupCollection() {
        self.contentView.collectionView.register(HomeCollectionPhotoCell.self, forCellWithReuseIdentifier: "HomeCollectionPhotoCell")
        
        self.dataSource = generateDataSource()
        
        self.viewModel.initialize()
            .bind(to: self.contentView.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        self.contentView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.contentView.setRefreshDelegate(self)
    }
    
    func generateDataSource() -> RxCollectionViewSectionedReloadDataSource<CollectionDetailsSectionModel> {
        let datasource = RxCollectionViewSectionedReloadDataSource<CollectionDetailsSectionModel> { (datasource, collection, idxPath, _) in
            var cell: ContentCollectionViewCell! = nil
            switch datasource[idxPath] {
            case .itemCell(item: let item):
                let x: HomeCollectionPhotoCell = collection.dequeueReusableCell(forIndexPath: idxPath)
                x.setup(self.collectionResponse, item, false)
                x.likesStack.isHidden = true
                cell = x
            }
            
            cell.updateConstraintsIfNeeded() // https://stackoverflow.com/a/39540360
            return cell
        }
        return datasource
    }
}

enum CollectionDetailsSectionModel {
    case section(title: String, items: [CollectionDetailsItem])
}

enum CollectionDetailsItem {
    case itemCell(item: PhotoResponse)
}

extension CollectionDetailsSectionModel: SectionModelType {
    typealias Item = CollectionDetailsItem
    
    public var items: [CollectionDetailsItem] {
        switch self {
        case .section(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: CollectionDetailsSectionModel, items: [CollectionDetailsItem]) {
        switch original {
        case .section(let title, let items):
            self = .section(title: title, items: items)
        }
    }
}

extension CollectionDetailsSectionModel {
    var title: String {
        switch self {
        case .section(title: let title, items: _):
            return title
        }
    }
}
