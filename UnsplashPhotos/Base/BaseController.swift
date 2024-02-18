//
//  BaseController.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 7.10.23.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

class BaseController<T: ContentView>: ContentController<T>, UISearchBarDelegate {
    
    let disposeBag = DisposeBag()
    var subscriptionBag: Disposable? = nil
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupNavbar() {
        // left bar button item
        let containerView = UIControl(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        let image = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        image.image = UIImage(named: "logo-nav")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        containerView.addSubview(image)
        let logoBarButtonItem = UIBarButtonItem(customView: containerView)
        self.navigationItem.leftBarButtonItem = logoBarButtonItem
        
        // right bar button item
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchBar.searchTextField.textColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonClick))
    }
    
    @objc func searchButtonClick() {
        self.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        self.navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonClick))
        searchBar.showsCancelButton = false
    }
    
    func showGenericError() {
        ToastCenter.default.cancelAll()
        Toast.Error(text: "Something went wrong.").show()
    }
}

