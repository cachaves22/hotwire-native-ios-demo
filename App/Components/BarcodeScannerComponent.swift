//
//  BarcodeScannerComponent.swift
//  
//
//  Created by Camila Souza on 3/27/25.
//


import HotwireNative
import UIKit
import VisionKit

final class BarcodeScannerComponent: BridgeComponent {
    override class var name: String { "barcode-scanner" }

    private var viewController: UIViewController? {
        delegate.destination as? UIViewController
    }

    private lazy var scanner = DataScannerViewController(
        recognizedDataTypes: [
            .barcode(symbologies: [.qr, .ean8, .ean13, .pdf417, .code128])
        ]
    )

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else { return }
        switch event {
        case .scan:
            scan()
        }
    }

    private func scan() {
        if DataScannerViewController.isAvailable, DataScannerViewController.isSupported {
            presentScanner()
        } else {
            let alert = UIAlertController(
                title: "Data scanning not supported",
                message: "This component only works on a physical device.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            viewController?.present(alert, animated: true)
        }
    }

    private func presentScanner() {
        scanner.delegate = self
        scanner.view.backgroundColor = .black

        let navigationController = UINavigationController(rootViewController: scanner)
        viewController?.present(navigationController, animated: true)

        addCancelButton()

        do {
            try scanner.startScanning()
        } catch {
            print("Failed to start scanning: \(error.localizedDescription)")
        }
    }

    private func addCancelButton() {
        let action = UIAction { [weak self] _ in
            self?.stopScanningAndDismiss()
        }

        scanner.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            primaryAction: action
        )
    }

    private func stopScanningAndDismiss() {
        scanner.stopScanning()
        scanner.dismiss(animated: true)
    }
}

extension BarcodeScannerComponent: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        guard
            let item = addedItems.first,
            case let .barcode(barcode) = item,
            let payload = barcode.payloadStringValue
        else { return }

        stopScanningAndDismiss()

        reply(to: Event.scan.rawValue, with: ScanMessageData(barcode: payload))
    }
}

private extension BarcodeScannerComponent {
    enum Event: String {
        case scan
    }

    struct ScanMessageData: Encodable {
        let barcode: String
    }
}
