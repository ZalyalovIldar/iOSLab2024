//
//  MoviesViewController.swift
//  films
//
//  Created by Кирилл Титов on 13.01.2025.
//

import UIKit

class MoviesViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    private var movies: [Movie] = []
    private var isLoading = false
    private var nextPageURL: String? = nil
    private var isLoadingMoreMovies = false
    private var filteredMovies: [Movie] = []
    private var isSearching = false
    
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to watch?"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.backgroundImage = UIImage()
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(named: "search")
            textField.textColor = .white
            textField.layer.cornerRadius = 15
            textField.layer.masksToBounds = true
            
            let placeholderText = NSAttributedString(string: "Search", attributes: [
                .foregroundColor: UIColor(named: "fontcolorsearch"),
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ])
            textField.attributedPlaceholder = placeholderText
        }
        
        return searchBar
    }()
    
    private let horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 180, height: 250)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Now playing", "Upcoming", "Top rated", "Popular"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        
        segment.setTitleTextAttributes([
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ], for: .normal)
        
        
        
        return segment
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 16, height: 200)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "back")
        
        
        setupUI()
        setupDelegates()
        loadMovies()
        view.addSubview(underlineView)
        
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(horizontalCollectionView)
        view.addSubview(segmentControl)
        view.addSubview(underlineView)
        view.addSubview(gridCollectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            horizontalCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            segmentControl.topAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor, constant: 0),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            underlineView.bottomAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
            underlineView.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 0.25),
            underlineView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            
            gridCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            gridCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gridCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        view.layoutIfNeeded()
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
    }
    
    private func setupDelegates() {
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        searchBar.delegate = self
        
        horizontalCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        gridCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
    }
    
    @objc private func segmentChanged() {
        let segmentWidth = segmentControl.frame.width / CGFloat(segmentControl.numberOfSegments)
        let underlineXPosition = CGFloat(segmentControl.selectedSegmentIndex) * segmentWidth+15
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = underlineXPosition
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredMovies.removeAll()
        } else {
            isSearching = true
            filteredMovies = movies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased())
            }
        }
        gridCollectionView.reloadData()
        horizontalCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        filteredMovies.removeAll()
        gridCollectionView.reloadData()
        horizontalCollectionView.reloadData()
    }
    
    
    
    
    
    private func loadMovies(isNextPage: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                let urlString = isNextPage ? nextPageURL : "https://kudago.com/public-api/v1.4/movies/"
                guard let url = urlString else {
                    isLoading = false
                    return
                }
                
                let fetchedResponse = try await NetworkManager.shared.fetchMovies(from: url)
                
                self.nextPageURL = fetchedResponse.next
                
                DispatchQueue.main.async {
                    if isNextPage {
                        self.movies.append(contentsOf: fetchedResponse.results)
                    } else {
                        self.movies = fetchedResponse.results
                    }
                    
                    self.horizontalCollectionView.reloadData()
                    self.gridCollectionView.reloadData()
                }
            } catch {
                print("Error loading movies: \(error)")
            }
            
            isLoading = false
        }
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredMovies.count
        }
        if collectionView == horizontalCollectionView {
            return min(movies.count, 10)
        }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForItemAt indexPath: IndexPath) -> UIEdgeInsets {
        if indexPath.item == 0 {
            return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = isSearching ? filteredMovies[indexPath.item] : movies[indexPath.item]
        
        if collectionView == horizontalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.prepareForReuse()
            cell.configure(with: movie, number: indexPath.item + 1, isTopMovie: true)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.prepareForReuse()
            cell.configure(with: movie, number: indexPath.item + 1, isTopMovie: false)
            return cell
        }
    }



    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: Movie
        if collectionView == gridCollectionView {
            movie = isSearching ? filteredMovies[indexPath.item] : movies[indexPath.item]
        } else {
            movie = movies[indexPath.item]
        }

        let detailVC = MovieDetailViewController()
        detailVC.movie = movie

        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
    
    
}
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        if position > (contentHeight - scrollViewHeight - 100) {
            if let nextPageURL = nextPageURL {
                loadMovies(isNextPage: true)
            }
        }
    }
}

