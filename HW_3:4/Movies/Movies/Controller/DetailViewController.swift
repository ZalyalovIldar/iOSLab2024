//
//  DetailViewController.swift
//  Movies
//
//  Created by Павел Калинин on 24.12.2024.
//

import UIKit

class DetailViewController: UIViewController {
    private let detailView = DetailView()
    private let imagesDataSource = ImagesDataSource(images: [])
    private var movie: Movie?
    
    var error: String? {
        didSet {
            if let error = error {
                detailView.showErrorLabel(with: error)
            } else {
                detailView.hideErrorLabel()
            }
        }
    }
    
    private lazy var saveTabBarItem: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bookmark
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped)))
        return imageView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        detailView.imagesCollectionView.imagesCollectionView.delegate = self
        detailView.imagesCollectionView.imagesCollectionView.dataSource = imagesDataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let movie = movie {
            let isMovieSaved = CoreDataManager.shared.isSaved(movieID: movie.id)
            saveTabBarItem.image = isMovieSaved ? .bookmarkFilled : .bookmark
        }
    }
    
    override func loadView() {
        view = detailView
    }
    
    private func setupNavigationBar() {
        let navBar = navigationController!.navigationBar
        navigationItem.title = "Подробно"
        navBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveTabBarItem)
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        self.movie = movie
        detailView.configure(with: movie)
        detailView.stopLoadingMovie()
        imagesDataSource.updateDataSource(movie.images ?? [])
        detailView.reloadCollectionView()
        
        let isMovieSaved = CoreDataManager.shared.isSaved(movieID: movie.id)
        saveTabBarItem.image = isMovieSaved ? .bookmarkFilled : .bookmark
    }
    
    //MARK: objc methods
    @objc private func saveButtonTapped() {
        guard let movie = movie else { return }
        let isMovieSaved = CoreDataManager.shared.isSaved(movieID: movie.id)
        
        if isMovieSaved {
            CoreDataManager.shared.removeFromFavorites(movieID: movie.id)
        } else {
            CoreDataManager.shared.saveSavedMovie(movie: movie)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.saveTabBarItem.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.saveTabBarItem.image = !isMovieSaved ? .bookmarkFilled : .bookmark
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.saveTabBarItem.transform = .identity
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailView.imagesCollectionView.currentPage = indexPath.item + 1
        
        detailView.imagesCollectionView.pagers.forEach { pager in
            pager.constraints.forEach { constr in
                pager.removeConstraint(constr)
            }
            
            if detailView.imagesCollectionView.currentPage == pager.tag {
                pager.layer.opacity = 1
                detailView.imagesCollectionView.pagerWidthAnchor = pager.widthAnchor.constraint(equalToConstant: 20)
            } else {
                pager.layer.opacity = 0.5
                detailView.imagesCollectionView.pagerWidthAnchor = pager.widthAnchor.constraint(equalToConstant: 10)
            }
            
            detailView.imagesCollectionView.pagerWidthAnchor?.isActive = true
            pager.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
    }
}
