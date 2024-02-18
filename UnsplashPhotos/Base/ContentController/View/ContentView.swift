//
//  ContentView.swift
//  MiaTestProject
//
//  Created by Aleksandar Micevski on 7.10.23.
//

import UIKit
import SnapKit

open class ContentView: UIView {
    
    open var shouldSetupConstraints = true
    public let screenSize = UIScreen.main.bounds
    open var viewController: UIViewController!
    
    public override required init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    open func setupViews() { }
    open func setupConstraints() {}
    open func setViewController(_ controller: UIViewController) {
        viewController = controller
    }
    
    open override func updateConstraints() {
        if shouldSetupConstraints {
            setupConstraints()
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    open class func factoryView() -> ContentView {
        return self.init(frame: CGRect.zero)
    }
}

public protocol ContentTableRefreshDelegate {
    func tableViewResfresh(_ tableView: UITableView)
}

public protocol ContentCollectionRefreshDelegate {
    func collectionViewRefresh(_ collectionView: UICollectionView)
}
