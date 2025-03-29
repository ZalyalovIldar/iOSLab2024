//
//  FavoriteUIViewViewController.swift
//  Films
//
//  Created by Артур Мавликаев on 16.01.2025.
//

import UIKit

class FavoriteUIViewViewController: UIViewController, DataManagerDelegate {
    func favoritesDidUpdate(newFavorites: [Int]) {
        favoriteFilmIDs = newFavorites
        fetchFavoriteFilms()
    }
    
    
    private let favoriteView = FavoriteUIView()
    private lazy var favoriteManager = DataManager.shared
    private var favoriteFilmIDs: [Int] = []
    private var orderedFilmDetails: [FilmDetail] = []
    private var dataSource: UICollectionViewDiffableDataSource<Int, DetailRow>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteManager.delegate = self
        favoriteFilmIDs = favoriteManager.getAllFilms()
        view.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
        view.addSubview(favoriteView)
        setupConstraints()
        
        title = "Избранное"
        
        configureDataSource()
        fetchFavoriteFilms()
        favoriteView.collectionView.delegate = self
    }
    
    private func setupConstraints() {
        favoriteView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteView.topAnchor.constraint(equalTo: view.topAnchor),
            favoriteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, DetailRow>(
            collectionView: favoriteView.collectionView
        ) { collectionView, indexPath, detailRow in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FilmCell",
                for: indexPath
            ) as? MainViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            switch detailRow {
            case .poster(let imageUrl):
                cell.configureWithUrl(with: imageUrl)
            default:
                break
            }
            return cell
        }
    }
    

    private func fetchFavoriteFilms() {
        var details: [FilmDetail] = []
        let dispatchGroup = DispatchGroup()
        for filmID in favoriteFilmIDs {
            dispatchGroup.enter()
            FilmsRepository.shared.fetchFilmDetails(filmID: filmID) { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let detail):
                    details.append(detail)
                case .failure(let error):
                    print("Ошибка при загрузке: \(error)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.applySnapshot(with: details)
        }
    }
    
    private func applySnapshot(with filmDetails: [FilmDetail]) {
        var posterRows: [DetailRow] = []
        orderedFilmDetails = []
        for filmDetail in filmDetails {
            let rows = DetailDataBuilder.buildRows(from: filmDetail)
            if let posterRow = rows.first(where: {
                switch $0 {
                case .poster: return true
                default: return false
                }
            }) {
                posterRows.append(posterRow)
                orderedFilmDetails.append(filmDetail)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, DetailRow>()
        snapshot.appendSections([0])
        snapshot.appendItems(posterRows, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension FavoriteUIViewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < orderedFilmDetails.count else { return }
        let selectedFilmDetail = orderedFilmDetails[indexPath.item]
        let detailVC = DetailScreenViewController(filmID: selectedFilmDetail.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
