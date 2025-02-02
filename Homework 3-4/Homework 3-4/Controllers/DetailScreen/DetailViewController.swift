import UIKit
import CoreData
import SafariServices

final class DetailViewController: UIViewController {
    var film: Film!
    lazy var context = CoreDataManager.shared.viewContext

    private func createIconLabel(icon: String, color: UIColor) -> UIStackView {
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }
    
    private var ratingLabel: UIStackView!
    private var yearLabel: UIStackView!
    private var durationLabel: UIStackView!
    private var genreLabel: UIStackView!

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .white
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        return textView
    }()

    private let starsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Смотреть Трейлер", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.5)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Описание", "Актеры"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
        
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topStackView: UIStackView = {
        let infoStackView = UIStackView(arrangedSubviews: [titleLabel, ratingLabel, yearLabel, durationLabel, genreLabel])
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        infoStackView.alignment = .leading
        infoStackView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [posterImageView, infoStackView])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBlack
        setupNavigationBar()
        setupUI()

        Task {
            await loadFilmDetails()
        }

        trailerButton.addTarget(self, action: #selector(openTrailer), for: .touchUpInside)
    }

    private func setupNavigationBar() {
        navigationItem.title = "Подробная информация"

        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
        favoriteButton.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = favoriteButton
    }

    private func loadFilmDetails() async {
        do {
            if film.detailedFilm == nil {
                let detailedData = try await NetworkManager.shared.obtainFilmData(filmId: Int(film.id), for: film)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.configureUI()
                    self.imagesCollectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.configureUI()
                    self?.imagesCollectionView.reloadData()
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.showErrorAlert(message: "Failed to load film details. Please try again later.")
            }
        }
    }


    private func setupUI() {
        ratingLabel = createIconLabel(icon: "star.fill", color: .systemYellow)
        yearLabel = createIconLabel(icon: "calendar", color: .white)
        durationLabel = createIconLabel(icon: "clock", color: .white)
        genreLabel = createIconLabel(icon: "film", color: .white)
        
        if let genreTextLabel = genreLabel.arrangedSubviews[1] as? UILabel {
            genreTextLabel.numberOfLines = 2
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        contentView.addSubview(topStackView)
        contentView.addSubview(trailerButton)
        contentView.addSubview(imagesCollectionView)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(starsLabel)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            trailerButton.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 16),
            trailerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imagesCollectionView.topAnchor.constraint(equalTo: trailerButton.bottomAnchor, constant: 16),
            imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            segmentedControl.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            starsLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            starsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            starsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        
        descriptionTextView.isHidden = false
        starsLabel.isHidden = true
        
        posterImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }


    @MainActor
    private func configureUI() {
        titleLabel.text = film.title

        if let imageURLString = film.poster?.image, let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.posterImageView.image = UIImage(named: "default")
                    }
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self?.posterImageView.image = UIImage(named: "default")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            }.resume()
        } else {
            posterImageView.image = UIImage(named: "default")
        }
        
        (ratingLabel.arrangedSubviews[1] as? UILabel)?.text = "\(film.detailedFilm?.imdbRating?.doubleValue ?? 0.0)"
        (yearLabel.arrangedSubviews[1] as? UILabel)?.text = "\(film.detailedFilm?.year ?? 0)"
        (durationLabel.arrangedSubviews[1] as? UILabel)?.text = "\(film.detailedFilm?.runningTime ?? 0) мин."
        (genreLabel.arrangedSubviews[1] as? UILabel)?.text = film.detailedFilm?.genresArray.map { $0.name ?? "N/A" }.joined(separator: ", ") ?? "N/A"

        if let bodyText = film.detailedFilm?.bodyText {
            print("Начинаем парсинг bodyText: \(bodyText)")
            DispatchQueue.global(qos: .userInitiated).async {
                let completeHTML = """
                <html>
                    <head>
                        <meta charset="UTF-8">
                        <style>
                            body { font-family: -apple-system; font-size: 14px; color: white; background-color: transparent; }
                            a { color: #1E90FF; }
                        </style>
                    </head>
                    <body>
                        \(bodyText)
                    </body>
                </html>
                """
                if let data = completeHTML.data(using: .utf8) {
                    do {
                        let attributedString = try NSAttributedString(
                            data: data,
                            options: [
                                .documentType: NSAttributedString.DocumentType.html,
                                .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                            ],
                            documentAttributes: nil
                        )
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            if attributedString.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                self.descriptionTextView.text = "Описание не найдено"
                            } else {
                                self.descriptionTextView.attributedText = attributedString
                            }
                        }
                    } catch {
                        DispatchQueue.main.async { [weak self] in
                            self?.descriptionTextView.text = bodyText
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.descriptionTextView.text = bodyText
                    }
                }
            }
        } else {
            descriptionTextView.text = "Описание не найдено"
        }

        starsLabel.text = "В ролях: \(film.detailedFilm?.stars ?? "N/A")"

        updateFavoriteButton()
        imagesCollectionView.reloadData()
    }

    @MainActor
    @objc private func toggleFavorite() {
        guard let favoriteButton = navigationItem.rightBarButtonItem else { return }
        UIView.transition(with: favoriteButton.customView ?? UIView(),
                          duration: 0.3,
                          options: .transitionFlipFromTop,
                          animations: {
            self.film.isFavourite.toggle()
            self.updateFavoriteButton()
        }, completion: nil)

        do {
            try context.save()
        } catch {
            print("Failed to save favorite status: \(error)")
        }
    }
    
    @MainActor
    private func updateFavoriteButton() {
        guard let favoriteButton = navigationItem.rightBarButtonItem else { return }
        let isFavorite = film.isFavourite
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.image = UIImage(systemName: imageName)
    }

    @MainActor
    @objc private func openTrailer() {
        guard let trailerURLString = film.detailedFilm?.trailer, let url = URL(string: trailerURLString) else {
            let alert = UIAlertController(title: "Ошибка", message: "Trailer not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    @MainActor
    @objc private func segmentChanged() {
        let isDescriptionSelected = segmentedControl.selectedSegmentIndex == 0
        descriptionTextView.isHidden = !isDescriptionSelected
        starsLabel.isHidden = isDescriptionSelected
    }
    @MainActor
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (film.detailedFilm?.images?.allObjects as? [Image])?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Не удалось создать ячейку с идентификатором \(ImageCollectionViewCell.identifier)")
        }

        let imageArray = film.detailedFilm?.imagesArray ?? []

        guard indexPath.row < imageArray.count else {
            cell.configure(with: UIImage(named: "default") ?? UIImage())
            cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
            return cell
        }

        if let imageUrlString = imageArray[indexPath.row].image, let url = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Ошибка загрузки изображения коллекции: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        cell.configure(with: UIImage(named: "default") ?? UIImage())
                        cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
                    }
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        cell.configure(with: UIImage(named: "default") ?? UIImage())
                        cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
                    }
                    return
                }
                DispatchQueue.main.async {
                    cell.configure(with: image)
                    cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
                }
            }.resume()
        } else {
            cell.configure(with: UIImage(named: "default") ?? UIImage())
            cell.animateAppearance(delay: Double(indexPath.item) * 0.05)
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.animateSelection {
        }
    }

}
