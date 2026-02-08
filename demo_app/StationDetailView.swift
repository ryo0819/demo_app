import SwiftUI
import MapKit

struct StationDetailView: View {
    let station: Station
    @State private var position: MapCameraPosition
    init(station: Station) {
        self.station = station
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: station.location,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        ))
    }


    var body: some View {
        List {
            Section(header: Text("駅情報")) {
                LabeledContent("駅名", value: station.name)
                LabeledContent("読み", value: station.nameKana)
                LabeledContent("駅コード", value: "\(station.code)")
            }
            
            Section(header: Text("位置情報")) {
                LabeledContent("緯度", value: String(format: "%.6f", station.lat))
                LabeledContent("経度", value: String(format: "%.6f", station.lng))
                Map(position: $position) {
                    Marker(station.name, coordinate: station.location)
                }
                .frame(height: 250)
                .cornerRadius(10)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
            
            Section(header: Text("所属路線")) {
                Text(station.lines.map { String($0) }.joined(separator: ", "))
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle(station.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
