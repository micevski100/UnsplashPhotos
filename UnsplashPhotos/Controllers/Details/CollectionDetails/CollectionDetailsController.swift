//
//  CollectionDetailsController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 31.10.23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRetroSwift
import UniformTypeIdentifiers

class CollectionDetailsController: BaseController<CollectionDetailsView> {
    
    var collectionResponse: CollectionResponse!
    
    var viewModel: CollectionDetailsViewModel!
    var dataSource: RxCollectionViewSectionedReloadDataSource<CollectionDetailsSectionModel>!
    var isFirstLoad: Bool = true
    
    class func factoryController(_ collectionResponse: CollectionResponse) -> CollectionDetailsController {
        let controller = CollectionDetailsController()
        controller.collectionResponse = collectionResponse
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = collectionResponse.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.viewModel = CollectionDetailsViewModel()
        
        setupBarButtonItems()
        setupCollection()
        observeCollectionItemSelected()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isFirstLoad else { return }
        fetchData()
        isFirstLoad = false
    }
    
    private func fetchData() {
        CollectionsAPI.shared.getCollectionPhotos(id: self.collectionResponse.id)
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
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        self.present(picker, animated: true)
    }
    
    private func openPhotoPicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func setupBarButtonItems() {
        let currentUserName = UserDefaults.standard.string(forKey: "username")!
        if self.collectionResponse.user.username == currentUserName {
            let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addPhotoButtonClick))
            addButton.tintColor = .white
            let editCollectionButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(editCollectionButtonClick))
            self.navigationItem.rightBarButtonItems = [editCollectionButton, addButton]
        }
    }
    
    @objc private func addPhotoButtonClick() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Camera", style: .default, handler: { _ in self.openCamera() }))
        alert.addAction(.init(title: "Photo Library", style: .default, handler: { _ in self.openPhotoPicker() }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc private func editCollectionButtonClick() {
        let controller = CreateCollectionController.factoryController(self.collectionResponse)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func observeCollectionItemSelected() {
        self.contentView.collectionView.rx.itemSelected.subscribe { idxPath in
            switch (self.dataSource[idxPath]) {
            case .itemCell(item: let item):
                let controller = PhotoDetailsController.factoryController(item)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}

extension CollectionDetailsController: ContentCollectionRefreshDelegate {
    func collectionViewRefresh(_ collectionView: UICollectionView) {
        self.contentView.stopRefresh()
        self.fetchData()
    }
}

extension CollectionDetailsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let imageStr = image.pngData()?.base64EncodedString() else { return }
        
        // API DOES NOT SUPPORT PHOTO UPLOAD
        let alert = UIAlertController(title: "Sorry", message: "API does not support photo uploads", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK!", style: .cancel))
        picker.present(alert, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
