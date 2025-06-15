//
//  MainView.swift
//  Films
//
//  Created by Артур Мавликаев on 06.01.2025.
//

import UIKit

class MainView: UIView, UICollectionViewDelegate, UISearchBarDelegate {
    
    // MARK: - Коллекция случайных фильмов
    private var dataSource: UICollectionViewDiffableDataSource<Int, Film>!
    var allFilms: [Film] = []
    var allFilmsLocation: [Film] = []
    let nextPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Следующая", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let previousPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Предыдущая", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.systemGray
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let numberOfItemsPerRow: CGFloat = 3
        let itemWidth = UIScreen.main.bounds.width / numberOfItemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    // MARK: - Коллекция городов
    public lazy var secondCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Коллекция фильмов по выбранному городу
    lazy var cityGridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let numberOfItemsPerRow: CGFloat = 3
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        let totalSpacing = layout.sectionInset.left + layout.sectionInset.right + (layout.minimumInteritemSpacing * (numberOfItemsPerRow - 1))
        let availableWidth = UIScreen.main.bounds.width - totalSpacing
        let itemWidth = floor(availableWidth / numberOfItemsPerRow)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    // MARK: - SearchBar
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search films...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        sb.searchTextField.textColor = .white
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
        sb.backgroundImage = UIImage()
        return sb
    }()
    
    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureDataSource()
        configureCityDataSource()
        configureCityGridDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configureDataSource()
        configureCityDataSource()
        configureCityGridDataSource()
    }
    
    // MARK: - Layout
    private func setupView() {
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(secondCollectionView)
        addSubview(cityGridCollectionView)
        addSubview(previousPageButton)
        addSubview(nextPageButton)
        
        NSLayoutConstraint.activate([
            // SearchBar
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -16),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            // Коллекция случайных фильмов
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            // Коллекция городов
            secondCollectionView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            secondCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            secondCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            // Коллекция фильмов по городу
            cityGridCollectionView.topAnchor.constraint(equalTo: secondCollectionView.bottomAnchor, constant: 8),
            cityGridCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cityGridCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cityGridCollectionView.bottomAnchor.constraint(equalTo: previousPageButton.topAnchor, constant: -16),
            
            // Кнопка "Предыдущая"
            previousPageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            previousPageButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            previousPageButton.heightAnchor.constraint(equalToConstant: 40),
            previousPageButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
            
            // Кнопка "Следующая"
            nextPageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextPageButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            nextPageButton.heightAnchor.constraint(equalToConstant: 40),
            nextPageButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35)
        ])
        
        // Регистрируем ячейки
        collectionView.register(MainViewCollectionViewCell.self, forCellWithReuseIdentifier: "FilmCell")
        secondCollectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: "CityCell")
        cityGridCollectionView.register(MainViewCollectionViewCell.self, forCellWithReuseIdentifier: "CityGridCell")
        
        // Делегат searchBar
        searchBar.delegate = self
    }
    
    // MARK: - Делегаты для коллекций
    public func setDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
        secondCollectionView.delegate = delegate
        cityGridCollectionView.delegate = delegate
    }
    
    // MARK: - DataSource для случайных фильмов
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Film>(collectionView: collectionView) { collectionView, indexPath, film in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as? MainViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: film)
            cell.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1)
            return cell
        }
    }
    
    public func updateData(with films: [Film]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Film>()
        snapshot.appendSections([0])
        snapshot.appendItems(films, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - DataSource для городов
    var cityDataSource: UICollectionViewDiffableDataSource<Int, CityModel>!
    
    private func configureCityDataSource() {
        cityDataSource = UICollectionViewDiffableDataSource<Int, CityModel>(collectionView: secondCollectionView) { collectionView, indexPath, city in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as? CityCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: city)
            return cell
        }
    }
    
    public func updateCityCollectionView(with cities: [CityModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CityModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(cities, toSection: 0)
        cityDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - DataSource для фильмов по городу
    private var cityGridDataSource: UICollectionViewDiffableDataSource<Int, Film>!
    
    private func configureCityGridDataSource() {
        cityGridDataSource = UICollectionViewDiffableDataSource<Int, Film>(collectionView: cityGridCollectionView) { collectionView, indexPath, film in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityGridCell", for: indexPath) as? MainViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: film)
            return cell
        }
    }
    
    public func updateCityGridCollectionView(with films: [Film]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Film>()
        snapshot.appendSections([0])
        snapshot.appendItems(films, toSection: 0)
        cityGridDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            updateCityGridCollectionView(with: allFilmsLocation)
        } else {
            let filteredFilms = allFilmsLocation.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            updateCityGridCollectionView(with: filteredFilms)
        }
    }
    
    // MARK: - Вращение иконки поиска
    func startRotatingSearchIcon() {
        guard let iconView = searchBar.searchTextField.leftView as? UIImageView else { return }
        iconView.tintColor = .white
        iconView.isUserInteractionEnabled = false
        iconView.layer.removeAnimation(forKey: "rotationAnimation")
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1.0
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        iconView.layer.add(rotation, forKey: "rotationAnimation")
    }
}
