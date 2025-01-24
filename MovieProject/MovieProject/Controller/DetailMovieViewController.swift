import UIKit
import SafariServices

class DetailMovieViewController: UIViewController {
    private let dataManager = DataManager()
    private lazy var detailView = DetailMovieView(frame: .zero)
    private lazy var dataSource = ImageCarouselCollectionViewDataSource(dataSource: [])
    private var movieDetail: MovieDetail

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentControlChange()
        setupBarButtonItem()
    }
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
        super.init(nibName: nil, bundle: nil)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBarButtonItem() {
        let savedButton = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(toggleFavoriteStatus))
        navigationItem.rightBarButtonItem = savedButton
        updateIconSavedButton()
    }
    
    @objc private func toggleFavoriteStatus() {
        let isFavorite = isMovieFavorite()
        
        if isFavorite {
            CoreDataManager.shared.removeFavoriteMovies(byId: movieDetail.id)
        } else {
            CoreDataManager.shared.saveFavoriteMovies(movieDetail)
        }
        
        updateIconSavedButton()
    }
    
    private func updateIconSavedButton() {
        let isFavorite = isMovieFavorite()
        let iconName = isFavorite ? "bookmark.fill" : "bookmark"
        let savedIconImage = UIImage(systemName: iconName)?.withTintColor(Constant.orangeColor,
                                                                           renderingMode:
                .alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = savedIconImage
    }
    
    private func isMovieFavorite() -> Bool {
        let fetchRequest = MovieFavoriteEntites.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieDetail.id)
        
        do {
            let count = try CoreDataManager.shared.viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check if movie is favorite: \(error)")
            return false
        }
    }
                                          
    override func loadView() {
        view = detailView
    }
    
    private func setupSegmentControlChange() {
        detailView.segmentControl.addTarget(self, action: #selector(segmentControlValueChange), for: .valueChanged)
    }
    
    @objc
    private func segmentControlValueChange() {
        switch detailView.segmentControl.selectedSegmentIndex {
        case 0:
            self.detailView.descriptionLabel.isHidden = false
            self.detailView.starsLabel.isHidden = true
        case 1:
            self.detailView.descriptionLabel.isHidden = true
            self.detailView.starsLabel.isHidden = false
        default:
            break
        }
    }
    
    private func setupUI() {
        let genresString = movieDetail.genres.map { $0.name }.joined(separator: ", ")
        let descriptionText = movieDetail.description.dropFirst(3).dropLast(5)
        detailView.updateLabelForStackView(data: "\(movieDetail.year)", duration: "\(movieDetail.duration) Минуты", genre: "\(genresString)")
        detailView.starsLabel.text = movieDetail.stars
        detailView.descriptionLabel.text = String(descriptionText)
        detailView.mainTitle.text = movieDetail.title
        
        if let raiting = movieDetail.raiting {
            detailView.raitingLabel.text = "\(raiting)"
        } else {
            detailView.raitingLabel.text = "Нет оценки"
        }
        
        detailView.onTrailerButtonTapped = { [weak self] in
            self?.playTrailer()
        }
        
        Task {
            do {
                detailView.posterImage.image = try await ImageService.downloadImage(by: movieDetail.poster.image)
            } catch {
                detailView.posterImage.image = .notFound
            }
        }
        
        DispatchQueue.main.async {
            self.dataSource.updateDataSource(dataSource: self.movieDetail.images)
            self.detailView.setupImageCarouselCollectionViewDataSource(dataSource: self.dataSource)
            self.detailView.imageCarouselCollectionView.reloadData()
        }
    }
   
    private func playTrailer() {
        guard let url = URL(string: movieDetail.trailer) else { return }
        let sfc = SFSafariViewController(url: url)
        self.present(sfc, animated: true)
    }
    
}
