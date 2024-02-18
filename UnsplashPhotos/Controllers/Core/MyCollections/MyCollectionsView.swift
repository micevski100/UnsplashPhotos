//
//  MyCollectionsView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import Foundation
import SnapKit
import RxSwift
import RxCocoa


class MyCollectionsView: ContentView {
    
    var tableView: UITableView!
    
    var editTableContainer: UIView!
    var editTableStack: UIStackView!
    var addButton: CircleImageButton!
    var deleteButton: CircleImageButton!
    
    var refreshControl: UIRefreshControl!;
    var refreshDelegate: ContentTableRefreshDelegate?
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .black
        
        tableView = UITableView();
        tableView.backgroundColor = .clear
        tableView.delegate = nil;
        tableView.dataSource = nil;
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInset.bottom = 80
        self.addSubview(tableView);
        
        editTableContainer = UIView()
        editTableContainer.backgroundColor = UIColor.init(hex: 0x202226)
        editTableContainer.layer.cornerRadius = 30
        editTableContainer.layer.shadowColor = UIColor.white.cgColor
        editTableContainer.layer.shadowOpacity = 0.5
        editTableContainer.layer.shadowOffset = CGSize.zero
        editTableContainer.layer.shadowRadius = 5
        self.addSubview(editTableContainer)
        
        addButton = CircleImageButton(image: UIImage(systemName: "plus")!, backgroundColor: .systemGreen)
        deleteButton = CircleImageButton(image: UIImage(systemName: "xmark")!, backgroundColor: .systemRed)
        
        editTableStack = UIStackView(arrangedSubviews: [deleteButton, addButton])
        editTableStack.axis = .horizontal
        editTableStack.spacing = 20
        editTableContainer.addSubview(editTableStack)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        editTableContainer.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(self)
        }
        
        editTableStack.snp.makeConstraints { make in
            make.top.bottom.equalTo(editTableContainer).inset(10)
            make.left.right.equalTo(editTableContainer).inset(25)
        }
    }
    
    @objc func refreshCollectionView(_ sender: Any){
        if(self.refreshDelegate != nil){
            self.refreshDelegate?.tableViewResfresh(self.tableView);
        }
    }
    
    func setRefreshDelegate(_ delegate : ContentTableRefreshDelegate){
        self.refreshDelegate = delegate
        setupRefreshControl();
    }
    
    func stopRefresh(){
        self.refreshControl.endRefreshing()
    }
    
    func setupRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshCollectionView(_:)), for: .valueChanged);
        tableView.refreshControl = refreshControl
    }
}
