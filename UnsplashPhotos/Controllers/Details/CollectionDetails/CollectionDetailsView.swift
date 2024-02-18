//
//  CollectionDetailsView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 31.10.23.
//

import UIKit
import SnapKit
import Foundation
import RxSwift
import RxCocoa


class CollectionDetailsView: ContentView {
    
    let disposeBag = DisposeBag()

    var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    var refreshDelegate: ContentCollectionRefreshDelegate?
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .black
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: UIScreen.main.bounds.width * 0.7)
        
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
