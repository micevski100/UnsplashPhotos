//
//  AddPhotoPopUpSetupTable.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit
import RxDataSources

extension AddPhotoPopUpController: UITableViewDelegate {
    
    func setupTable() {
        self.contentView.tableView.register(AddPhotoPopUpTableCell.self, forCellReuseIdentifier: "AddPhotoPopUpTableCell")
        
        self.dataSource = self.generateDataSource()
        
        self.viewModel.initialize()
            .bind(to: self.contentView.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        self.contentView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func generateDataSource() -> RxTableViewSectionedReloadDataSource<AddPhotoPopUpSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<AddPhotoPopUpSectionModel> { dataSource, table, idxPath, _ in
            var cell: ContentTableViewCell! = nil
            
            switch dataSource[idxPath] {
            case .ItemCell(let item):
                let x: AddPhotoPopUpTableCell = table.dequeueReusableCell(forIndexPath: idxPath)
                x.setup(item.title, item.id)
                cell = x
            }
            
            cell.updateConstraintsIfNeeded()
            return cell
        }
        
        return datasource
    }
}

enum AddPhotoPopUpSectionModel {
    case Section(items: [AddPhotoPopUpItem])
}

enum AddPhotoPopUpItem {
    case ItemCell(item: CollectionResponse)
}

extension AddPhotoPopUpSectionModel: SectionModelType {
    typealias Item = AddPhotoPopUpItem
    
    public var items: [AddPhotoPopUpItem] {
        switch self {
        case .Section(let items):
            return items.map { $0 }
        }
    }
    
    init(original: AddPhotoPopUpSectionModel, items: [AddPhotoPopUpItem]) {
        switch original {
        case .Section(let items):
            self = .Section(items: items)
        }
    }
}
