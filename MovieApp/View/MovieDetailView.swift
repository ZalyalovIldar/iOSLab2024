import UIKit

protocol PlayTrailerDelegate: AnyObject {
    func play()
}

class MovieDetailView: UIView {
    
    private weak var delegate: PlayTrailerDelegate?
    private var prettyDescription: String!
    private let dataSource = ["Описание", "В ролях"]
    private var currentFilm: MovieWithInfo!
    private var selectedIndex = 0
    private var underlineWidth = UIScreen.main.bounds.width / 2 - Constants.tiny
    private var underlineLeadingConstraint: NSLayoutConstraint!
    private var underlineWidthConstraint: NSLayoutConstraint!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = Colors.mainGray
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .systemGray6
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var movieSnapsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.mainGray
        collectionView.register(MovieSnapsCollectionViewCell.self, forCellWithReuseIdentifier: MovieSnapsCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var movieAvatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = Constants.tiny
        return image
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: Fonts.big)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textAlignment = .left
        label.textColor = .white
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private lazy var playView: TrailerView = {
        let play = TrailerView()
        play.translatesAutoresizingMaskIntoConstraints = false
        return play
    }()
    
    private lazy var ratingView: MovieRatingView = {
        let ratingView = MovieRatingView()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    private lazy var ratingAndPlayerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            playView,
            ratingView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.ultraTiny
        return stack
    }()
    
