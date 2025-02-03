import UIKit
import SafariServices

class MovieDetailController: UIViewController {
    private var customView: MovieDetailView {
        view as! MovieDetailView
    }
    private var movie: MovieWithInfo!
    private var images: [String] = []
    private var filmImagesCollectionViewDataSource: MovieSnapsCollectionViewDataSource?
    private var filmImagesCollectionViewDelegate: MovieSnapsCollectionViewDelegate?
    private let dataManager = MovieDetailDataManager()
    private var trailerLink: String!
    private var openControllerAnimator: UIViewPropertyAnimator?
    private var closeControllerAnimator: UIViewPropertyAnimator?
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func loadView() {
        super.loadView()
        view = MovieDetailView(playTrailerDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(movie)
        setupCollectionViewData()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        openControllerAnimator?.startAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        customView.updateLayout()
    }
    
    init(withFilm film: MovieWithInfo) {
        super.init(nibName: nil, bundle: nil)
        self.movie = film
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar(_ film: MovieWithInfo) {
        navigationItem.titleView = NavigationItemView(title: "О фильме")
        
        let dismissButton = getDismissButton()
        let favouriteButton = getBookmarkButton()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
    }
    
    private func getDismissButton() -> UIButton {
        let button = UIButton()
        setupCloseControllerAnimator(button: button)
        setupOpenControllerAnimator(button: button)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: Constants.small).isActive = true
        button.widthAnchor.constraint(equalToConstant: Constants.small).isActive = true
        
        button.addAction(UIAction { [weak self] _ in
            self?.closeControllerAnimator?.startAnimation()
        }, for: .touchUpInside)

        return button
    }
    
    private func setupOpenControllerAnimator(button: UIButton) {
        button.transform = CGAffineTransform(scaleX: 0, y: 0)
        openControllerAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            button.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        let secondAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        openControllerAnimator?.addCompletion { _ in
            secondAnimator.startAnimation()
        }
    }

    private func setupCloseControllerAnimator(button: UIButton) {
        closeControllerAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            button.transform = CGAffineTransform(rotationAngle: .pi)
        }
        let secondAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            let rotation = CGAffineTransform(rotationAngle: .pi * -2)
            let scale = CGAffineTransform(scaleX: 2, y: 2)
            button.transform = rotation.concatenating(scale)
        }
        if let closeControllerAnimator {
            secondAnimator.addCompletion { _ in
                UIView.animate(withDuration: 0.2) {
                    button.alpha /= 2
                }
                self.dismiss(animated: true)
            }
            closeControllerAnimator.addCompletion { _ in
                secondAnimator.startAnimation()
            }
        }
    }
    
    private func getBookmarkButton() -> UIButton {
        let bookmarkButton = UIButton()
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.heightAnchor.constraint(equalToConstant: Constants.small * 1.2).isActive = true
        bookmarkButton.widthAnchor.constraint(equalToConstant: Constants.small).isActive = true
        bookmarkButton.setImage(dataManager.getBookmarkButtonImage(for: movie), for: .normal)
        
        let bookmarkButtonAction = UIAction { [weak self] _ in
            guard let self else { return }
            feedbackGenerator.impactOccurred()
            dataManager.switchMovieState(movie: movie)

            if dataManager.isBookmarked(movieTitle: movie.title) {
                Animations.addFilmToFavouriteAnimation(button: bookmarkButton)
            } else {
                Animations.shake(bookmarkButton) { favouriteButton in
                    favouriteButton.setImage(.bookmark, for: .normal)
                    Animations.shake(favouriteButton)
                }
            }
        }
        bookmarkButton.addAction(bookmarkButtonAction, for: .touchUpInside)
        return bookmarkButton
    }
    
    private func setupData() {
        customView.setUpWithFilm(movie)
        images = dataManager.getMovieImages(movie)
        trailerLink = dataManager.getTrailerLink(movie)
    }
    
    private func setupCollectionViewData() {
        filmImagesCollectionViewDataSource = MovieSnapsCollectionViewDataSource(images: images)
        if let filmImagesCollectionViewDataSource {
            filmImagesCollectionViewDelegate = MovieSnapsCollectionViewDelegate(withData: filmImagesCollectionViewDataSource.getData(), viewController: self)
        }
        
        customView.setDelegateForFilmImagesCollectionView(with: filmImagesCollectionViewDelegate)
        customView.setDataSourceForFilmImagesCollectionView(with: filmImagesCollectionViewDataSource)
    }
    
    private func playTrailer() {
        guard let url = URL(string: trailerLink) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .automatic
        self.present(safariViewController, animated: true)
    }
}

extension MovieDetailController: PlayTrailerDelegate {
    func play() {
        playTrailer()
    }
}

