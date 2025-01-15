//
//  MainView.swift
//  Movies
//
//  Created by Павел Калинин on 20.12.2024.
//

import UIKit

class MainView: UIView {
    private lazy var searchView = SearchView()
    lazy var customSegmentedControl: CustomSegmentedControl = {
        let customSegmentedControl = CustomSegmentedControl<City>(items: [], titleProvider: {$0.name})
        customSegmentedControl.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 10)
        customSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return customSegmentedControl
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var listActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    lazy var topCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        layout.itemSize = CGSize(width: 145, height: 210)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = AppColors.mainColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 10)
        return collectionView
    }()
    
    lazy var listCollectionView: DynamicHeightCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 145)

        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = AppColors.mainColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isScrollEnabled = false
                
        return collectionView 
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topCollectionView)
        view.addSubview(customSegmentedControl)
        view.addSubview(listCollectionView)
        view.addSubview(nextButton)
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let action = UIAction {[weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3) {
                self.nextButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } completion: {[weak self] _ in
                guard let self = self else { return }
                self.nextButton.isHidden = true
                nextButtonDelegate?.obtainNextMoviesPage {
                    self.nextButton.transform = .identity
                    self.nextButton.isHidden = false
                }
            }
        }
        let button = UIButton(primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Дальше", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        return button
    }()
    
    weak var nextButtonDelegate: NextButtonDelegate?
    weak var searchIconDelegate: SearchIconDelegate? {
        didSet {
            searchView.searchIconDelegate = searchIconDelegate
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.mainColor
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(searchView)
        addSubview(scrollView)
        addSubview(activityIndicator)
        addSubview(listActivityIndicator)
        addSubview(errorLabel)
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        customSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchView.heightAnchor.constraint(equalToConstant: 45),
            
            scrollView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            topCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalToConstant: 250),
            
            customSegmentedControl.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor, constant: 40),
            customSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customSegmentedControl.heightAnchor.constraint(equalToConstant: 40),

            listCollectionView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 25),
            listCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            listCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nextButton.topAnchor.constraint(equalTo: listCollectionView.bottomAnchor, constant: 10),
            nextButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            listActivityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            listActivityIndicator.topAnchor.constraint(equalTo: listCollectionView.topAnchor, constant: 10),
            
            errorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
        ])
    }
    
    //MARK: public funcs
    func reloadTopCollectionView() {
        topCollectionView.reloadData()
    }
    
    func reloadCityCollectionView() {
        customSegmentedControl.reloadCollectionView()
    }
    
    func reloadListCollectionView() {
        listCollectionView.reloadData()
        nextButton.isHidden = false
    }
    
    func startUpdatingAllMovies() {
        listCollectionView.isHidden = true
        listActivityIndicator.isHidden = false
        nextButton.isHidden = true
        listActivityIndicator.startAnimating()
    }
    
    func finishUpdatingAllMovies() {
        listActivityIndicator.stopAnimating()
        nextButton.isHidden = false
        listCollectionView.isHidden = false
    }
    
    func showErrorLabel(with error: String) {
        scrollView.isHidden = true
        errorLabel.isHidden = false
        activityIndicator.isHidden = true
        errorLabel.text = error
    }
    
    func hideErrorLabel() {
        scrollView.isHidden = false
        errorLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        errorLabel.text = nil
    }
    
    func stopLoadingPageAnimation() {
        activityIndicator.stopAnimating()
    }
}

protocol NextButtonDelegate: AnyObject {
    func obtainNextMoviesPage(completion: @escaping ()->())
}
