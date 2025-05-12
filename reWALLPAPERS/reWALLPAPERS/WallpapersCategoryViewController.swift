import UIKit

class WallpapersCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var category: String = ""
    private var wallpapers: [Wallpaper] = []
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1)
        title = category
        
        wallpapers = WallpaperDataSource.shared.allWallpapers.filter { $0.categories.contains(category) }
        
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 250)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 250, right: 20)
        collectionView.register(WallpaperCell.self, forCellWithReuseIdentifier: "WallpaperCell")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedWallpaper = wallpapers[indexPath.item]
        let detailVC = WallpaperDetailViewController(wallpaper: selectedWallpaper)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallpapers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wallpaper = wallpapers[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
        cell.configure(with: wallpaper)
        return cell
    }
}
