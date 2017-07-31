//
//  LoginViewController.swift
//  OctoEye
//
//  Created by mzp on 2017/07/29.
//  Copyright © 2017 mzp. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

internal class LoginViewController: UIViewController {
    private let loginButton: UIButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        self.view.addSubview(loginButton)

        loginButton.setTitle("🔐", for: .normal)
        loginButton.layer.cornerRadius = 2.0
        loginButton.layer.borderColor = UIColor.gray.cgColor
        loginButton.layer.borderWidth = 1.0
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        for anchor in [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ] {
            anchor.isActive = true
        }

        let authorization = GithubAuthorization()
        loginButton.reactive
            .mapControlEvents(.touchDown) { _ in () }
            .flatMap(.concat) { _ in SignalProducer(authorization.call()) }
            .observeResult { result in
                switch result {
                case .success(let credential):
                    Preferences.accessToken = credential.oauthToken
                    DispatchQueue.main.async {
                        self.present(PreferencesViewController(), animated: true) {}
                    }
                case .failure(let error):
                    self.presentError(title: "Github authorization error", error: error)
                }
            }
    }
}
