//
//  HomeSetupCollection.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import RxDataSources

extension HomeController: UICollectionViewDelegate {
    
    func setupCollection() {
        self.contentView.collectionView.register(HomeCollectionPhotoCell.self, forCellWithReuseIdentifier: "HomeCollectionPhotoCell")
        self.contentView.collectionView.register(HomeCollectionCardCell.self, forCellWithReuseIdentifier: "HomeCollectionCardCell")
        self.contentView.collectionView.register(HomeCollectionSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCollectionSectionHeaderView")
        
        self.dataSource = generateDataSource()
        
        self.viewModel.initialize()
            .bind(to: self.contentView.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)

        self.contentView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        self.contentView.setRefreshDelegate(self)
    }
    
    func generateDataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSectionModel> {
        let datasource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell: { (dataSource, collection, idxPath, _) in
                var cell: ContentCollectionViewCell! = nil
                switch dataSource[idxPath] {
                case .PhotoCell(let collectionResponse, let item, let withCornerRadius):
                    let x: HomeCollectionPhotoCell = collection.dequeueReusableCell(forIndexPath: idxPath)
                    x.setup(collectionResponse, item, withCornerRadius)
                    x.delegate = self
                    cell = x
                case .SingleCardCell(let collectionResponse, let item):
                    let x: HomeCollectionCardCell = collection.dequeueReusableCell(forIndexPath: idxPath)
                    x.setup(collectionResponse, dataSource[idxPath.section].title, item, dataSource[idxPath.section].shape)
//                    x.delegate = self
                    cell = x
                }

                cell.updateConstraintsIfNeeded() // https://stackoverflow.com/a/39540360
                return cell
            },
            configureSupplementaryView: { (dataSource, collection, kind, idxPath) in
                var header: UICollectionReusableView! = nil
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let x = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionSectionHeaderView", for: idxPath) as! HomeCollectionSectionHeaderView
                    x.setup(dataSource[idxPath.section].title)
                    header = x
                default:
                    return UICollectionReusableView()
                }
                
                return header
            }
        )
        
        return datasource
    }
}

enum CollectionShape {
    case landscape
    case potraitMedium
    case potraitLarge
    case singleCardSmall
    case singleCardLarge
}

enum HomeSectionModel {
    case Section(title: String, shape: CollectionShape, items: [HomeItem])
}

enum HomeItem {
    case PhotoCell(collectionResponse: CollectionResponse, item: PhotoResponse, withCornerRadius: Bool)
    case SingleCardCell(collectionResponse: CollectionResponse, item: PhotoResponse)
}

extension HomeItem {
    var item: PhotoResponse {
        switch self {
        case .PhotoCell(_, let item, _), .SingleCardCell(_, let item):
            return item
        }
    }
    
    var collection: CollectionResponse {
        switch self {
        case .PhotoCell(let collectionResponse, _, _), .SingleCardCell(let collectionResponse, _):
            return collectionResponse
        }
    }
    
    var withCornerRadius: Bool {
        switch self {
        case .PhotoCell(_, _, let withCornerRadius):
            return withCornerRadius
        case .SingleCardCell(_, _):
            return false
        }
    }
}

extension HomeSectionModel: SectionModelType {
    typealias Item = HomeItem

    public var items: [HomeItem] {
        switch  self {
        case .Section(title: _, shape: _, items: let items):
            return items.map { $0 }
        }
    }

    init(original: HomeSectionModel, items: [Item]) {
        switch original {
        case let .Section(title, shape, items):
            self = .Section(title: title, shape: shape, items: items)
        }
    }
}

extension HomeSectionModel {
    var title: String {
        switch self {
        case .Section(title: let title, shape: _,  items: _):
            return title
        }
    }
    
    var shape: CollectionShape {
        switch self {
        case .Section(title: _, shape: let shape, items: _):
            return shape
        }
    }
}

//protocol CollectionClickDelegate {
//    func collectionClicked(_ collectionResponse: CollectionResponse, _ cardShape: CollectionShape)
//}
