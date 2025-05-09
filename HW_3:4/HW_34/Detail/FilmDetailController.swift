//
//  FilmDetailViewController.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 14.01.25.
//

import UIKit
import SafariServices

class FilmDetailController: UIViewController {
    
    private var images: [String] = []
    private let dataManager = FilmDetailDataManager()
    private var trailerLink: String!
    private let coreDataManager = CoreDataManager.shared
    private var currentFilm: FilmDetail!
    private var filmDetailView: FilmDetailView {
        view as! FilmDetailView
    }
    private var propertyAnimator: UIViewPropertyAnimator!
    
    override func loadView() {
        super.loadView()
        view = FilmDetailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(currentFilm)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimator()
        setupPlayerButton()
        
    }
    
    init(withFilm film: FilmDetail) {
        super.init(nibName: nil, bundle: nil)
        currentFilm = film
        trailerLink = currentFilm.trailerLink
        setupData(film)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAnimator() {
        propertyAnimator = UIViewPropertyAnimator(duration: 0.45, curve: .linear, animations: {
            self.filmDetailView.showRatingAndPlayer()
        })
        propertyAnimator.startAnimation()
    }
    
    private func setupPlayerButton() {
        filmDetailView.playerButton.addAction(UIAction { _ in
            guard let url = URL(string: self.trailerLink) else { return }
            
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .automatic
            self.present(safariViewController, animated: true)
        }, for: .touchUpInside)
    }
    
    private func setupNavigationBar(_ film: FilmDetail) {
        let customView = CustomTitle()
        customView.setupWithTitle(title: "Про фильм")
        navigationItem.titleView = customView
        
        let favouriteButton = UIButton()
        favouriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        if dataManager.isFavourite(filmTitle: film.title) {
            favouriteButton.tintColor = .orange
        } else {
            favouriteButton.tintColor = .white
        }

        favouriteButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            
            UIView.animate(withDuration: 0.2, animations: {
                favouriteButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    favouriteButton.transform = .identity
                }
            }
            
            let favouriteFilm = dataManager.convertToFavouriteFilm(filmEntity: film)
            dataManager.updateState(filmTitle: film.title)
            if dataManager.isFavourite(filmTitle: film.title) {
                coreDataManager.saveFavouriteFilm(film: favouriteFilm)
                favouriteButton.tintColor = .orange
                
                UIView.transition(with: favouriteButton, duration: 0.3, options: .transitionCrossDissolve) {
                    favouriteButton.tintColor = .orange
                }
            } else {
                coreDataManager.removeFavouriteFilm(film: favouriteFilm)
                favouriteButton.tintColor = .white
                
                UIView.transition(with: favouriteButton, duration: 0.3, options: .transitionCrossDissolve) {
                    favouriteButton.tintColor = .white
                }
            }
        }, for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteButton)
    }
    
    private func setupData(_ film: FilmDetail) {
        filmDetailView.setUpWithFilm(film)
        film.images.forEach { filmImage in images += [filmImage.image] }
        filmDetailView.filmImagesCollectionView.dataSource = self
    }
    
    private func playTrailer() {
        guard let url = URL(string: trailerLink) else { return }
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true)
    }
}

extension FilmDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmImageCell.identifier, for: indexPath) as! FilmImageCell
        cell.setupWithImage(images[indexPath.item])
        return cell
    }
}
