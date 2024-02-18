//
//  PopUpBaseController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 15.2.24.
//

import UIKit
import RxSwift
import RxCocoa

typealias CompletionBlock = (Bool) -> Void

class PopUpBaseController<T: PopUpBaseView>: BaseController<T> {
    
    var onDismiss: CompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.delegate = self
        observeCloseButtonTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contentView.show()
    }
    
    func dismissPopUp(_ proceed: Bool) {
        self.contentView.hide {
            self.dismiss(animated: false) {
                self.onDismiss?(proceed)
            }
        }
    }
    
    private func observeCloseButtonTap() {
        self.contentView.closeButton.rx.tap.bind {
            self.dismissPopUp(false)
        }.disposed(by: disposeBag)
    }
}

extension PopUpBaseController: PopUpBaseViewDelegate {
    func backgroundTapped() {
        self.dismissPopUp(false)
    }
}
