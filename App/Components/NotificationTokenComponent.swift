import HotwireNative
import UIKit

/// Requires additional configuration. See the documentation for details.
/// https://github.com/joemasilotti/bridge-components/tree/main/components/notification-token
final class NotificationTokenComponent: BridgeComponent {
    override class var name: String { "notification-token" }

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else { return }

        switch event {
        case .connect:
            break // Empty event to start notification handling in onViewDidAppear().
        case .get:
            Task { await getToken() }
        }
    }

    override func onViewDidAppear() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receivedDeviceToken(via:)),
            name: .didReceiveDeviceToken,
            object: nil
        )
    }

    override func onViewDidDisappear() {
        NotificationCenter.default.removeObserver(
            self,
            name: .didReceiveDeviceToken,
            object: nil
        )
    }

    @objc private func receivedDeviceToken(via notification: Notification) {
        guard let tokenData = notification.object as? Data else { return }

        let token = tokenData.map { String(format: "%02x", $0) }.joined()
        reply(to: Event.get.rawValue, with: TokenMessageData(token: token))
    }

    private func getToken() async {
        do {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            if try await center.requestAuthorization(options: options) {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } catch {
            print("Error registering for notifications: \(error.localizedDescription)")
        }
    }
}

extension Notification.Name {
    static let didReceiveDeviceToken = Notification.Name("didReceiveDeviceToken")
}

private extension NotificationTokenComponent {
    enum Event: String {
        case connect
        case get
    }
}

private extension NotificationTokenComponent {
    struct TokenMessageData: Encodable {
        let token: String
    }
}
