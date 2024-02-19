//
//  LaunchScreenAnimator.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 13.10.23.
//

import UIKit

class LaunchScreenAnimator: UIViewController {

    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animate()
        })
    }
    
    func setupViews() {
        self.view.backgroundColor = .black
        imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    private func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5) {
                self.imageView.alpha = 0
            } completion: { completed in
                if completed {
                    if UserDefaults.standard.string(forKey: "access_token") != nil {
                        let controller = MainController()
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: false)
                    } else {
                        let loginController = LoginController()
                        loginController.modalTransitionStyle = .crossDissolve
                        loginController.modalPresentationStyle = .fullScreen
                        self.present(loginController, animated: true)
                    }
                }
            }
        }
    }
}

