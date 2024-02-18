//
//  WelcomePopUpController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit
import RxSwift
import RxCocoa

class WelcomePopUpController: PopUpBaseController<WelcomePopUpView> {
    
    override class func factoryController() -> PopUpBaseController<WelcomePopUpView> {
        let controller = WelcomePopUpController()
        controller.modalPresentationStyle = .overFullScreen
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeProceedButtonClick()
    }
    
    private func observeProceedButtonClick() {
        self.contentView.proceedButton.rx.tap.bind {
            self.dismissPopUp(true)
        }.disposed(by: disposeBag)
    }
}
