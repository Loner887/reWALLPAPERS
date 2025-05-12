import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    private var favoriteWallpapers: [Wallpaper] = []
    private var filteredFavorites: [Wallpaper] = []
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        
        setupSearchBar()
        setupCollectionView()
        loadFavorites()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites() 
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Favorites"
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
        collectionView.backgroundColor = UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1)
        collectionView.register(WallpaperCell.self, forCellWithReuseIdentifier: "WallpaperCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 250, right: 20)
        view.addSubview(collectionView)
    }
    
    private func loadFavorites() {
        let favorites = FavoritesManager.shared.getFavorites()
        favoriteWallpapers = WallpaperDataSource.shared.allWallpapers
            .filter { favorites.contains($0.id) }
            .map { wallpaper in
                var updated = wallpaper
                updated.isFavorite = true
                return updated
            }
        filteredFavorites = favoriteWallpapers
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFavorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
        cell.configure(with: filteredFavorites[indexPath.item])
        cell.favoriteButtonTapped = { [weak self] in
            self?.removeFavorite(at: indexPath.item)
        }
        return cell
    }
    
    private func removeFavorite(at index: Int) {
        let id = filteredFavorites[index].id
        FavoritesManager.shared.removeFavorite(id: id)
        
        if let favoriteIndex = favoriteWallpapers.firstIndex(where: { $0.id == id }) {
            favoriteWallpapers.remove(at: favoriteIndex)
        }
        filteredFavorites.remove(at: index)
        
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wallpaper = filteredFavorites[indexPath.item]
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
            filteredFavorites = favoriteWallpapers
        } else {
            filteredFavorites = favoriteWallpapers.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
