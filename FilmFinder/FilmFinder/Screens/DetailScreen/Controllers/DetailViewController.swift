//
//  DetailViewController.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 03.01.2025.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    private var detailView: DetailView {
        self.view as! DetailView
    }
    
    private var headerCollectionViewDataSource: HeaderCollectionViewDataSource?
    private var headerCollectionViewDelegate: HeaderCollectionViewDelegate?
    private var detailMovie: DetailMovie?
    private lazy var modelData = DetailModelData(delegate: self)
    
    private lazy var actionTrailer = UIAction { [weak self] _ in
        guard let self = self else { return }
        guard let detailMovie = detailMovie else { return }
        
        guard let url = URL(string: detailMovie.trailer) else { return }
        
        let safariController = SFSafariViewController(url: url)
        safariController.modalPresentationStyle = .automatic
    
        self.present(safariController, animated: true)
    }
    
    private lazy var addToFavorite = UIAction { [weak self] _ in
        guard let self = self else { return }
        self.modelData.isFavorite.toggle()
        updateFavoriteButton()
        Task {
            await self.modelData.addMovieToFavorite(detailMovie: self.detailMovie!)
        }
    }
    
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        Task {
            detailView.activityIndicatorText.startAnimating()
            detailMovie = await modelData.getDetailMovie(movieId: id)
            setupHeaderCollectionView()
            updateFavoriteButton()
            configureView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = DetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.configureSegmentControl(items: modelData.obtainItemsSegmentControl())
        configureTrailerButton()
        detailView.segmentControl.delegate = self
        configureNavigationController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        detailView.updateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detailView.trailerButtonPropertyAnimator.startAnimation()
    }
    
    private func configureView() {
        if let detailMovie = detailMovie {
            if let data = detailMovie.dataPoster {
                detailView.setImagePoster(dataImage: data)
            } else {
                detailView.setImagePoster(imageURL: detailMovie.poster.image)
            }
            detailView.setTitleMovie(title: detailMovie.title)
            detailView.setRating(rating: String(detailMovie.rating ?? 0.0))
            detailView.setGenre(genre: detailMovie.genres.first?.name ?? "")
            detailView.setRunningTime(time: "\(detailMovie.runningTime ?? 0) минут")
            detailView.setYear(year: String(detailMovie.year))
            detailView.setDescriptionLabel(description: removeTextBrackets(from: detailMovie.text))
        }
    }
    
    private func setupHeaderCollectionView() {
        if let detailMovie = detailMovie {
            headerCollectionViewDataSource = HeaderCollectionViewDataSource(collectionView: detailView.headerImagesCollectionView, images: detailMovie.images)
            headerCollectionViewDelegate = HeaderCollectionViewDelegate()
            detailView.headerImagesCollectionView.delegate = headerCollectionViewDelegate
        }
    }
    
    private func configureTrailerButton() {
        detailView.trailerButton.addAction(actionTrailer, for: .touchUpInside)
    }
    
    private func updateFavoriteButton() {
        detailView.favoriteButton.isUserInteractionEnabled = false
        UIView.transition(with: detailView.favoriteButton,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            if self.modelData.isFavorite {
                self.detailView.favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                self.detailView.favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }, completion: nil)
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                self.detailView.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: { isFinished in
                guard isFinished else { return }
                UIView.animate(withDuration: 0.2) {
                    self.detailView.favoriteButton.transform = .identity
                }
            }
        )
        detailView.favoriteButton.isUserInteractionEnabled = true
    }
    
    private func configureNavigationController() {
        detailView.favoriteButton.addAction(addToFavorite, for: .touchUpInside)
        self.updateFavoriteButton()
        let favoriteButton = UIBarButtonItem(customView: detailView.favoriteButton)
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func removeTextBrackets(from input: String) -> String {
        var result = ""
        var brakers = false
        
        for char in input {
            if char == "<" {
                brakers = true
            } else if char == ">" {
                brakers = false
            } else if !brakers {
                result.append(char)
            }
        }
        
        return result
    }
}

extension DetailViewController: CustomSegmentControlDelegate {
    func changedIndex(index: Int) {
        switch index {
        case 0: detailView.setDescriptionLabel(description: removeTextBrackets(from: detailMovie?.text ?? ""))
        case 1:
            let description = "Актеры: \(detailMovie?.stars ?? "") \nРежисcеры: \(detailMovie?.writer ?? "")"
            detailView.setDescriptionLabel(description: description)
        default: detailView.setDescriptionLabel(description: "Нету информации")
        }
    }
}

extension DetailViewController: DetailModelDataDelegate {
    func updateCollectionView() {
        if let images = detailMovie?.images {
            headerCollectionViewDataSource?.applySnapshot(images: images, animated: false)
        }
    }
}
