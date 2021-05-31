//
//  AppDelegate.swift
//  apple-ios
//
//  Created by kou yamamoto on 2021/05/31.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Firebase初期化
        FirebaseApp.configure()

        let viewController = LoginViewController.instansiate()
        let presenter = LoginPresenter().inject(with: LoginPresenter.Dependency(view: viewController, model: LoginModel()))
        viewController.inject(with: LoginViewController.Dependency(preseter: presenter))
        window?.rootViewController = viewController
        return true
    }
}

