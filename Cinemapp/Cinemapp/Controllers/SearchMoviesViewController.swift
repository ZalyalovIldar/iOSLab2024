import UIKit

class SearchMoviesViewController: UIViewController {
    
    private var movies: [Movie] = [Movie]()

    private let commonSearchesTable: UITableView = {
        let table = UITableView()
        table.register(CommonSearchesTableViewCell.self, forCellReuseIdentifier: CommonSearchesTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Что вы хотите посмотреть?"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Найти фильм"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        view.addSubview(commonSearchesTable)
        
        commonSearchesTable.delegate = self
        commonSearchesTable.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        
        navigationItem.searchController = searchController
        setCommonSearchMovies()
        searchController.searchResultsUpdater = self
    }
    
    private func setCommonSearchMovies(){
        NetworkManager.shared.getMovies{[weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async{
                    self?.commonSearchesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        commonSearchesTable.frame = view.bounds
    }
    
}

extension SearchMoviesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonSearchesTableViewCell.identifier, for: indexPath) as? CommonSearchesTableViewCell else {return UITableViewCell()}
        
        let movie = movies[indexPath.row]
        let model = MovieViewModel(title: movie.title, poster: movie.poster)
        cell.configureMV(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        
        guard !movie.title.isEmpty else { return }
        
        NetworkManager.shared.getMovies { [weak self] result in
            switch result{
            case .success(let movies):
                DispatchQueue.main.async{ [weak self] in
                    let vc = MovieDetailsViewController()
                    vc.configure(with: DetailedMovieViewModel(title: movies[indexPath.row].title))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}

extension SearchMoviesViewController: UISearchResultsUpdating, UISearchControllerDelegate, SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapped(_ viewModel: DetailedMovieViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MovieDetailsViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsController.delegate = self
        
        NetworkManager.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    resultsController.movies = movies
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                }
            }
        }
    }

    func willPresentSearchController(_ searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultsController.movies = []
        resultsController.searchResultsCollectionView.reloadData()
    }
}
