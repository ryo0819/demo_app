import SwiftUI
import Foundation
import Combine

class StationViewModel: ObservableObject {
    private var allStations: [Station] = []
    @Published var filteredStations: [Station] = []
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedStations: [Station] = loadJson("custom_station.json")
            DispatchQueue.main.async {
                self.allStations = loadedStations
                self.filteredStations = []
            }
        }
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.performFilter(with: text)
            }
            .store(in: &cancellables)
    }

    private func performFilter(with text: String) {
        if text.isEmpty {
            filteredStations = []
            return
        }

        DispatchQueue.global(qos: .userInteractive).async {
            let query = text.lowercased()
            let kanaQuery = query.applyingTransform(.hiraganaToKatakana, reverse: true) ?? query
            let result = self.allStations.filter { station in
                station.name.localizedCaseInsensitiveContains(query) ||
                station.nameKana.localizedCaseInsensitiveContains(kanaQuery)
            }

            DispatchQueue.main.async {
                self.filteredStations = Array(result.prefix(50))
            }
        }
    }
}
