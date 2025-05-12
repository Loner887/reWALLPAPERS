import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private var categories: [String] = []
    private var collectionView: UICollectionView!
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Categories"
        view.backgroundColor = UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1)

        setupSearchBar()
        setupCollectionView()
        
        categories = Array(Set(WallpaperDataSource.shared.allWallpapers.flatMap { $0.categories })).sorted()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Categories"
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
        layout.itemSize = CGSize(width: 360, height: 264)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.backgroundColor = UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 250, right: 20)
        
        view.addSubview(collectionView)
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let vc = WallpapersCategoryViewController()
        vc.category = category
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            categories = Array(Set(WallpaperDataSource.shared.allWallpapers.flatMap { $0.categories })).sorted()
        } else {
            categories = Array(Set(WallpaperDataSource.shared.allWallpapers.flatMap { $0.categories }))
                .filter { $0.lowercased().contains(searchText.lowercased()) }
                .sorted()
        }
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let categoryImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let backgroundLabel = UILabel()
    private let backgroundImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Настройка фонового изображения
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.cornerRadius = 10
        backgroundImage.image = UIImage(named: "categoriesImage")
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundImage)
        contentView.sendSubviewToBack(backgroundImage)
        
        // Лейбл "Background"
        backgroundLabel.text = "Background"
        backgroundLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        backgroundLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundLabel)
        
        categoryImageView.contentMode = .scaleAspectFill
        categoryImageView.clipsToBounds = true
        categoryImageView.layer.cornerRadius = 10
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryImageView)
        
        // Настройка лейбла категории
        categoryLabel.textAlignment = .left
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 36)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryImageView.heightAnchor.constraint(equalToConstant: 150),
            
            backgroundLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.bottomAnchor.constraint(equalTo: backgroundLabel.topAnchor, constant: -8),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentView.bringSubviewToFront(categoryImageView)
        contentView.bringSubviewToFront(categoryLabel)
        contentView.bringSubviewToFront(backgroundLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: String) {
        categoryLabel.text = category
        categoryImageView.image = UIImage(named: category)
    }
}
