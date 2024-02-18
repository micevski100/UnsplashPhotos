//
//  LikedSetupCollection.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 5.12.23.
//

import UIKit
import RxDataSources

extension LikedController: UICollectionViewDelegate {
    
    func setupCollection() {
        self.contentView.collectionView.register(LikedCollectionItemCell.self, forCellWithReuseIdentifier: "LikedCollectionItemCell")
        
        self.dataSource = generateDataSource()
        
        self.viewModel.initialize()
            .bind(to: self.contentView.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        self.contentView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.contentView.setRefreshDelegate(self)
    }
    
    func generateDataSource() -> RxCollectionViewSectionedReloadDataSource<LikedSectionModel> {
        let datasource = RxCollectionViewSectionedReloadDataSource<LikedSectionModel> { (dataSource, collection, idxPath, _) in
            var cell: ContentCollectionViewCell! = nil
            switch dataSource[idxPath] {
            case .ItemCell(item: let item):
                let x: LikedCollectionItemCell = collection.dequeueReusableCell(forIndexPath: idxPath)
                x.setup(item)
                cell = x
            }
            cell.updateConstraintsIfNeeded() // https://stackoverflow.com/a/39540360
            return cell
        }
        
        return datasource
    }
}


enum LikedSectionModel {
    case Section(title: String, items: [LikedItem])
}

enum LikedItem {
    case ItemCell(item: PhotoResponse)
}

extension LikedItem {
    var item: PhotoResponse {
        switch self {
        case .ItemCell(item: let item):
            return item
        }
    }
}

extension LikedSectionModel: SectionModelType {
    typealias Item = LikedItem
    
    public var items: [LikedItem] {
        switch self {
        case .Section(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: LikedSectionModel, items: [LikedItem]) {
        switch original {
        case .Section(let title, let items):
            self = .Section(title: title, items: items)
        }
    }
}

extension LikedSectionModel {
    var title: String {
        switch self {
        case .Section(title: let title, items: _):
            return title
        }
    }
}
