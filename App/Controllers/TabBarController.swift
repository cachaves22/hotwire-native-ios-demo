//
//  TabBarController.swift
//  
//
//  Created by Camila Souza on 1/9/25.
//

import HotwireNative
import UIKit

class TabBarController: UITabBarController {
    private var navigators = [Navigator]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        viewControllers = makeViewControllers()
        tabBarController(self, didSelect: viewControllers!.first!)
    }
    
    private func makeViewControllers() -> [UIViewController] {
        return Tab.all.map { tab in
            let navigator = Navigator()
            navigator.route(baseURL.appending(path: tab.path))
            navigators.append(navigator)
            
            let controller = navigator.rootViewController
    
            controller.tabBarItem.title = tab.title
            controller.tabBarItem.image = UIImage(systemName: tab.image)
  
            return controller
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController)
    {
        guard let index = viewControllers?.firstIndex(of: viewController)
        else { return }
        
        let tab = Tab.all[index] 
        if !tab.isStarted {
            navigators[index].route(baseURL.appending(path: tab.path))
            tab.isStarted = false
        }
        
    }
}

extension TabBarController: NavigatorDelegate {
    func handle(proposal: VisitProposal) -> ProposalResult {
        switch proposal.viewController {
        //case "map": .acceptCustom(MapController(url: proposal.url))
        default:
            return .acceptCustom(HotwireWebViewController(url: proposal.url))
        }
    }
}

extension UITabBar {
    static func configureWithOpaqueBackground() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.00)

        UITabBar.appearance().tintColor = UIColor(red: 0.92, green: 0.33, blue: 0.33, alpha: 1.00)
        
        appearance().standardAppearance = tabBarAppearance
        appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
