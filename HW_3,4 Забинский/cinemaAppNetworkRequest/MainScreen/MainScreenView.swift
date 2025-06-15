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
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        configureSearchBarStyle(searchBar)
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
        collectionViewLayout.minimumInteritemSpacing = Constants.ultraTiny
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
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
        collectionView.isScrollEnabled = false
        collectionView.layer.cornerRadius = Constants.tiny
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
        collectionView.backgroundColor = Colors.mainGray
        return collectionView
    }()
    
    lazy var dataStackView: UIStackView = {
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
    
    func setDelegateToMainScrollView(delegate: UIScrollViewDelegate) {
        mainScrollView.delegate = delegate
    }
    
    func configureSearchBarStyle(_ searchBar: UISearchBar) {
        searchBar.searchTextField.font = UIFont(name: "Montserrat-Regular", size: Fonts.small)
        searchBar.layer.cornerRadius = Constants.tiny
        searchBar.clipsToBounds = true
        searchBar.searchBarStyle = .prominent
        searchBar.barTintColor = Colors.lighterGray
        searchBar.searchTextField.textColor = .systemGray6
        searchBar.searchTextField.backgroundColor = Colors.lighterGray
    }
    
    func setDelegateToPopularFilmsCollecitonView(popularFilmsCollectionViewDelegate: PopularFilmsDelegate) {
        popularFilmsCollectionView.delegate = popularFilmsCollectionViewDelegate
    }
    
    func setDelegateToFilmsCollecitonView(filmsCollectionViewDelegate: FilmsCollectionViewDelegate) {
        filmsCollectionView.delegate = filmsCollectionViewDelegate
    }

    
    func setDataSourceForCityCollectionView(dataSourceForCityCollectionView citiesCollectionViewDataSource: UICollectionViewDataSource) {
        citiesCollectionView.dataSource = citiesCollectionViewDataSource
    }
    
    func getPopularFilmsCollectionView() -> UICollectionView { popularFilmsCollectionView }
    func getFilmsCollectionView() -> UICollectionView { filmsCollectionView }
    func dismissKeyboard() { searchBar.resignFirstResponder() }
    func getWrongTitleAlert() -> UIAlertController { wrongFilmTitleAlert }
    
    func clearSearchBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.searchBar.text = nil
        }
    }
    
    private var filmsCollectionViewHeightConstraint: NSLayoutConstraint?
    
    func setFilmsCollectionViewHeight(height: CGFloat) {
        filmsCollectionViewHeightConstraint?.isActive = false
        
        filmsCollectionViewHeightConstraint = filmsCollectionView.heightAnchor.constraint(equalToConstant: height)
        filmsCollectionViewHeightConstraint?.isActive = true
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

        ])
    }
}

extension MainScreenView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let randomVal = Bool.random() ? 1 : -1
        let scaleTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let leftTransition = CGAffineTransform(rotationAngle: .pi / 24 * CGFloat(randomVal))
        let rightTransition = CGAffineTransform(rotationAngle: .pi / -48 * CGFloat(randomVal))
            
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
            cell?.transform = leftTransition.concatenating(scaleTransform)
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear)  {
                cell?.transform = rightTransition
            } completion: { _ in
                self.cityHighlightDelegate?.highlightCity(at: indexPath.item)
                self.citiesCollectionView.reloadData()
                UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear)  {
                    cell?.transform = .identity
                } 
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
