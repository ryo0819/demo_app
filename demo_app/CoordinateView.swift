import SwiftUI
import CoreLocation
import MapKit


struct CoordinateView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position) {
                MapPolyline(coordinates: locationManager.locations)
                    .stroke(.blue, lineWidth: 5)
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            if let lastLoc = locationManager.location {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("現在の位置")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "緯度: %.6f", lastLoc.coordinate.latitude))
                            Text(String(format: "経度: %.6f", lastLoc.coordinate.longitude))
                        }
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: resetPath) {
                            Image(systemName: "trash")
                                .font(.title2)
                                .padding()
                                .background(.white)
                                .foregroundColor(.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 40)
                }
            }
            if let error = locationManager.locationError {
                Text(error)
                    .padding()
                    .background(.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 100)
            }
        }
    }
    private func resetPath() {
        locationManager.locations.removeAll()
        position = .userLocation(followsHeading: true, fallback: .automatic)
    }
}

#Preview {
    CoordinateView()
}
