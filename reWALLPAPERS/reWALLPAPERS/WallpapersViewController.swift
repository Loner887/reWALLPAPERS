import UIKit

class WallpapersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private var allWallpapers: [Wallpaper] = []
    private var filteredWallpapers: [Wallpaper] = []
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wallpapers"
        
        setupSearchBar()
        setupCollectionView()
        loadWallpapers()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Iphone"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .white
        searchBar.isTranslucent = false
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
        }
        
        navigationItem.titleView = searchBar
    }
    
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 250)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(red: 49/255, green: 49/255, blue: 49/255, alpha: 1)
        collectionView.register(WallpaperCell.self, forCellWithReuseIdentifier: "WallpaperCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 250, right: 20)
        view.addSubview(collectionView)
    }
    
    private func loadWallpapers() {
        let favorites = FavoritesManager.shared.getFavorites()
        
        allWallpapers = WallpaperDataSource.shared.allWallpapers.map { wallpaper in
            var updated = wallpaper
            updated.isFavorite = favorites.contains(wallpaper.id)
            return updated
        }
        
        filteredWallpapers = allWallpapers
        collectionView.reloadData()
    }
    
    
    // MARK: - UICollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredWallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
        cell.configure(with: filteredWallpapers[indexPath.item])
        cell.favoriteButtonTapped = { [weak self] in
            self?.toggleFavorite(at: indexPath.item)
        }
        return cell
    }
    
    private func toggleFavorite(at index: Int) {
        let id = filteredWallpapers[index].id
        let isFavorite = filteredWallpapers[index].isFavorite
        
        if isFavorite {
            FavoritesManager.shared.removeFavorite(id: id)
        } else {
            FavoritesManager.shared.addFavorite(id: id)
        }
        
        filteredWallpapers[index].isFavorite.toggle()
        
        if let realIndex = allWallpapers.firstIndex(where: { $0.id == id }) {
            allWallpapers[realIndex].isFavorite = filteredWallpapers[index].isFavorite
        }
        
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wallpaper = filteredWallpapers[indexPath.item]
        let detailVC = WallpaperDetailViewController(wallpaper: wallpaper)
        detailVC.hidesBottomBarWhenPushed = true
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredWallpapers = allWallpapers
        } else {
            filteredWallpapers = allWallpapers.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
        
    }
}
