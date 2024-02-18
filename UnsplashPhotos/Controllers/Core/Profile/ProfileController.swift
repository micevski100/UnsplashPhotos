//
//  ProfileController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRetroSwift

class ProfileController: BaseController<ProfileView> {
    
    var viewModel: ProfileViewModel!
    
    class func factoryController() -> UINavigationController {
        let controller = ProfileController()
        let mainController = UINavigationController(rootViewController: controller)
        return mainController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ProfileViewModel()
        self.title = "Profile"
        self.setupNavbar()
        self.navigationItem.rightBarButtonItem = nil
        
        observeLocationSectionButtonClick()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    private func fetchData() {
        UserAPI.shared.getProfile()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.error != nil {
                    self.showGenericError()
                    return
                }
                
                self.contentView.setup(result.value!)
            }, onError: { _ in
                self.showGenericError()
            }).disposed(by: disposeBag)
    }
    
    private func observeLocationSectionButtonClick() {
        self.contentView.locationSection.cardButton.rx.tap.bind {
            let controller = MapController.factoryController()
            self.navigationController?.pushViewController(controller, animated: true)
        }.disposed(by: disposeBag)
    }
}
