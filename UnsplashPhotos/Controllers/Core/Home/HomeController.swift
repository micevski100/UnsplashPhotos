//
//  HomeController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRetroSwift
import UserNotifications

class HomeController: BaseController<HomeView> {
    
    var viewModel: HomeViewModel!
    var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSectionModel>!
    var isFirstLoad: Bool = true
    
    class func factoryController() -> UINavigationController {
        let controller = HomeController()
        let mainController = UINavigationController(rootViewController: controller)
        return mainController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = HomeViewModel()
        self.title = "Home"
        
        self.setupNavbar()
        self.setupCollection()
        self.contentView.collectionView.collectionViewLayout = createLayout()
        observeItemSelected()
        checkPushNotificationPermission()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard isFirstLoad else { return }
        
        fetchData()
        let onboardingComleteded: Bool = UserDefaults.standard.bool(forKey: "onboarding_completed")
        
        if !onboardingComleteded {
            self.presentWelcomePopUp()
            UserDefaults.standard.set(true, forKey: "onboarding_completed")
        }
        isFirstLoad = false
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] (sectionIdx: Int, layoutEnvironment: NSCollectionLayoutEnvironment) in
            guard let self = self else { return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))) }
            
            let section = self.dataSource[sectionIdx]
            switch section.shape {
            case .landscape:
                let section =  self.createCollectionLayoutSection(.init(widthDimension: .fractionalWidth(0.42),
                                                                        heightDimension: .fractionalHeight(0.22)))
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [self.sectionHeaderItem()]
                return section
            case .potraitMedium:
                let section =  self.createCollectionLayoutSection(.init(widthDimension: .fractionalWidth(0.28),
                                                                        heightDimension: .fractionalHeight(0.3)))
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [self.sectionHeaderItem()]
                return section
            case .potraitLarge:
                let section =  self.createCollectionLayoutSection(.init(widthDimension: .fractionalWidth(0.9),
                                                                        heightDimension: .fractionalHeight(0.6)))
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [self.sectionHeaderItem()]
                return section
            case .singleCardSmall:
                let section =  self.createCollectionLayoutSection(.init(widthDimension: .fractionalWidth(1.0),
                                                                        heightDimension: .fractionalWidth(0.35)))
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = .init(top: 40, leading: 10, bottom: 0, trailing: 10)
                return section
            case .singleCardLarge:
                let section =  self.createCollectionLayoutSection(.init(widthDimension: .fractionalWidth(1.0),
                                                                        heightDimension: .fractionalHeight(0.4)))
                section.orthogonalScrollingBehavior = .none
                section.contentInsets = .init(top: 40, leading: 10, bottom: 0, trailing: 10)
                return section
            }
        }
    }
    
    private func createCollectionLayoutSection(_ layoutSize: NSCollectionLayoutSize) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.supplementaryContentInsetsReference = .none
        return section
    }
    
    private func sectionHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        return .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func fetchData() {
        CollectionsAPI.shared.listCollections(per_page: 20)
            .flatMap { collectionsResult in
                switch collectionsResult {
                case .successful(let collections):
                    return Observable.from(collections)
                        .flatMap { collection in
                            return CollectionsAPI.shared.getCollectionPhotos(id: collection.id)
                                .flatMap { photosResult in
                                    switch photosResult {
                                    case .successful(let photos):
                                        return Observable.just((collection, photos))
                                    case .failure(let error):
                                        return Observable.error(error)
                                    case .none:
                                        return Observable.empty()
                                    }
                                }
                        }
                case .failure(let error):
                    return Observable.error(error)
                case .none:
                    return Observable.empty()
                }
            }
            .toArray()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { result in
                
                let completeResult = result.filter { (collectionResponse, photosResponse) in photosResponse.count > 0 }
                self.viewModel.map(completeResult)
                self.contentView.collectionView.reloadData()
            }, onError: { _ in
                self.showGenericError()
            }).disposed(by: disposeBag)
    }
    
    private func observeItemSelected() {
        self.contentView.collectionView.rx.itemSelected.subscribe { idxPath in
            switch self.dataSource[idxPath] {
            case .PhotoCell(collectionResponse: let collectionResponse, item: _, withCornerRadius: _):
                let controller = CollectionDetailsController.factoryController(collectionResponse)
                self.navigationController?.pushViewController(controller, animated: true)
            case .SingleCardCell(collectionResponse: let collectionResponse, item: _):
                let controller = CollectionDetailsController.factoryController(collectionResponse)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func presentWelcomePopUp() {
        let modalController = WelcomePopUpController.factoryController()
        self.present(modalController, animated: false)
    }
}

extension HomeController: ContentCollectionRefreshDelegate {
    func collectionViewRefresh(_ collectionView: UICollectionView) {
        self.contentView.stopRefresh()
        self.fetchData()
    }
}

extension HomeController: HomeCollectionPhotoCellDelegate {
    func photoLikeButtonClick(_ isSelected: Bool, _ photoId: String) {
        let obs$ = isSelected ? PhotoAPI.shared.likePhoto(id: photoId) : PhotoAPI.shared.dislikePhoto(id: photoId)
        obs$
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { result in
            if (result.error != nil) {
                self.showGenericError()
                return
            }
            self.viewModel.updatePhoto(result.value!.photo)
        }, onError: { _ in
            self.showGenericError()
        }).disposed(by: disposeBag)
    }
}

extension HomeController {
    private func checkPushNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.sendNotification()
                    }
                }
            case .authorized:
                self.sendNotification()
            default:
                return
            }
        }
    }
    
    private func sendNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        let date = Date()
        let calendar = Calendar.current
        
        let identifier1 = "check-collection-notification"
        let content1 = UNMutableNotificationContent()
        content1.title = "Check out latest collections!"
        content1.body = "Don't miss out on our latest collections! 🫣 They might surprise you 👀"
        content1.sound = .default
        
        let identifier2 = "we-missed-you-notification"
        let content2 = UNMutableNotificationContent()
        content2.title = "We missed you 😔"
        content2.body = "Hey friend! We missed you ...\n Looking for a fresh new wallpaper? 😊"
        content2.sound = .default
        
        var dateComponents1 = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents1.hour = calendar.component(.hour, from: date)
        dateComponents1.minute = calendar.component(.minute, from: date) + 1
        
        var dateComponents2 = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents2.hour = calendar.component(.hour, from: date)
        dateComponents2.minute = calendar.component(.minute, from: date) + 2

        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: true )
        let request1 = UNNotificationRequest(identifier: identifier1, content: content1, trigger: trigger1)
        
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: true )
        let request2 = UNNotificationRequest(identifier: identifier2, content: content2, trigger: trigger2)
        
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier1, identifier2])
        notificationCenter.add(request1)
        notificationCenter.add(request2)
    }
}
