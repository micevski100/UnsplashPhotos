//
//  CreateCollectionController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 6.12.23.
//

import UIKit
import RxSwift
import RxCocoa

class CreateCollectionController: BaseController<CreateCollectionView> {
    
    private var collectionResponse: CollectionResponse?
    
    private var isCreatingCollection: Bool {
        return collectionResponse == nil
    }
    
    class func factoryController(_ collectionResponse: CollectionResponse?) -> BaseController<CreateCollectionView> {
        let controller = CreateCollectionController()
        controller.collectionResponse = collectionResponse
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = collectionResponse == nil ? "Create New Collection" : "Edit Collection"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.contentView.setup(collectionResponse)
        observeCreateButtonClick()
    }
    
    private func observeCreateButtonClick() {
        self.contentView.createButton.rx.tap.bind {
            let title = self.contentView.titleTextField.text!
            let description = self.contentView.descriptionTextView.text
            
            if self.isCreatingCollection {
                self.createCollection(title, description)
            } else {
                self.updateCollection(title, description)
            }
        }.disposed(by: disposeBag)
    }
    
    private func createCollection(_ title: String, _ description: String?) {
        CollectionsAPI.shared.createCollection(title, description)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.error != nil {
                    self.showGenericError()
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }, onError: { _ in
                self.showGenericError()
            }).disposed(by: disposeBag)
    }
    
    private func updateCollection(_ title: String, _ description: String?) {
        CollectionsAPI.shared.updateCollection(collectionResponse!.id, title, description)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.error != nil {
                    self.showGenericError()
                    return
                }
                
                let userInfo = ["collection": result.value!]
                NotificationCenter.default.post(name: .didUpdateCollection, object: nil, userInfo: userInfo)
                self.navigationController?.popViewController(animated: true)
            }, onError: { _ in
                self.showGenericError()
            }).disposed(by: disposeBag)
    }
}
