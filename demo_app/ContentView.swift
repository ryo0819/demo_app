import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CoordinateView()
                .tabItem {
                    Label("マップ", systemImage: "map")
                }
            StationListView()
                .tabItem {
                    Label("駅一覧", systemImage: "tram")
                }
            ClockView()
                .tabItem {
                    Label("時計", systemImage: "clock")
                }
        }
    }
}

#Preview {
    ContentView()
}
