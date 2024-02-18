//
//  LikedController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRetroSwift

class LikedController: BaseController<LikedView> {
    
    var viewModel: LikedViewModel!
    var dataSource: RxCollectionViewSectionedReloadDataSource<LikedSectionModel>!
    var isFirstLoad: Bool = true
    
    class func factoryController() -> UINavigationController {
        let controller = LikedController()
        let mainController = UINavigationController(rootViewController: controller)
        return mainController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Your liked photos"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.viewModel = LikedViewModel()
        setupNavbar()
        setupCollection()
        observeItemSelected()
        self.contentView.collectionView.collectionViewLayout = createLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isFirstLoad else { return }
        fetchData()
        isFirstLoad = false
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3)), repeatingSubitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func fetchData() {
        UserAPI.shared.getLikedPhotos()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.error != nil {
                    self.showGenericError()
                    return
                }
                
                self.dataSource.setSections(self.viewModel.map(result.value!))
                self.contentView.collectionView.reloadData()
            }, onError: { _ in
                self.showGenericError()
            }).disposed(by: disposeBag)
    }
    
    private func observeItemSelected() {
        self.contentView.collectionView.rx.itemSelected.subscribe { idxPath in
            switch self.dataSource[idxPath] {
            case .ItemCell(item: let item):
                let controller = PhotoDetailsController.factoryController(item)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}

extension LikedController: ContentCollectionRefreshDelegate {
    func collectionViewRefresh(_ collectionView: UICollectionView) {
        self.contentView.stopRefresh()
        self.fetchData()
    }
}
