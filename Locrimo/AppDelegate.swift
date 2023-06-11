//
//  AppDelegate.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let splashVC = SplashViewController(nibName: SplashViewController.className, bundle: nil)
        splashVC.inject(viewModel: SplashViewModelImpl(), delegate: self)
        self.window?.rootViewController = splashVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate: SplashViewControllerDelegate {
    func appStart() {
        let searchVC = SearchViewController(nibName: SearchViewController.className, bundle: nil)
        let viewModel = SearchViewModelImpl()
        searchVC.inject(viewModel: viewModel)
        let viewC = UINavigationController(rootViewController: searchVC)
        self.window?.rootViewController = viewC
    }
}

