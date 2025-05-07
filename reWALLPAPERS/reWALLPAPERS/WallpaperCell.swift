import UIKit

class WallpaperCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let backgroundLabel = UILabel()
    private let favoriteButton = UIButton()

    var favoriteButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with wallpaper: Wallpaper) {
        imageView.image = UIImage(named: wallpaper.imageName)
        titleLabel.text = wallpaper.title
        backgroundLabel.text = "background"
        
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let heartImage = wallpaper.isFavorite
            ? UIImage(systemName: "heart.fill", withConfiguration: config)
            : UIImage(systemName: "heart", withConfiguration: config)
        favoriteButton.setImage(heartImage, for: .normal)
        
    }

    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        backgroundLabel.textColor = .white
        backgroundLabel.font = UIFont.systemFont(ofSize: 12)

        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

        favoriteButton.tintColor = .white
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.tintColor = .white
        favoriteButton.imageView?.contentMode = .scaleAspectFit // чтобы изображение не урезалось
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        let overlay = UIStackView(arrangedSubviews: [titleLabel, backgroundLabel])
        overlay.axis = .vertical
        overlay.alignment = .leading
        overlay.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(overlay)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            overlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            overlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 35),
            favoriteButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }

    @objc private func favoriteTapped() {
        favoriteButtonTapped?()
    }
}
