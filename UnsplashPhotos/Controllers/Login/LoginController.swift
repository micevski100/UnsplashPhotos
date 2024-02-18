//
//  LoginController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 9.10.23.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices
import Alamofire

class LoginController: BaseController<LoginView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeLoginButtonClick()
    }
    
    fileprivate func observeLoginButtonClick() {
        self.contentView.loginButton.rx.tap.bind {
            self.loadAuthenticationPage()
        }.disposed(by: disposeBag)
    }
    
    fileprivate func loadAuthenticationPage() {
        let params = [
            URLQueryItem(name: "client_id", value: Constants.AUTH_CLIENT_ID),
            URLQueryItem(name: "redirect_uri", value: Constants.REDIRECT_URI),
            URLQueryItem(name: "response_type", value: Constants.RESPONSE_TYPE),
            URLQueryItem(name: "scope", value: Constants.SCOPE),
        ]
     
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
        urlComponents.queryItems = params
        
        let authSession = ASWebAuthenticationSession(url: urlComponents.url!, callbackURLScheme: "monotone") { callbackURL, error in
            guard let callbackURL = callbackURL else { return }
            guard let code = callbackURL.value(of: "code") else { return }
            
            AuthAPI.shared.login(code: code)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { result in
                    guard result.error == nil else {
                        self.showGenericError()
                        return
                    }
                    
                    UserDefaults.standard.set(result.value!.access_token, forKey: "access_token")
                    
                    // TODO: Fix later...
                    UserAPI.shared.getProfile()
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { result in
                            if result.error != nil {
                                self.showGenericError()
                                return
                            }
                            
                            UserDefaults.standard.set(result.value!.first_name ?? "Unknown", forKey: "user_first_name")
                            UserDefaults.standard.set(result.value!.username, forKey: "username")
                            let controller = MainController()
                            controller.modalPresentationStyle = .fullScreen
                            self.present(controller, animated: false)
                        }, onError: { _ in
                        }).disposed(by: self.disposeBag)
                }).disposed(by: self.disposeBag)
            
        }
        authSession.presentationContextProvider = self
        authSession.start()
    }
}


extension LoginController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
