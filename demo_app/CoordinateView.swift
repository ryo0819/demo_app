import SwiftUI
import CoreLocation
import MapKit
//struct CoordinateView: View {
//    @StateObject private var locationManager = LocationManager()
//    // 初期値を .userLocation にすることで、自分の位置を追跡します
//    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
////    var body: some View {
//        ZStack(alignment: .bottomTrailing) { // ボタンを右下に浮かせるためにZStackを使用
//            VStack(spacing: 0) {
//                if !locationManager.locations.isEmpty {
//                    Map(position: $position) {
//                        MapPolyline(coordinates: locationManager.locations)
//                            .stroke(.blue, lineWidth: 5)
//                        UserAnnotation()
//                    }
//                    .mapControls {
//                        MapCompass()
//                    }
//                } else if let error = locationManager.locationError {
//                    Text("位置情報の取得に失敗しました: \(error)")
//                        .foregroundColor(.red)
//                        .onAppear {
//                            print("Error occurred: \(error)")
//                        }
//                } else {
//                    Text("位置情報を取得中...")
//                        .onAppear {
//                            print("Waiting for location data...")
//                        }
//                }
//            }
////            // 操作ボタン類
//            VStack(spacing: 16) {
//                // リセットボタン
//                Button(action: { locationManager.locations.removeAll() }) {
//                    Image(systemName: "trash")
//                        .font(.title2)
//                        .padding()
//                        .background(.white)
//                        .clipShape(Circle())
//                        .shadow(radius: 4)
//                }
////                // 現在地へフォーカスを戻すボタン
//                Button(action: {
//                    withAnimation {
//                        position = .userLocation(fallback: .automatic)
//                    }
//                }) {
//                    Image(systemName: "location.fill")
//                        .font(.title2)
//                        .padding()
//                        .background(.blue)
//                        .foregroundColor(.white)
//                        .clipShape(Circle())
//                        .shadow(radius: 4)
//                }
//            }
//            .padding()
//        }
//    }
//}


struct CoordinateView: View {
    @StateObject private var locationManager = LocationManager()
    // 現在地に自動追従する設定
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    var body: some View {
        ZStack(alignment: .top) {
            // 1. 地図表示（画面全体）
            Map(position: $position) {
                // 軌跡を描画
                MapPolyline(coordinates: locationManager.locations)
                    .stroke(.blue, lineWidth: 5)
                // 現在地の青い丸を表示
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            // 2. 現在の座標表示パネル（上部に浮かせる）
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
                        .background(.ultraThinMaterial) // すりガラス効果
                        .cornerRadius(12)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 50) // ノッチ（Dynamic Island）を避けるためのマージン
                }

                VStack {
                    Spacer() // 上から下に押し出す
                    HStack {
                        Spacer() // 左から右に押し出す
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
            // 権限エラーがある場合の表示
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
        // 必要に応じてカメラも現在地へ戻す
        position = .userLocation(followsHeading: true, fallback: .automatic)
    }
}

#Preview {
    CoordinateView()
}
