import SwiftUI

struct StationListView: View {
    @StateObject private var viewModel = StationViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.filteredStations, id: \.id) { station in
                NavigationLink(value: station) {
                    Text(station.name)
                        .font(.headline)
                    Text(station.nameKana)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("駅一覧")
            .searchable(text: $viewModel.searchText, prompt: "駅名で検索")
            
            .navigationDestination(for: Station.self) { station in
                StationDetailView(station: station)
            }
        }
    }
}

#Preview {
    StationListView()
}
