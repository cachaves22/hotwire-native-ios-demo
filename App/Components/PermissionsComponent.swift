//
//  PermissionsComponent.swift
//  
//
//  Created by Camila Souza on 3/27/25.
//

import AVFoundation
import CoreLocation
import HotwireNative
import UIKit

/// Requires additional configuration. See the documentation for details.
/// https://github.com/joemasilotti/bridge-components/tree/main/components/permissions
final class PermissionsComponent: BridgeComponent {
    override class var name: String { "permissions" }

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else { return }

        switch event {
        case .camera:
            getCameraStatus(via: event.rawValue)
        case .location:
            getLocationStatus(via: event.rawValue)
        case .notifications:
            getNotificationStatus(via: event.rawValue)
        }
    }

    private func getCameraStatus(via event: String) {
        let code: AuthorizationCode
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            code = .authorized
        case .restricted, .denied:
            code = .denied
        case .notDetermined:
            code = .notDetermined
        @unknown default:
            code = .unknown
        }

        reply(to: event, with: StatusMessageData(code: code))
    }

    private func getLocationStatus(via event: String) {
        let code: AuthorizationCode
        switch CLLocationManager().authorizationStatus {
        case .authorized, .authorizedWhenInUse, .authorizedAlways:
            code = .authorized
        case .denied, .restricted:
            code = .denied
        case .notDetermined:
            code = .notDetermined
        @unknown default:
            code = .unknown
        }

        reply(to: event, with: StatusMessageData(code: code))
    }

    private func getNotificationStatus(via event: String) {
        UNUserNotificationCenter.current().getNotificationSettings { [unowned self] settings in
            let code: AuthorizationCode
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                code = .authorized
            case .denied:
                code = .denied
            case .notDetermined:
                code = .notDetermined
            @unknown default:
                code = .unknown
            }

            reply(to: event, with: StatusMessageData(code: code))
        }
    }
}

private extension PermissionsComponent {
    enum Event: String {
        case camera
        case location
        case notifications
    }
}

private extension PermissionsComponent {
    struct StatusMessageData: Encodable {
        let code: Int
        let text: String

        init(code: AuthorizationCode) {
            self.code = code.rawValue

            switch code {
            case .authorized:
                self.text = "authorized"
            case .denied:
                self.text = "denied"
            case .notDetermined:
                self.text = "not determined"
            case .unknown:
                self.text = "unknown"
            }
        }
    }
}

private extension PermissionsComponent {
    enum AuthorizationCode: Int {
        case authorized = 1
        case denied = 0
        case notDetermined = -1
        case unknown = -2
    }
}
