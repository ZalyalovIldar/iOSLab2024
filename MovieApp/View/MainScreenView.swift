import UIKit
// Protocol for handling city selection in the city collection view
protocol CityCollectionViewDelegate: AnyObject {
    func highlightCity(at index: Int)
}

// Protocol for updating views when the selected city changes
protocol UpdateInSelectedCityDelegate: AnyObject {
    func update()
}

class MainScreenView: UIView {

    private weak var cityHighlightDelegate: CityCollectionViewDelegate?
    private weak var updateInSelectedCityDelegate: UpdateInSelectedCityDelegate?
    
    
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
        configureSearchBarStyle(searchBar)
        return searchBar
    }()
    
    private lazy var topMoviesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: Constants.screenWidth / 2.25, height: Constants.screenWidth / 1.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.layer.cornerRadius = Constants.tiny
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.mainGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
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
    
    private lazy var movieCollectionView: UICollectionView = {
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
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = Colors.mainGray
        return collectionView
    }()
    
    lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            searchBar,
            topMoviesCollectionView,
            citiesCollectionView,
            movieCollectionView
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.tiny
        return stack
    }()
    
    init(cityCollectionViewDelegate cityDelegate: CityCollectionViewDelegate) {
        super.init(frame: .zero)
        self.cityHighlightDelegate = cityDelegate
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegateToMainScrollView(delegate: UIScrollViewDelegate) {
        mainScrollView.delegate = delegate
    }
    
    func configureSearchBarStyle(_ searchBar: UISearchBar) {
        searchBar.searchTextField.font = UIFont(name: "Poppins", size: Fonts.small)
        searchBar.layer.cornerRadius = Constants.tiny
        searchBar.clipsToBounds = true
        searchBar.searchBarStyle = .prominent
        searchBar.barTintColor = Colors.lighterGray
        searchBar.searchTextField.textColor = .systemGray6
        searchBar.searchTextField.backgroundColor = Colors.lighterGray
    }
    
    func setDelegateToTopMoviesCollecitonView(popularFilmsCollectionViewDelegate: TopMoviesDelegate) {
        topMoviesCollectionView.delegate = popularFilmsCollectionViewDelegate
    }
    
    func setDelegateToMoviesCollecitonView(movieCollectionViewDelegate: MovieCollectionViewDelegate) {
        movieCollectionView.delegate = movieCollectionViewDelegate
    }

    
    func setDataSourceForCityCollectionView(dataSourceForCityCollectionView citiesCollectionViewDataSource: UICollectionViewDataSource) {
        citiesCollectionView.dataSource = citiesCollectionViewDataSource
    }
    
    func getTopMoviesCollectionView() -> UICollectionView { topMoviesCollectionView }
    func getMovieCollectionView() -> UICollectionView { movieCollectionView }
    
    
    
    private var moviesCollectionViewHeightConstraint: NSLayoutConstraint?
    
    func setMoviesCollectionViewHeight(height: CGFloat) {
        moviesCollectionViewHeightConstraint?.isActive = false
        
        moviesCollectionViewHeightConstraint = movieCollectionView.heightAnchor.constraint(equalToConstant: height)
        moviesCollectionViewHeightConstraint?.isActive = true
    }
    
    private func setup() {
        backgroundColor = Colors.mainGray
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(dataStackView)
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        
            
            dataStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            dataStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dataStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            dataStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor, multiplier: 0.9),
            
            topMoviesCollectionView.heightAnchor.constraint(equalToConstant: Constants.screenWidth / 1.5),
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

