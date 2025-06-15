//
//  MainScreenView.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 24.12.2024.
//

import UIKit

protocol CityCollectionViewDelegate: AnyObject {
    func highlightCity(at index: Int)
}

protocol SearchFilmDelegate: AnyObject {
    func searchFilm(withTitle title: String)
}

protocol UpdateFilmsInSelectedCityDelegate: AnyObject {
    func update()
}

class MainScreenView: UIView {
    
    private lazy var wrongFilmTitleAlert: UIAlertController = {
        let alert = UIAlertController(title: "Упс!", message: "Кажется вы ошиблись в названии фильма", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ок", style: .cancel)
        alert.addAction(okAction)
        return alert
    }()
    
    private weak var cityHighlightDelegate: CityCollectionViewDelegate?
    private weak var searchFilmDelegate: SearchFilmDelegate?
    private weak var updateFilmsInSelectedCityDelegate: UpdateFilmsInSelectedCityDelegate?
    
    private lazy var dismissKeyboardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let dismissAction = UIAction { [weak self] _ in
            self?.dismissKeyboard()
        }
        button.addAction(dismissAction, for: .touchUpInside)
        return button
    }()
        
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = Colors.mainGray
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        searchBar.layer.cornerRadius = Constants.tiny
        searchBar.clipsToBounds = true
        searchBar.searchBarStyle = .prominent
        searchBar.barTintColor = Colors.lighterGray
        searchBar.searchTextField.textColor = .systemGray6
        return searchBar
    }()
    
    private lazy var popularFilmsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: Constants.screenWidth / 2.25, height: Constants.screenWidth / 1.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.layer.cornerRadius = Constants.tiny
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.mainGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var citiesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = Constants.tiny / 2
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: Constants.giant, height: Constants.little)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.layer.cornerRadius = Constants.tiny / 2
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.mainGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var filmsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = .init(width: Constants.screenWidth / 3.5, height: Constants.screenWidth / 2.25)
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = Constants.tiny / 2
        collectionViewLayout.minimumLineSpacing = Constants.tiny
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.layer.cornerRadius = Constants.tiny
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
        collectionView.backgroundColor = Colors.mainGray
        return collectionView
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            searchBar,
            popularFilmsCollectionView,
            citiesCollectionView,
            filmsCollectionView
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.tiny
        return stack
    }()

    init(cityCollectionViewDelegate cityDelegate: CityCollectionViewDelegate, searchFilmDelegate searchDelegate: SearchFilmDelegate) {
        super.init(frame: .zero)
        self.cityHighlightDelegate = cityDelegate
        self.searchFilmDelegate = searchDelegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegateToFilmsCollecitonView(filmsCollectionViewDelegate: FilmsCollectionViewDelegate) {
        filmsCollectionView.delegate = filmsCollectionViewDelegate
    }
    
    func getPopularFilmsCollectionView() -> UICollectionView {
        popularFilmsCollectionView
    }
    
    func setDataSourceForCityCollectionView(dataSourceForCityCollectionView citiesCollectionViewDataSource: UICollectionViewDataSource) {
        citiesCollectionView.dataSource = citiesCollectionViewDataSource
    }
    
    func getFilmsCollectionView() -> UICollectionView {
        filmsCollectionView
    }
    
    func dismissKeyboard() { searchBar.resignFirstResponder() }
    
    func getWrongTitleAlert() -> UIAlertController {
        wrongFilmTitleAlert
    }
    
    private func setup() {
        backgroundColor = Colors.mainGray
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(dismissKeyboardButton)
        mainScrollView.addSubview(dataStackView)
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            dismissKeyboardButton.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            dismissKeyboardButton.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            dismissKeyboardButton.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            dismissKeyboardButton.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            
            dataStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            dataStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dataStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            dataStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor, multiplier: 0.9),
            
            popularFilmsCollectionView.heightAnchor.constraint(equalToConstant: Constants.screenWidth / 1.5),
            citiesCollectionView.heightAnchor.constraint(equalToConstant: Constants.little),
            filmsCollectionView.heightAnchor.constraint(equalToConstant: Constants.screenHeight / 2),
        ])
    }
}

extension MainScreenView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.1) {
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                cell?.transform = .identity
            } completion: { [weak self] _ in
                self?.cityHighlightDelegate?.highlightCity(at: indexPath.item)
                self?.citiesCollectionView.reloadData()
            }
        }
    }
}

extension MainScreenView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let filmTitle = searchBar.text {
            searchFilmDelegate?.searchFilm(withTitle: filmTitle)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
