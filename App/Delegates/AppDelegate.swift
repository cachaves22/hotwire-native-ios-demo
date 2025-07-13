//
//  AppDelegate.swift
//  
//
//  Created by Camila Souza on 1/9/25.
//

import HotwireNative
import UIKit
import WebKit
  
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Hotwire.loadPathConfiguration(from: [
            .server(baseURL.appending(path: "configurations/ios_v1.json"))
        ])
        
        Hotwire.config.backButtonDisplayMode = .minimal
        Hotwire.config.showDoneButtonOnModals = false
        
        Hotwire.config.debugLoggingEnabled = false

        Hotwire.config.makeCustomWebView = { configuration in
            let webView = WKWebView(frame: .zero, configuration: configuration)
            webView.allowsLinkPreview = false
            
            return webView
        }
        
        Hotwire.registerBridgeComponents([
            ButtonComponent.self,
            FormComponent.self,
            MenuComponent.self,
            OverflowMenuComponent.self,
            LocationComponent.self,
            BarcodeScannerComponent.self,
            PermissionsComponent.self,
            ReviewPromptComponent.self,
            ShareComponent.self,
            NotificationTokenComponent.self
        ])
                 
        return true
    }
}
