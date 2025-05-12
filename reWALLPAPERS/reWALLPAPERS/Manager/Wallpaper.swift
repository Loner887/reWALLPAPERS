import UIKit

struct Wallpaper {
    let id: UUID
    let title: String
    let imageName: String
    var isFavorite: Bool
    let categories: [String]
}

enum WallpaperID {
    static let straw = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!
    static let sunrise = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174001")!
    static let flowers = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174002")!
    static let drops = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174003")!
    static let planet = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174004")!
    static let forest = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174005")!
    static let vulcan = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174006")!
    static let neon1 = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174007")!
    static let neon2 = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174008")!
    static let neon3 = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174009")!
    static let neon4 = UUID(uuidString: "123e4567-e89b-12d3-a456-426614174010")!
}
