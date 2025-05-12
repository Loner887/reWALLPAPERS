import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wallpapersVC = WallpapersViewController()
        let categoriesVC = CategoriesViewController()
        let favoritesVC = FavoritesViewController()
        
        wallpapersVC.tabBarItem = UITabBarItem(title: "Wallpapers", image: UIImage(named: "wallpapersTabBar"), tag: 0)
        categoriesVC.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(named: "categoriesTabBar"), tag: 1)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favoritesTabBar"), tag: 2)
        
        viewControllers = [wallpapersVC, categoriesVC, favoritesVC].map {
            UINavigationController(rootViewController: $0)
        }
        
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = UIColor.systemBlue
        tabBar.unselectedItemTintColor = UIColor.black
        
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 40
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let horizontalInset: CGFloat = 20
        let bottomInset: CGFloat = 30
        let height: CGFloat = 92

        let window = UIApplication.shared.windows.first
        let safeBottom = window?.safeAreaInsets.bottom ?? 0

        let width = view.bounds.width - (horizontalInset * 2)
        
        let adjustedBottomInset = bottomInset - 15
        
        tabBar.frame = CGRect(
            x: horizontalInset,
            y: view.bounds.height - height - adjustedBottomInset,
            width: width,
            height: height
        )

        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
    }
}
