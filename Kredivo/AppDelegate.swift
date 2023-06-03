//
//  AppDelegate.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 27/05/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        makeRootController()
        return true
    }

    private func makeRootController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .kredivoBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        window?.rootViewController = TopUpScreenFactory().make()
        window?.makeKeyAndVisible()

        guard let frame = window?
            .windowScene?
            .statusBarManager?
            .statusBarFrame else { return }

        let statusBar: UIView = .init(frame: frame)
        statusBar.backgroundColor = .kredivoBlue
        window?.rootViewController?.view.addSubview(statusBar)
    }

}

