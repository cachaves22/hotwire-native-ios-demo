//
//  MenuComponent.swift
//  
//
//  Created by Camila Souza on 1/14/25.
//

import Foundation
import HotwireNative
import UIKit

/// Bridge component to display a native bottom sheet menu,
/// which will send the selected index of the tapped menu item back to the web.
final class MenuComponent: BridgeComponent {
    override class var name: String { "menu" }

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else {
            return
        }

        switch event {
        case .display:
            handleDisplayEvent(message: message)
        }
    }

    // MARK: Private

    private var viewController: UIViewController? {
        delegate.destination as? UIViewController
    }

    private func handleDisplayEvent(message: Message) {
        guard let data: MessageData = message.data() else { return }
        showAlertSheet(with: data.title, items: data.items)
    }

    private func showAlertSheet(with title: String, items: [Item]) {
        let alertController = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )

        for item in items {
            let action = UIAlertAction(title: item.title, style: .default) { [unowned self] _ in
                onItemSelected(item: item)
            }
            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        // Set popoverController for iPads
        if let popoverController = alertController.popoverPresentationController {
            if let barButtonItem = viewController?.navigationItem.rightBarButtonItem {
                popoverController.barButtonItem = barButtonItem
            } else {
                popoverController.sourceView = viewController?.view
                popoverController.sourceRect = viewController?.view.bounds ?? .zero
                popoverController.permittedArrowDirections = []
            }
        }

        viewController?.present(alertController, animated: true)
    }

    private func onItemSelected(item: Item) {
        reply(
            to: Event.display.rawValue,
            with: SelectionMessageData(selectedIndex: item.index)
        )
    }
}

// MARK: Events

private extension MenuComponent {
    enum Event: String {
        case display
    }
}

// MARK: Message data

private extension MenuComponent {
    struct MessageData: Decodable {
        let title: String
        let items: [Item]
    }

    struct Item: Decodable {
        let title: String
        let index: Int
    }

    struct SelectionMessageData: Encodable {
        let selectedIndex: Int
    }
}
