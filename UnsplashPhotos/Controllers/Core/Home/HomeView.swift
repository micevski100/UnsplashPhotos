//
//  HomeView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import Foundation
import SnapKit
import RxSwift
import RxCocoa

class HomeView: ContentView {
    
    var collectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl!;
    var refreshDelegate: ContentCollectionRefreshDelegate?
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .black
        
        let layout = UICollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = nil
        collectionView.dataSource = nil
        self.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    @objc func refreshCollectionView(_ sender: Any){
        if(self.refreshDelegate != nil){
            self.refreshDelegate?.collectionViewRefresh(self.collectionView);
        }
    }
    
    func setRefreshDelegate(_ delegate : ContentCollectionRefreshDelegate){
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
        collectionView.refreshControl = refreshControl
    }
}
