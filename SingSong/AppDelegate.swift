//
//  AppDelegate.swift
//  SingSong
//
//  Created by Jake Grant on 2/17/19.
//  Copyright © 2019 Jake Grant. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Default user settings
        UserDefaults.standard.register(defaults: ["UserThemePreference": "dark"])

        // Adjust screen brightness
        UIScreen.main.brightness = CGFloat(0.0)

        // Coordinator
        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        coordinator?.importSongs(from: url)
        return true
    }
}
