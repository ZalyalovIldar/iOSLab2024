import UIKit

class HomeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var mainLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Что вы хотите посмотреть?"
        text.textColor = .white
        text.font = UIFont(name: Constant.Font.poppinsExtraBold, size: 18)
        text.textAlignment = .left
        return text
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.backgroundColor = Constant.grayColor
        return scroll
    }()

    lazy var searchBar: UISearchBar = {
        let mySearchBar = UISearchBar()
        mySearchBar.searchBarStyle = .minimal
        mySearchBar.layer.cornerRadius = Constant.HomeView.searchBarCornerRadius
        mySearchBar.clipsToBounds = true
        mySearchBar.translatesAutoresizingMaskIntoConstraints = false
        mySearchBar.tintColor = .white
        mySearchBar.backgroundColor = Constant.grayColor
        mySearchBar.searchTextField.textColor = .systemGray6

        if let textField = mySearchBar.value(forKey: "searchField") as? UITextField {
            let color = UIColor.init(hex: Constant.HomeView.colorTextSearchBar)
            let attributes = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: UIFont(name: Constant.Font.poppinsRegular, size: 14)]
            textField.attributedPlaceholder = NSAttributedString(string: "Поиск...", attributes: attributes as [NSAttributedString.Key : Any])
        }
        return mySearchBar
    }()

    lazy var topMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: Constant.screenWidth / 2.25, height: Constant.screenWidth / 1.75)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(TopMoviesCollectionViewCell.self, forCellWithReuseIdentifier: TopMoviesCollectionViewCell.reuseIdentifier)
        return collection
    }()

    lazy var cityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constant.HomeView.collectionViewMinimumLineSpacing / 2
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CityCollectionVIewCell.self, forCellWithReuseIdentifier: CityCollectionVIewCell.reuseIndentifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.init(hex: "242A32")
        return collection
    }()

    lazy var allMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: Constant.screenWidth / 3.75, height: Constant.screenWidth / 2.5)
        layout.minimumLineSpacing = Constant.HomeView.collectionViewMinimumLineSpacing
        layout.minimumInteritemSpacing = Constant.HomeView.collectionViewMinimumInteritemSpacing

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.reuseIndentifier)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainLabel,
            searchBar,
            topMoviesCollectionView,
            cityCollectionView,
            allMoviesCollectionView
        ])
        stack.axis = .vertical
        stack.spacing = Constant.HomeView.spaicingStackView
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setupView() {
        backgroundColor = UIColor.init(hex: "242A32")
    }

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constant.Padding.medium),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            cityCollectionView.heightAnchor.constraint(equalToConstant: Constant.Padding.xxLarge),
            topMoviesCollectionView.heightAnchor.constraint(equalToConstant: Constant.screenWidth / 1.5),
            allMoviesCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
    
    func setupMoviesDelegate(_ delegate: UICollectionViewDelegate) {
        allMoviesCollectionView.delegate = delegate
    }

    func setupTopMoviesDataSourceCollectionView(_ dataSource: UICollectionViewDataSource) {
        topMoviesCollectionView.dataSource = dataSource
    }

    func setupCityDataSourceCollectionView(_ dataSource: UICollectionViewDataSource) {
        cityCollectionView.dataSource = dataSource
    }

    
    func setupMoviesDataSourceCollectionView(_ dataSource: UICollectionViewDataSource) {
        allMoviesCollectionView.dataSource = dataSource
    }
    
    func setupSearchBarDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func setupCityDelegate(_ delegate: UICollectionViewDelegate) {
        cityCollectionView.delegate = delegate
    }
}
