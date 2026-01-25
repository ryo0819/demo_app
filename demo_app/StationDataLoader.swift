import Foundation

func loadJson<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("プロジェクト内に \(filename) が見つかりません")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("\(filename) の読み込みに失敗しました:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("\(filename) を \(T.self) に変換できませんでした:\n\(error)")
    }
}
