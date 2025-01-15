//
//  MovieDetailViewController.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie? {
        didSet {
            populateData()
            setupFavoriteButton()
        }
    }
    
    private let backgroundPosterImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let durationLabel = UILabel()
    private let genreLabel = UILabel()

    private let segmentedControl = UISegmentedControl(items: ["Описание", "Отзывы"])
    private let descriptionLabel = UILabel()
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let backButton = UIButton()
    
    private var favoriteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "back")
        
        setupNavigationBar()
        setupUI()
        setupConstraints()
        populateData()
        
        if let movie = movie {
            fetchMovieDetails(movieID: movie.id)
        } else {
            print("Movie is nil")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBarAppearance()
    }
    
    
    private func setupNavigationBar() {
        self.navigationItem.hidesBackButton = true
        
        let backImage = UIImage(named: "arrow")?.withRenderingMode(.alwaysOriginal)
        backButton.setImage(backImage, for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [negativeSpacer, backBarButton]
        
                self.navigationItem.title = "Details"
                
                if let navigationBar = self.navigationController?.navigationBar {
                    navigationBar.titleTextAttributes = [
                        .foregroundColor: UIColor.white,
                        .font: UIFont.boldSystemFont(ofSize: 20)
                    ]
                    navigationBar.barTintColor = UIColor(named: "back")
                    navigationBar.isTranslucent = false
                }
        
        setupFavoriteButton()
    }
    
    
    private func setupFavoriteButton() {
        guard let movie = movie else { return }
        let movieID = movie.id
        let favoriteImageName = WatchlistManager.shared.isInWatchlist(movieID: movieID) ? "bookmark.fill" : "bookmark"
        let favoriteImage = UIImage(systemName: favoriteImageName)
        
        favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))
        self.navigationItem.rightBarButtonItem = favoriteButton
    }
    
    @objc private func favoriteButtonTapped() {
        guard let movie = movie else { return }
        let movieID = movie.id
        
        if WatchlistManager.shared.isInWatchlist(movieID: movieID) {
            WatchlistManager.shared.removeFromWatchlist(movieID: movieID)
            print("Removed movie ID \(movieID) from watchlist")
        } else {
            WatchlistManager.shared.addToWatchlist(movieID: movieID)
            print("Added movie ID \(movieID) to watchlist")
        }
        
        updateFavoriteButton()
        
        NotificationCenter.default.post(name: .watchlistUpdated, object: nil)
    }
    
    @objc private func backButtonTapped() {
            navigationController?.popViewController(animated: true)
        }
    
    private func updateFavoriteButton() {
        guard let movie = movie else { return }
        let movieID = movie.id
        let favoriteImageName = WatchlistManager.shared.isInWatchlist(movieID: movieID) ? "bookmark.fill" : "bookmark"
        let favoriteImage = UIImage(systemName: favoriteImageName)
        favoriteButton.image = favoriteImage
        print("Updated favorite button to \(favoriteImageName)")
    }
    
    
    private func configureNavigationBarAppearance() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "back")
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        appearance.buttonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -1000, vertical: 0)
        appearance.buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        
        navigationBar.tintColor = .white
    }
    
    
    private func setupUI() {
        backgroundPosterImageView.contentMode = .scaleAspectFill
        backgroundPosterImageView.clipsToBounds = true
        backgroundPosterImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundPosterImageView)
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(posterImageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        yearLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        yearLabel.textColor = .lightGray
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        durationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        durationLabel.textColor = .lightGray
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        genreLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        genreLabel.textColor = .lightGray
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoStackView.axis = .horizontal
        infoStackView.alignment = .center
        infoStackView.spacing = 16
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoStackView)
        
        let yearStack = createInfoStack(iconName: "calendar", label: yearLabel)
        let durationStack = createInfoStack(iconName: "clock", label: durationLabel)
        let genreStack = createInfoStack(iconName: "tag", label: genreLabel)
        
        infoStackView.addArrangedSubview(yearStack)
        infoStackView.addArrangedSubview(durationStack)
        infoStackView.addArrangedSubview(genreStack)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        view.addSubview(infoStackView)
    }
    
    
    private func createInfoStack(iconName: String, label: UILabel) -> UIStackView {
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = .lightGray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        let stack = UIStackView(arrangedSubviews: [iconImageView, label])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundPosterImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundPosterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundPosterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundPosterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            posterImageView.topAnchor.constraint(equalTo: backgroundPosterImageView.bottomAnchor, constant: -60),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundPosterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            infoStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            segmentedControl.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            descriptionLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    
    private func populateData() {
        guard let movie = movie else {
            print("Movie is nil")
            return
        }
        
        titleLabel.text = movie.title

            infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            if let year = movie.year {
                let yearStack = createInfoItem(iconName: "calendar", text: "\(year)")
                infoStackView.addArrangedSubview(yearStack)
            }

            if let duration = movie.running_time {
                let durationStack = createInfoItem(iconName: "clock", text: "\(duration) мин")
                infoStackView.addArrangedSubview(durationStack)
            }

            if let genres = movie.genres, !genres.isEmpty {
                let genreNames = genres.map { $0.name }.joined(separator: ", ")
                let genreStack = createInfoItem(iconName: "tag", text: genreNames)
                infoStackView.addArrangedSubview(genreStack)
            }

            descriptionLabel.text = movie.body_text?.htmlToPlainText() ?? "Описание недоступно"
        
        if let posterURL = URL(string: movie.poster.image) {
            loadImage(from: posterURL, into: posterImageView)
            loadImage(from: posterURL, into: backgroundPosterImageView)
        } else {
            print("Poster URL is nil или неверный")
            posterImageView.image = UIImage(named: "defaultPoster")
            backgroundPosterImageView.image = UIImage(named: "defaultPoster")
        }
        
        if let firstImageURLString = movie.images?.first?.image, let backgroundPosterURL = URL(string: firstImageURLString) {
                loadImage(from: backgroundPosterURL, into: backgroundPosterImageView)
            } else {
                print("No images available or invalid URL for background poster")
                backgroundPosterImageView.image = UIImage(named: "defaultPoster")
            }
    }
    private func createInfoItem(iconName: String, text: String) -> UIStackView {
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = .lightGray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])

        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }

    
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "defaultPoster")
                }
                return
            }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    
    private func fetchMovieDetails(movieID: Int) {
        let urlString = "https://kudago.com/public-api/v1.4/movies/\(movieID)/"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching movie details: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let detailedMovie = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    self.movie = detailedMovie
                    self.populateData()
                    print("Fetched detailed movie: \(detailedMovie)")
                }
            } catch {
                print("Error decoding movie details: \(error)")
            }
        }.resume()
    }
    
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            descriptionLabel.isHidden = false
        case 1:
            descriptionLabel.isHidden = true
        default:
            break
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension String {
    func htmlToPlainText() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        return attributedString.string
    }
}


extension Notification.Name {
    static let watchlistUpdateds = Notification.Name("watchlistUpdated")
}
