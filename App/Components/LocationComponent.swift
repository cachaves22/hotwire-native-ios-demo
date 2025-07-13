//
//  LocationComponent.swift
//  
//
//  Created by Camila Souza on 3/27/25.
//


import CoreLocation
import HotwireNative

/// Requires additional configuration. See the documentation for details.
/// https://github.com/joemasilotti/bridge-components/tree/main/components/location
final class LocationComponent: BridgeComponent {
    override class var name: String { "location" }

    private let locationManager = CLLocationManager()
    private lazy var locationManagerDelegate = LocationManagerDelegate(component: self)

    override func onReceive(message: Message) {
        guard let event = Event(rawValue: message.event) else { return }

        switch event {
        case .get:
            getLocation()
        }
    }

    private func getLocation() {
        locationManager.delegate = locationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

private class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    private unowned let component: LocationComponent

    init(component: LocationComponent) {
        self.component = component
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let data = LocationComponent.LocationMessageData(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            Task { try await component.reply(to: LocationComponent.Event.get.rawValue, with: data) }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let data = LocationComponent.LocationMessageData(latitude: nil, longitude: nil)
        Task { try await component.reply(to: LocationComponent.Event.get.rawValue, with: data) }
    }
}

private extension LocationComponent {
    enum Event: String {
        case get
    }
}

private extension LocationComponent {
    struct LocationMessageData: Encodable {
        let latitude: Double?
        let longitude: Double?
    }
}
