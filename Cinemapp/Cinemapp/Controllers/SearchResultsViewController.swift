import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject{
    func searchResultsViewControllerDidTapped(_ viewModel: DetailedMovieViewModel)
}

class SearchResultsViewController: UIViewController{

    public var movies: [Movie] = [Movie]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: PopularCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.identifier, for: indexPath) as? PopularCollectionViewCell else {
                return UICollectionViewCell()
            }
            let movie = movies[indexPath.row]
            print("Configuring cell for movie: \(movie.title)")
            cell.configure(with: movie.poster?.image ?? "")
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        let movieName = movie.title
        NetworkManager.shared.getMovies{ [weak self] result in
            switch result{
            case .success(let movies):
                self?.delegate?.searchResultsViewControllerDidTapped(DetailedMovieViewModel(title: movie.title))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