    private lazy var specialInfoView: MovieInfoView = {
        let view = MovieInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieDescriptionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: Fonts.big)
        label.textColor = Colors.lighterGray
        label.text = "О фильме"
        return label
    }()
    
    // Collection view to display additional movie info such as cast, etc.
    private lazy var infoAndStarringCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(MovieInfoCollectionViewCell.self, forCellWithReuseIdentifier: MovieInfoCollectionViewCell.identifies)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Colors.mainGray
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 3 / 2
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    
    private lazy var movieDescriptionText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: Fonts.medium)
        label.textColor = .white
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var movieInfoAndStarsDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            infoAndStarringCollectionView,
            movieDescriptionText
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.ultraTiny
        return stack
    }()

    init(playTrailerDelegate: PlayTrailerDelegate) {
        super.init(frame: .zero)
        self.delegate = playTrailerDelegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Updates layout constraints dynamically when the view size changes.
    func updateLayout() {
        if let layout = movieSnapsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = self.bounds.width - safeAreaInsets.left - safeAreaInsets.right
            layout.itemSize = .init(width: itemWidth, height: itemWidth / 1.8)
            layout.invalidateLayout()
        }
        if let layout = infoAndStarringCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = (self.bounds.width - safeAreaInsets.left - safeAreaInsets.right) / 2 - Constants.tiny
            layout.itemSize = .init(width: itemWidth, height: Constants.little)
            underlineWidthConstraint.constant = itemWidth
            layout.invalidateLayout()
        }
        if selectedIndex == 1 {
            underlineLeadingConstraint.constant = (self.bounds.width - safeAreaInsets.right - safeAreaInsets.left) / 2
        }
    }
    
    // Sets up the view with the current movie data.
    func setUpWithFilm(_ film: MovieWithInfo) {
        currentFilm = film
        updateUI()
        
        loadingIndicator.startAnimating()
        movieAvatarImage.image = nil
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let image = try await ImageService.downloadImage(from: film.poster.image)
                loadingIndicator.stopAnimating()
                movieAvatarImage.image = image
            } catch {
                loadingIndicator.stopAnimating()
                movieAvatarImage.image = .failToLoad
                print("Error during loading \(film.title) avatar image: \(error.localizedDescription)")
            }
        }
    }
    
    func setDataSourceForFilmImagesCollectionView(with dataSource: MovieSnapsCollectionViewDataSource?) {
        if let dataSource {
            movieSnapsCollectionView.dataSource = dataSource
        }
    }
    
    
    func setDelegateForFilmImagesCollectionView(with delegate: MovieSnapsCollectionViewDelegate?) {
        if let delegate {
            movieSnapsCollectionView.delegate = delegate
        }
    }
    
    private func updateUI() {
        prettyDescription = makePretty(currentFilm.description)
        ratingView.setRating(rating: currentFilm.rating ?? 0.0)
        specialInfoView.setupWithMovie(currentFilm)
        movieTitleLabel.text = currentFilm.title
        updateFilmDescription()
    }
    
    private func updateFilmDescription() {
        if selectedIndex == 0 {
            movieDescriptionText.text = prettyDescription
        } else {
            movieDescriptionText.text = "    " + currentFilm.stars
        }
    }
    
    private func setup() {
        setupLayout()
        addPlayerGesture()
    }
    
    private func setupLayout() {
        backgroundColor = Colors.mainGray
        addSubview(scrollView)
        
        scrollView.addSubview(loadingIndicator)
        scrollView.addSubview(movieSnapsCollectionView)
        scrollView.addSubview(movieAvatarImage)
        scrollView.addSubview(movieTitleLabel)
        scrollView.addSubview(ratingAndPlayerStackView)
        scrollView.addSubview(specialInfoView)
        scrollView.addSubview(movieInfoAndStarsDataStackView)
        scrollView.addSubview(underlineView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            movieSnapsCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            movieSnapsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            movieSnapsCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            movieSnapsCollectionView.heightAnchor.constraint(equalToConstant: Constants.screenWidth / 1.8),
            scrollView.widthAnchor.constraint(equalTo: movieSnapsCollectionView.widthAnchor),
            
            movieAvatarImage.centerYAnchor.constraint(equalTo: movieSnapsCollectionView.bottomAnchor),
            movieAvatarImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.little),
            movieAvatarImage.heightAnchor.constraint(equalTo: movieSnapsCollectionView.heightAnchor, multiplier: 0.75),
            movieAvatarImage.widthAnchor.constraint(equalToConstant: Constants.screenWidth / 3.5),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: movieAvatarImage.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: movieAvatarImage.centerYAnchor),
            
            movieTitleLabel.leadingAnchor.constraint(equalTo: movieAvatarImage.trailingAnchor, constant: Constants.ultraTiny),
            movieTitleLabel.bottomAnchor.constraint(equalTo: movieAvatarImage.bottomAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.ultraTiny),
            
            ratingAndPlayerStackView.trailingAnchor.constraint(equalTo: movieSnapsCollectionView.trailingAnchor, constant: -Constants.ultraTiny),
            ratingAndPlayerStackView.bottomAnchor.constraint(equalTo: movieSnapsCollectionView.bottomAnchor, constant: -Constants.ultraTiny),
            
            specialInfoView.topAnchor.constraint(equalTo: movieAvatarImage.bottomAnchor, constant: Constants.tiny),
            specialInfoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            infoAndStarringCollectionView.heightAnchor.constraint(equalToConstant: Constants.little),
            movieInfoAndStarsDataStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constants.tiny),
            movieInfoAndStarsDataStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.tiny),
            movieInfoAndStarsDataStackView.topAnchor.constraint(equalTo: specialInfoView.bottomAnchor, constant: Constants.ultraTiny),
            
            underlineView.topAnchor.constraint(equalTo: infoAndStarringCollectionView.topAnchor, constant: Constants.little),
            movieInfoAndStarsDataStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        underlineLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.tiny)
        underlineLeadingConstraint.isActive = true
        
        underlineWidthConstraint = underlineView.widthAnchor.constraint(equalToConstant: underlineWidth)
        underlineWidthConstraint.isActive = true
    }
    
    private func addPlayerGesture() {
        let playerGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTrailerView))
        playView.addGestureRecognizer(playerGesture)
    }
    
    @objc private func tapOnTrailerView() {
        self.delegate?.play()
    }
    
    private func makePretty(_ text: String) -> String {
        var beautyText = "",
            htmlTagCounter = 0
        for char in text {
            if char == "<" {
                htmlTagCounter += 1
            } else if char == ">" {
                htmlTagCounter -= 1
            } else if htmlTagCounter == 0 {
                beautyText += String(char)
            }
        }
        return "    " + beautyText
    }
}

extension MovieDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCollectionViewCell.identifies, for: indexPath) as! MovieInfoCollectionViewCell
        cell.setupWithTitle(title: dataSource[indexPath.item], isHighlighted: indexPath.item == selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedIndex != indexPath.item else { return }
        selectedIndex = indexPath.item
        
        var newLeadingConstant: CGFloat = 0
        if selectedIndex == 0 {
            newLeadingConstant = Constants.tiny
        } else {
            newLeadingConstant = (self.bounds.width - safeAreaInsets.right - safeAreaInsets.left) / 2
        }
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.selectedIndex = -1
            collectionView.reloadData()
            self?.underlineView.backgroundColor = Colors.lighterGray
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.25) {
                guard let self else { return }
                self.underlineLeadingConstraint.constant = newLeadingConstant
                self.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.selectedIndex = indexPath.item
                collectionView.reloadData()
                self?.underlineView.backgroundColor = .systemGray6
                self?.updateFilmDescription()
            }
        }
    }
}
