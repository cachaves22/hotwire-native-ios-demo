//
//  SceneDelegate.swift
//  
//
//  Created by Camila Souza on 1/9/25.
//

import HotwireNative
import UIKit
import WebKit

let baseURL = URL(string: "http://localhost:3000")!


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        UITabBar.configureWithOpaqueBackground()
        UINavigationBar.configureWithOpaqueBackground()
        window?.rootViewController = TabBarController()
        window?.overrideUserInterfaceStyle = .dark
    }
}

extension UINavigationBar {
    static func configureWithOpaqueBackground() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(red: 0.92, green: 0.33, blue: 0.33, alpha: 1.00)
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .backgroundColor: UIColor(red: 0.92, green: 0.33, blue: 0.33, alpha: 1.00)]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .backgroundColor: UIColor(red: 0.92, green: 0.33, blue: 0.33, alpha: 1.00)]

        appearance().scrollEdgeAppearance = navigationBarAppearance
        appearance().standardAppearance = navigationBarAppearance
    }
}
