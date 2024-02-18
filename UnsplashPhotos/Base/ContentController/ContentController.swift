//
//  ContentController.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 7.10.23.
//

import UIKit
import SnapKit


open class ContentController<T: ContentView>: UIViewController {
    
    open var contentView: T!
    open var constraintBottom: Constraint!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        autoViewDidLoad()
    }
    
    open func autoViewDidLoad() {
        contentView = T(frame: CGRect.zero)
        contentView.tag = 1
        contentView.setViewController(self)
        self.view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view)
            constraintBottom = make.bottom.equalTo(self.view).constraint
            constraintBottom.isActive = true
        }
        setupViewResizerOnKeyboardShown()
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        removeForKeyboardNotifications();
    }
    
    // MARK: - Class Methods
    open class func factoryController() -> ContentController {
        return self.init()
    }
    
    // MARK: - Keyboard Functions
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShowForResizing),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHideForResizing),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc open func keyboardWillShowForResizing(notification: Notification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
        
        if keyboardSize.height != 0 {
            self.constraintBottom.update(offset: -keyboardSize.height)
            self.contentView.layoutIfNeeded();
        }
    }
    
    @objc open func keyboardWillHideForResizing(notification: Notification) {
        self.constraintBottom.update(offset: 0)
        self.contentView.layoutIfNeeded();
    }
    
    open func removeForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}
