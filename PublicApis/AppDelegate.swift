//
//  AppDelegate.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 15/12/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()
        let navViewController = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = navViewController

        return true
    }

}

