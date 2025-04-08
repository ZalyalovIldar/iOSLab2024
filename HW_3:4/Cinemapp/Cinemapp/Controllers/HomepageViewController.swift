import UIKit

enum Sections: Int{
    case Popular = 0
    case Moscow = 1
    case Kazan = 2
    case Spb = 3
}

class HomepageViewController: UIViewController {
    
    let sectionTitle: [String] = ["Популярное", "Москва", "Казань", "Санкт-Петербург"]
    
    private var randomMovie: Movie?
    private var headerView: TableHeaderView?
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavigationBar()
        setHeaderView()
        
        headerView = TableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
    }
    
    private func setHeaderView(){
        NetworkManager.shared.getMovies { [weak self] result in
            switch result{
            case .success(let movies):
                let randomized = movies.randomElement()
                self?.randomMovie = randomized
                self?.headerView?.configure(with: randomized?.poster?.image ?? "")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureNavigationBar(){
        var logo = UIImage(systemName: "movieclapper.fill")
        logo = logo?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logo, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .systemRed
    }
        
}

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.Popular.rawValue:
            NetworkManager.shared.getMovies { result in
                switch result {
                case .success(let movies):
                    let limitedMovies = Array(movies.prefix(10))
                    DispatchQueue.main.async {
                        cell.configure(with: limitedMovies)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Moscow.rawValue:
            NetworkManager.shared.getMoviesByCity(citySlug: "msk", page: 1) { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        cell.configure(with: movies)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Kazan.rawValue:
            NetworkManager.shared.getMoviesByCity(citySlug: "kzn", page: 1) { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        cell.configure(with: movies)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Spb.rawValue:
            NetworkManager.shared.getMoviesByCity(citySlug: "spb", page: 10) { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        cell.configure(with: movies)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        default:
            break
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalizeOnlyFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let dfOffset = view.safeAreaInsets.top
        let assignedOffset = scrollView.contentOffset.y + dfOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -assignedOffset))
    }
    
}

extension HomepageViewController: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapped(_ cell: CollectionViewTableViewCell, viewModel: DetailedMovieViewModel) {
        DispatchQueue.main.async{ [weak self] in
            let vc = MovieDetailsViewController()
            vc.configure(with: viewModel)
            vc.navigationItem.hidesBackButton = false
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

