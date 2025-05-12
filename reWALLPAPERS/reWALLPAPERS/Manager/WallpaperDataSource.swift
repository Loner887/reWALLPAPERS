import Foundation

class WallpaperDataSource {
    static let shared = WallpaperDataSource()

    private(set) var allWallpapers: [Wallpaper] = []

    private init() {
        loadWallpapers()
    }

    private func loadWallpapers() {
        allWallpapers = [
            Wallpaper(id: WallpaperID.straw, title: "Straw", imageName: "straw", isFavorite: FavoritesManager.shared.isFavorite(id: "Straw"), categories: ["Nature"]),
            Wallpaper(id: WallpaperID.neon1, title: "Neon Vegas", imageName: "neon1", isFavorite: FavoritesManager.shared.isFavorite(id: "neon1"), categories: ["Neon"]),
            Wallpaper(id: WallpaperID.neon2, title: "Neon Man", imageName: "neon2", isFavorite: FavoritesManager.shared.isFavorite(id: "neon2"), categories: ["Neon"]),
            Wallpaper(id: WallpaperID.neon3, title: "Purple Chips", imageName: "neon3", isFavorite: FavoritesManager.shared.isFavorite(id: "neon3"), categories: ["Neon"]),
            Wallpaper(id: WallpaperID.planet, title: "Planet", imageName: "planet", isFavorite: FavoritesManager.shared.isFavorite(id: "Planet"), categories: ["Planet"]),
            Wallpaper(id: WallpaperID.forest, title: "Forest", imageName: "forest", isFavorite: FavoritesManager.shared.isFavorite(id: "Forest"), categories: ["Nature"]),
            Wallpaper(id: WallpaperID.vulcan, title: "Vulcan", imageName: "vulcan", isFavorite: FavoritesManager.shared.isFavorite(id: "Vulcan"), categories: ["Vulcan"]),
            Wallpaper(id: WallpaperID.sunrise, title: "Sunrise", imageName: "sunrise", isFavorite: FavoritesManager.shared.isFavorite(id: "Sunrise"), categories: ["Nature"]),
            Wallpaper(id: WallpaperID.flowers, title: "Flowers", imageName: "flowers", isFavorite: FavoritesManager.shared.isFavorite(id: "Flowers"), categories: ["Plants"]),
            Wallpaper(id: WallpaperID.drops, title: "Drops", imageName: "drops", isFavorite: FavoritesManager.shared.isFavorite(id: "Drops"), categories: ["Water"]),
            Wallpaper(id: WallpaperID.neon4, title: "Neon Town", imageName: "neon4", isFavorite: FavoritesManager.shared.isFavorite(id: "neon4"), categories: ["Neon"]),
        ]
    }

    func updateFavoriteStatus(for id: UUID, isFavorite: Bool) {
        if let index = allWallpapers.firstIndex(where: { $0.id == id }) {
            allWallpapers[index].isFavorite = isFavorite
        }
    }
}
