//
//  MyCollectionsController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRetroSwift

class MyCollectionsController: BaseController<MyCollectionsView> {
    
    var viewModel: MyCollectionsViewModel!
    var dataSource: RxTableViewSectionedAnimatedDataSource<MyCollectionsSectionModel>!
    var edit: Bool = false
    var selectedCell: MyCollectionsTableItemCell? = nil
    
    class func factoryController() -> UINavigationController {
        let controller = MyCollectionsController()
        let mainController = UINavigationController(rootViewController: controller)
        return mainController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = MyCollectionsViewModel()
        self.title = "My Collections"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateCollection(_:)), name: .didUpdateCollection, object: nil)
        
        setupNavbar()
        setupTableView()
        observeCollectionDeletionModeToggle()
        observeRemoveOrAddCollectionButtonClick()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        UserAPI.shared.listMyCollections()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.error != nil {
                    self.showGenericError()
                    return
                }
                
                self.viewModel.map(result.value!)
                self.contentView.tableView.reloadData()
            }, onError: { _ in
                self.showGenericError()
            }).disposed(by: disposeBag)
    }
    
    private func updateEditModeUI() {
        self.contentView.addButton.setImage(UIImage(systemName: self.edit ? "checkmark" : "plus"), for: .normal)
        self.contentView.addButton.backgroundColor = self.edit ? .systemRed : .systemGreen
        self.contentView.deleteButton.backgroundColor = self.edit ? .systemGreen : .systemRed
        self.contentView.editTableContainer.layer.shadowColor = self.edit ? UIColor.systemRed.cgColor : UIColor.white.cgColor
        self.contentView.editTableContainer.layer.shadowOpacity = self.edit ? 1 : 0.5
    }
    
    @objc private func didUpdateCollection(_ notifictaion: Notification) {
        guard let collection = notifictaion.userInfo?["collection"] as? CollectionResponse else { return }
        
        self.viewModel.updateCollection(collection)
        self.contentView.tableView.reloadData()
    }
    
    private func observeCollectionDeletionModeToggle() {
        self.contentView.deleteButton.rx.tap.bind {
            self.edit.toggle()
            self.contentView.tableView.isScrollEnabled.toggle()
            self.updateEditModeUI()
            if !self.edit && self.selectedCell != nil {
                self.selectedCell?.isSelected.toggle()
                self.selectedCell = nil
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func observeRemoveOrAddCollectionButtonClick() {
        self.contentView.addButton.rx.tap.bind {
            if self.edit {
                guard self.selectedCell != nil else { return }
                CollectionsAPI.shared.deleteCollection(id: self.selectedCell!.item.id)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { result in
                        if result.error != nil {
                            self.showGenericError()
                            return
                        }
                        
                        self.viewModel.remove(self.selectedCell!.item.id)
                    }, onError: { _ in
                        self.showGenericError()
                    }).disposed(by: self.disposeBag)
            } else {
                let controller = CreateCollectionController.factoryController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.didUpdateCollection, object: nil)
    }
}

extension MyCollectionsController: ContentTableRefreshDelegate {
    func tableViewResfresh(_ tableView: UITableView) {
        self.contentView.stopRefresh()
        self.fetchData()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow, indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        return indexPath
    }
}

extension MyCollectionsController: MyCollectionsTableItemCellProtocol {
    func cardTapped(_ item: CollectionResponse, _ cell: MyCollectionsTableItemCell) {
        if self.edit {
            guard cell != selectedCell else { return }
            cell.isSelected.toggle()
            selectedCell?.isSelected.toggle()
            selectedCell = cell
        } else {
            let controller = CollectionDetailsController.factoryController(item)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
