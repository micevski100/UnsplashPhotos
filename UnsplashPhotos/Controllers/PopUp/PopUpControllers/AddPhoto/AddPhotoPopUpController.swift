//
//  AddPhotoPopUpController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Toaster

class AddPhotoPopUpController: PopUpBaseController<AddPhotoPopUpView> {
    
    var titleText: String!
    var descriptionText: String!
    var selectedColectionId: String? = nil
    var selectedPhotoId: String!
    
    var dataSource: RxTableViewSectionedReloadDataSource<AddPhotoPopUpSectionModel>!
    var viewModel: AddPhotoPopUpViewModel!
    
    class func factoryController(title: String, message: String, photoId: String) -> PopUpBaseController<AddPhotoPopUpView> {
        let controller = AddPhotoPopUpController()
        controller.titleText = title
        controller.descriptionText = message
        controller.selectedPhotoId = photoId
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AddPhotoPopUpViewModel()
        self.contentView.setup(titleText, descriptionText)
        setupTable()
        
        observeTableViewItemSelect()
        observeCancelButtonClick()
        observeProceedButtonClick()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    private func loadData() {
        self.subscriptionBag = self.viewModel.fetch()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                self.dataSource.setSections(result)
                self.contentView.tableView.reloadData()
            }, onError: { _ in
                self.dismissPopUp(false)
            })
        self.subscriptionBag?.disposed(by: disposeBag)
    }
    
    private func observeCancelButtonClick() {
        self.contentView.cancelButton.rx.tap.bind {
            self.dismissPopUp(false)
        }.disposed(by: disposeBag)
    }
    
    private func observeProceedButtonClick() {
        self.contentView.proceedButton.rx.tap.bind {
            guard self.selectedColectionId != nil else { return }
            
            CollectionsAPI.shared.addPhotoToCollection(collectionId: self.selectedColectionId!, photoId: self.selectedPhotoId)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { result in
                    self.dismissPopUp(result.error == nil)
                }, onError: { _ in
                    ToastCenter.default.cancelAll()
                    Toast.Error(text: "Unable to add photo to collection").show()
                    self.dismissPopUp(false)
                }).disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
    }
    
    private func observeTableViewItemSelect() {
        self.contentView.tableView.rx.modelSelected(AddPhotoPopUpItem.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { model in
                switch(model) {
                case .ItemCell(let item):
                    self.selectedColectionId = item.id
                    if !self.contentView.proceedButton.isEnabled {
                        self.contentView.enableProceedButton()
                    }
                }
            }).disposed(by: disposeBag)
    }
}
