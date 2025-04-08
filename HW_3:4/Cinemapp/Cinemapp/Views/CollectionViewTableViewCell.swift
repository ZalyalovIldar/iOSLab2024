import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject{
    func collectionViewTableViewCellDidTapped(_ cell: CollectionViewTableViewCell, viewModel: DetailedMovieViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    
    private var movies: [Movie] = [Movie]()
    
    weak var delegate: CollectionViewTableViewCellDelegate?

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: PopularCollectionViewCell.identifier)
        return collectionView
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with movies: [Movie]){
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func addMovieAt(indexPath: IndexPath){
        DataPersistenceManager.shared.addMovie(model: movies[indexPath.row]){ result in
            switch result{
            case .success(()):
                print("Добавилось")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.identifier, for: indexPath) as? PopularCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = movies[indexPath.row].poster?.image else {return UICollectionViewCell()}
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard !movie.title.isEmpty else { return }
        
        NetworkManager.shared.getMovies { result in
            switch result {
            case .success(let movies):
                let viewModel = DetailedMovieViewModel(title: movies[indexPath.row].title)
                self.delegate?.collectionViewTableViewCellDidTapped(self, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil){ [weak self] _ in
            let addAction = UIAction(title: "+ Избранное", state: .off){_ in
                self?.addMovieAt(indexPath: indexPath)
            }
            return UIMenu(title: "", options: .displayInline, children: [addAction])
        }
        return config
    }
}
