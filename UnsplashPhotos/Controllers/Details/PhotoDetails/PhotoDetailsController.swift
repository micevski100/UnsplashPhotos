//
//  PhotoDetailsController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 6.12.23.
//

import UIKit
import RxSwift
import RxCocoa
import Toaster

class PhotoDetailsController: BaseController<PhotoDetailsView> {
    
    var item: PhotoResponse!
    
    class func factoryController(_ item: PhotoResponse) -> ContentController<PhotoDetailsView> {
        let controlller = PhotoDetailsController()
        controlller.item = item
        return controlller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(item.user.username)'s photo"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.contentView.setup(item.urls.regular)
        
        let mapButton = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: .plain, target: self, action: #selector(photoLocationButtonClick))
        mapButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = mapButton
        
        observeDownloadButtonClick()
        observeAddPhotoButtonClick()
    }
    
    @objc private func photoLocationButtonClick() {
        let locations = [(41.1231, 20.8016),
                         (41.9981, 21.4254),
                         (41.3441, 21.5528),
                         (41.7797, 21.7376),
                         (41.1452, 22.4997),
                         (41.0297, 21.3292),
                         (42.1323, 21.7257),
                         (42.0069, 20.9715)
                    ]
        let location = locations[Int.random(in: 0..<locations.count)]
        
        
        let controller = MapController.factoryController(lat: location.0, lon: location.1)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func observeDownloadButtonClick() {
        self.contentView.downloadButton.rx.tap.bind {
            guard let imageData = self.contentView.imageView.image?.pngData() else {
                ToastCenter.default.cancelAll()
                Toast.Error(text: "Failed to download iamge").show()
                return
            }
            guard let compressedImage = UIImage(data: imageData) else {
                ToastCenter.default.cancelAll()
                Toast.Error(text: "Failed to download iamge").show()
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
            UIImageWriteToSavedPhotosAlbum(compressedImage, self, #selector(self.savedImage), nil)
            
        }.disposed(by: disposeBag)
    }
    
    private func observeAddPhotoButtonClick() {
        self.contentView.addButton.rx.tap.bind {
            self.presentAddPhotoPopUp() { proceed in
                if proceed {
                    ToastCenter.default.cancelAll()
                    Toast.Success(text: "Photo added to collection").show()
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func presentAddPhotoPopUp(completion: CompletionBlock?) {
        let modalController = AddPhotoPopUpController.factoryController(title: "Add photo to your collection",
                                                                        message: "Select a collection to add this photo to",
                                                                        photoId: item.id)
        modalController.onDismiss = completion
        self.present(modalController, animated: false)
    }
    
    @objc func savedImage(_ im:UIImage, error:Error?, context:UnsafeMutableRawPointer?) {
        if error != nil {
            ToastCenter.default.cancelAll()
            Toast.Error(text: "Unable downlaoded image").show()
            return
        }
        ToastCenter.default.cancelAll()
        Toast.Success(text: "Successfully downlaoded image").show()
    }
}
