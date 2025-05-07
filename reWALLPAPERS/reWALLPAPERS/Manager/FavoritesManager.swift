import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()

    private let key = "favoriteWallpapers"

    private init() {}

    func getFavorites() -> [UUID] {
        let strings = UserDefaults.standard.stringArray(forKey: key) ?? []
        return strings.compactMap { UUID(uuidString: $0) }
    }

    func isFavorite(id: String) -> Bool {
        guard let uuid = UUID(uuidString: id) else { return false }
        return getFavorites().contains(uuid)
    }

    func addFavorite(id: UUID) {
        var favorites = getFavorites()
        if !favorites.contains(id) {
            favorites.append(id)
            saveFavorites(favorites)
        }
    }

    func removeFavorite(id: UUID) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == id }
        saveFavorites(favorites)
    }

    private func saveFavorites(_ favorites: [UUID]) {
        let strings = favorites.map { $0.uuidString }
        UserDefaults.standard.set(strings, forKey: key)
    }
}
