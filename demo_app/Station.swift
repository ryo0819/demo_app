import Foundation
import CoreLocation

struct Station: Codable, Identifiable, Hashable {
    let id: Int
    let code: Int
    let prefecture: Int
    let name: String
    let nameKana: String
    let lines: [Int]
    let lat: Double
    let lng: Double

    enum CodingKeys: String, CodingKey {
        case id, code, prefecture, name, lines, lat, lng
        case nameKana = "name_kana"
    }
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
