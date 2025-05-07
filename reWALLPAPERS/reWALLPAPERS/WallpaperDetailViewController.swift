import UIKit
import CoreImage

class WallpaperDetailViewController: UIViewController {

    private var wallpaper: Wallpaper
    private let imageView = UIImageView()
    private let favoriteButton = UIButton(type: .system)
    private let brightnessSlider = UISlider()
    private let colorSlider = UISlider()

    init(wallpaper: Wallpaper) {
        self.wallpaper = wallpaper
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.searchController = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ("Iphone / \(wallpaper.title)")
        setupBlurredBackground()
        setupUI()
        updateImage()
        loadSliders()
    }

    private func setupBlurredBackground() {
        guard let image = UIImage(named: wallpaper.imageName),
              let ciImage = CIImage(image: image) else { return }

        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(50.0, forKey: kCIInputRadiusKey) // Увеличь радиус для большего блюра

        let context = CIContext()
        guard let output = blurFilter?.outputImage,
              let cgImage = context.createCGImage(output, from: ciImage.extent) else { return }

        let blurredImage = UIImage(cgImage: cgImage)
        let backgroundImageView = UIImageView(image: blurredImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }


    private func setupUI() {
        view.backgroundColor = .black

        imageView.image = UIImage(named: wallpaper.imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        favoriteButton.setImage(UIImage(systemName: wallpaper.isFavorite ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoriteButton)

        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 1
        brightnessSlider.value = 0.5
        brightnessSlider.addTarget(self, action: #selector(updateImage), for: .valueChanged)
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brightnessSlider)

        colorSlider.minimumValue = -1
        colorSlider.maximumValue = 1
        colorSlider.value = 0
        colorSlider.addTarget(self, action: #selector(updateImage), for: .valueChanged)
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorSlider)

        let acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.backgroundColor = .white
        acceptButton.setTitleColor(.black, for: .normal)
        acceptButton.layer.cornerRadius = 10
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.addTarget(self, action: #selector(setAsWallpaper), for: .touchUpInside)
        view.addSubview(acceptButton)

        let resetButton = UIButton(type: .system)
        resetButton.setTitle("", for: .normal)
        resetButton.setImage(UIImage(named: "resetButtonImage"), for: .normal)
        resetButton.tintColor = .black
        resetButton.backgroundColor = .white
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.layer.cornerRadius = 10
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetSliders), for: .touchUpInside)
        view.addSubview(resetButton)

        let saveButton = UIButton(type: .system)
        saveButton.setTitle(" Change Theme", for: .normal)
        saveButton.setImage(UIImage(named: "saveButtonImage"), for: .normal)
        saveButton.tintColor = .black
        saveButton.backgroundColor = .white
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveSliders), for: .touchUpInside)
        view.addSubview(saveButton)

        
        let brightnessLabel = UILabel()
        brightnessLabel.text = "Brightness"
        brightnessLabel.textColor = .white
        brightnessLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        brightnessLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brightnessLabel)

        let colorLabel = UILabel()
        colorLabel.text = "Color correction"
        colorLabel.textColor = .white
        colorLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 55),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -55),
            imageView.heightAnchor.constraint(equalToConstant: 420),
            
            saveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            saveButton.trailingAnchor.constraint(equalTo: resetButton.leadingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 53),

            resetButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            resetButton.widthAnchor.constraint(equalToConstant: 53),
            resetButton.heightAnchor.constraint(equalToConstant: 53),

            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -12),

            brightnessLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 15),
            brightnessLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),

            brightnessSlider.topAnchor.constraint(equalTo: brightnessLabel.bottomAnchor, constant: 5),
            brightnessSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            brightnessSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),

            colorLabel.topAnchor.constraint(equalTo: brightnessSlider.bottomAnchor, constant: 20),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),

            colorSlider.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 5),
            colorSlider.leadingAnchor.constraint(equalTo: brightnessSlider.leadingAnchor),
            colorSlider.trailingAnchor.constraint(equalTo: brightnessSlider.trailingAnchor),

            acceptButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            acceptButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -55),
            acceptButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 55),
            acceptButton.heightAnchor.constraint(equalToConstant: 47)
        ])
    }

    @objc private func toggleFavorite() {
        wallpaper.isFavorite.toggle()
        if wallpaper.isFavorite {
            FavoritesManager.shared.addFavorite(id: wallpaper.id)
        } else {
            FavoritesManager.shared.removeFavorite(id: wallpaper.id)
        }
        favoriteButton.setImage(UIImage(systemName: wallpaper.isFavorite ? "heart.fill" : "heart"), for: .normal)
    }

    @objc private func updateImage() {
        guard let originalImage = UIImage(named: wallpaper.imageName) else { return }

        let brightness = CGFloat(brightnessSlider.value)
        let colorShift = CGFloat(colorSlider.value)

        guard let ciImage = CIImage(image: originalImage) else { return }

        let colorControls = CIFilter(name: "CIColorControls")
        colorControls?.setValue(ciImage, forKey: kCIInputImageKey)
        colorControls?.setValue(brightness - 0.5, forKey: kCIInputBrightnessKey)

        let hueAdjust = CIFilter(name: "CIHueAdjust")
        hueAdjust?.setValue(colorControls?.outputImage, forKey: kCIInputImageKey)
        hueAdjust?.setValue(colorShift * .pi, forKey: kCIInputAngleKey)

        if let output = hueAdjust?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(output, from: output.extent) {
                imageView.image = UIImage(cgImage: cgImage)
            }
        }
    }

    @objc private func resetSliders() {
        brightnessSlider.value = 0.5
        colorSlider.value = 0
        updateImage()
        
        let defaults = UserDefaults.standard
        defaults.set(0.5, forKey: "savedBrightness")
        defaults.set(0.0, forKey: "savedColorShift")
        
        print("Слайдеры сброшены и значения сохранены в UserDefaults")
    }

    @objc private func saveSliders() {
        let brightness = brightnessSlider.value
        let colorShift = colorSlider.value
        
        let defaults = UserDefaults.standard
        defaults.set(brightness, forKey: "savedBrightness")
        defaults.set(colorShift, forKey: "savedColorShift")
        
        print("Сохранены значения в UserDefaults:")
        print("- Яркость: \(brightness)")
        print("- Цветовой сдвиг: \(colorShift)")
    }

    private func loadSliders() {
        let defaults = UserDefaults.standard
        
        let savedBrightness = defaults.float(forKey: "savedBrightness")
        let savedColorShift = defaults.float(forKey: "savedColorShift")
        
        brightnessSlider.value = savedBrightness
        colorSlider.value = savedColorShift
        
        print("Загружены значения из UserDefaults:")
        print("- Яркость: \(savedBrightness)")
        print("- Цветовой сдвиг: \(savedColorShift)")
    }
    
    @objc private func setAsWallpaper() {
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }

    @objc private func image(_ image: UIImage,
                           didFinishSavingWithError error: Error?,
                           contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Save Error",
                     message: "Could not save image: \(error.localizedDescription)")
        } else {
            showAlert(title: "Saved",
                     message: "Wallpaper saved to your photos. You can now set it from Settings.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        if let error = error {
            alert.title = "Ошибка"
            alert.message = error.localizedDescription
        } else {
            alert.title = "Сохранено"
            alert.message = "Изображение сохранено. Установите его как обои вручную через Фото."
        }
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
