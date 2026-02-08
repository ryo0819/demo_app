import Foundation
import CoreLocation
import SwiftUI
import Combine

// @MainActor: このクラスの Published 変数への書き込みをメインスレッドに限定する
@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation? = nil
    @Published var locationError: String? = nil
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var locations: [CLLocationCoordinate2D] = []
    override init() {
        // 現在のステータスで初期化
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    // 権限が変わった時に呼ばれる最新のメソッド名
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            self.locationError = "位置情報の権限がありません。"
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            self.location = lastLocation
            self.locations.append(lastLocation.coordinate)
            self.locationError = nil
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError = error.localizedDescription
    }
}
