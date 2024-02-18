//
//  LoginView.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 9.10.23.
//

import UIKit

class LoginView: ContentView {
    
    var logoImageView: UIImageView!
    var loginButton: UIButton!
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .black
        
        logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFill
        self.addSubview(logoImageView)
        
        var config = UIButton.Configuration.borderedTinted()
        config.cornerStyle = .capsule
        
        loginButton = UIButton(configuration: config)
        loginButton.setTitle("Login or Register", for: .normal)
        self.addSubview(loginButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.width).dividedBy(2)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(logoImageView.snp.bottom)
        }
    }
}
