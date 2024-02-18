//
//  MyCollectionsSetupTable.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 30.11.23.
//

import UIKit
import RxDataSources

extension MyCollectionsController: UITableViewDelegate {
    
    func setupTableView() {
        self.contentView.tableView.register(MyCollectionsTableItemCell.self, forCellReuseIdentifier: "MyCollectionsTableItemCell")
        
        self.dataSource = generateDataSource()
        
        self.viewModel.initialize()
            .bind(to: self.contentView.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        self.contentView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.contentView.setRefreshDelegate(self)
    }
    
    func generateDataSource() -> RxTableViewSectionedAnimatedDataSource<MyCollectionsSectionModel> {
        let animationConfig = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic)
        let datasource = RxTableViewSectionedAnimatedDataSource<MyCollectionsSectionModel>(animationConfiguration: animationConfig) { dataSource, table, idxPath, _ in
            var cell: ContentTableViewCell! = nil
            switch dataSource[idxPath] {
            case .ItemCell(item: let item):
                let x: MyCollectionsTableItemCell = table.dequeueReusableCell(forIndexPath: idxPath)
                x.setup(item)
                x.delegate = self
                cell = x
            }
            cell.updateConstraintsIfNeeded() // https://stackoverflow.com/a/39540360
            return cell
        }
        
        return datasource
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 4
    }
}


enum MyCollectionsSectionModel {
    case Section(title: String, items: [MyCollectionsItem])
}

enum MyCollectionsItem {
    case ItemCell(item: CollectionResponse)
}

extension MyCollectionsSectionModel: AnimatableSectionModelType {
    typealias Item = MyCollectionsItem
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .Section(title: let title, items: _):
            return title
        }
    }
    
    var items: [MyCollectionsItem] {
        switch self {
        case .Section(_, items: let items):
            return items
        }
    }
    
    init(original: MyCollectionsSectionModel, items: [MyCollectionsItem]) {
        switch original {
        case .Section(let title, _):
            self = .Section(title: title, items: items)
        }
    }
    
}

extension MyCollectionsItem: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .ItemCell(let item):
            return item.id 
        }
    }
    
    var item: CollectionResponse {
        switch self {
        case .ItemCell(let item):
            return item
        }
    }
    
    static func == (lhs: MyCollectionsItem, rhs: MyCollectionsItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension MyCollectionsSectionModel {
    var title: String {
        switch self {
        case .Section(let title, _):
            return title
        }
    }
}
