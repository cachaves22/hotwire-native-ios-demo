//
//  OverflowComponent.swift
//  
//
//  Created by Camila Souza on 1/14/25.
//

import Foundation
import HotwireNative
import UIKit

/// Bridge component to display a native 3-dot menu in the toolbar,
/// which will notify the web when it has been tapped.
final class OverflowMenuComponent: BridgeComponent {
    override class var name: String { "overflow-menu" }

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else {
            return
        }

        switch event {
        case .connect:
            handleConnectEvent(message: message)
        }
    }

    // MARK: Private

    private var viewController: UIViewController? {
        delegate.destination as? UIViewController
    }

    private func handleConnectEvent(message: Message) {
        guard let data: MessageData = message.data() else { return }
        showOverflowMenuItem(data)
    }

    private func showOverflowMenuItem(_ data: MessageData) {
        guard let viewController else { return }

        let action = UIAction { [unowned self] _ in
            overflowAction()
        }

        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: data.label,
            image: .init(systemName: "ellipsis.circle"),
            primaryAction: action
        )
    }

    private func overflowAction() {
        reply(to: Event.connect.rawValue)
    }
}

// MARK: Events

private extension OverflowMenuComponent {
    enum Event: String {
        case connect
    }
}

// MARK: Message data

private extension OverflowMenuComponent {
    struct MessageData: Decodable {
        let label: String
    }
}
