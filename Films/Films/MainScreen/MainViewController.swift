//
//  MainViewController.swift
//  Films
//
//  Created by Артур Мавликаев on ...
//

import UIKit

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    private var currentPage: Int = 1
    private var isLoading: Bool = false
    private var hasMorePages: Bool = true
    
    private var cityFilms: [Film] = []
    
    private var currentLocation: String = "msk"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.startRotatingSearchIcon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        view.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
        mainView.setDelegate(self)
        mainView.nextPageButton.addTarget(self, action: #selector(loadNextPage), for: .touchUpInside)
        mainView.previousPageButton.addTarget(self, action: #selector(loadPreviousPage), for: .touchUpInside)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
        loadInitialData()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadInitialData() {
        FilmsRepository.shared.fetchFilms { [weak self] result in
            switch result {
            case .success(let films):
                DispatchQueue.main.async {
                    let randomFilms = Array(films.shuffled().prefix(10))
                    self?.mainView.allFilms = randomFilms
                    self?.mainView.updateData(with: randomFilms)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка", message: "Проверьте интернет", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        City.shared.fetchCities { [weak self] result in
            switch result {
            case .success(let cities):
                DispatchQueue.main.async {
                    self?.mainView.updateCityCollectionView(with: cities)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить города", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        loadFilmsForCurrentLocation()
    }
    
    @objc private func loadNextPage() {
        guard !isLoading else { return }
        currentPage += 1
        loadFilmsForCurrentLocation()
    }
    
    @objc private func loadPreviousPage() {
        guard currentPage > 1, !isLoading else { return }
        currentPage -= 1
        loadFilmsForCurrentLocation()
    }
    
    private func updatePageButtonsState() {
        DispatchQueue.main.async {
            self.mainView.previousPageButton.isEnabled = self.currentPage > 1
            self.mainView.nextPageButton.isEnabled = self.hasMorePages
        }
    }
    
    func loadFilmsForCurrentLocation() {
        guard !isLoading else { return }
        isLoading = true
        cityFilms.removeAll()
        mainView.updateCityGridCollectionView(with: [])
        FilmsRepository.shared.fetchFilms(by: currentLocation, page: currentPage, pageSize: 15) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let filmsResponse):
                self.cityFilms = filmsResponse.results
                DispatchQueue.main.async {
                    self.mainView.updateCityGridCollectionView(with: self.cityFilms)
                    self.mainView.allFilmsLocation = self.cityFilms
                    self.updatePageButtonsState()
                }
                self.hasMorePages = !filmsResponse.results.isEmpty
                self.isLoading = false
            case .failure(_):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить фильмы по городу", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ок", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    self.updatePageButtonsState()
                }
                self.isLoading = false
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.collectionView {
            let selectedFilm = mainView.allFilms[indexPath.item]
            let detailVC = DetailScreenViewController(filmID: selectedFilm.id)
            navigationController?.pushViewController(detailVC, animated: true)
            
        } else if collectionView == mainView.secondCollectionView {
            let city = City.shared.cities[indexPath.item]
            currentLocation = city.slug
            currentPage = 1
            cityFilms.removeAll()
            loadFilmsForCurrentLocation()
            

        } else if collectionView == mainView.cityGridCollectionView {
            let selectedFilm = cityFilms[indexPath.item]
            let detailVC = DetailScreenViewController(filmID: selectedFilm.id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
