import UIKit
import SafariServices

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var movieId: Int
    private var movie: MovieDetail?

    // 🔹 UI элементы
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let yearLabel = UILabel()
    private let durationLabel = UILabel()
    private let genreLabel = UILabel()
    private let ratingLabel = UILabel()
    private let posterImageView = UIImageView()
    private let favoriteButton = UIButton()
    private let carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let trailerButton = UIButton()

    private var carouselImages: [String] = []
    private var trailerURL: String?

    // 🔹 Инициализатор
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMovieDetails()
        carouselCollectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
    }

    // ✅ Метод 1: Количество элементов
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselImages.count
    }

    // ✅ Метод 2: Настройка ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        let imageUrl = carouselImages[indexPath.item]

        if let url = URL(string: imageUrl) {
            cell.setImage(from: url)
        }

        return cell
    }

    /// 🔹 Загружаем данные о фильме по ID
    private func fetchMovieDetails() {
        let urlString = "https://kudago.com/public-api/v1.4/movies/\(movieId)/"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let decoder = JSONDecoder()
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                DispatchQueue.main.async {
                    self?.updateUI(with: movieDetail)
                }
            } catch {
                print("Ошибка декодирования: \(error)")
            }
        }.resume()
    }

    /// 🔹 Обновляем UI после загрузки данных
    private func updateUI(with movie: MovieDetail) {
        self.movie = movie

        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
        yearLabel.text = "\(movie.year)"
        durationLabel.text = "\(movie.duration ?? 0) Minutes"
        genreLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        ratingLabel.text = "\(movie.rating ?? 0.0)"

        if let posterURL = movie.poster?.image, let url = URL(string: posterURL) {
            loadImage(from: url, into: posterImageView)
        }

        if let trailerURL = movie.trailer {
            self.trailerButton.isHidden = false
            self.trailerURL = trailerURL
        } else {
            self.trailerButton.isHidden = true
        }

        // Преобразуем массив объектов Image в массив строк
        self.carouselImages = movie.images.map { $0.image }
        self.carouselCollectionView.reloadData()
    }

    /// 🔹 Функция загрузки изображений
    private func loadImage(from url: URL, into imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }

    /// 🔹 Настройка UI
    private func setupUI() {
        view.backgroundColor = .black

        // Настройка ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Настройка Poster
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)

        // Настройка Title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Настройка YearLabel
        yearLabel.textColor = .white
        yearLabel.font = UIFont.systemFont(ofSize: 14)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(yearLabel)

        // Настройка DurationLabel
        durationLabel.textColor = .white
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(durationLabel)

        // Настройка GenreLabel
        genreLabel.textColor = .white
        genreLabel.font = UIFont.systemFont(ofSize: 14)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genreLabel)

        // Настройка RatingLabel
        ratingLabel.textColor = .white
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingLabel)

        // Настройка DescriptionLabel
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        // Настройка FavoriteButton
        favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        favoriteButton.tintColor = .white
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)

        // Настройка TrailerButton
        trailerButton.setTitle("Watch Trailer", for: .normal)
        trailerButton.backgroundColor = .red
        trailerButton.layer.cornerRadius = 8
        trailerButton.isHidden = true
        trailerButton.addTarget(self, action: #selector(openTrailer), for: .touchUpInside)
        trailerButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trailerButton)

        // Настройка CollectionView (Карусель)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 225)
        layout.minimumLineSpacing = 10
        carouselCollectionView.collectionViewLayout = layout
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.backgroundColor = .black
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(carouselCollectionView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 400),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            durationLabel.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 10),
            durationLabel.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor),

            genreLabel.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: 10),
            genreLabel.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor),

            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ratingLabel.centerYAnchor.constraint(equalTo: yearLabel.centerYAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            favoriteButton.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -10),

            trailerButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            trailerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trailerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trailerButton.heightAnchor.constraint(equalToConstant: 44),

            carouselCollectionView.topAnchor.constraint(equalTo: trailerButton.bottomAnchor, constant: 20),
            carouselCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: 225),
            carouselCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Добавлено для прокрутки
        ])
    }

    /// 🔹 Добавить в избранное
    @objc private func addToFavorites() {
        print("Добавлено в избранное")
    }

    /// 🔹 Открыть трейлер
    @objc private func openTrailer() {
        if let urlString = trailerURL, let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
}
