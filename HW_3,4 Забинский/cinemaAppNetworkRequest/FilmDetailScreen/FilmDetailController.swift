//
//  FilmDetailViewController.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 26.12.2024.
//

import UIKit
import SafariServices

class FilmDetailController: UIViewController {
    private var customView: FilmDetailView {
        view as! FilmDetailView
    }
    private var film: FilmWithInfo!
    private var images: [String] = []
    private var filmImagesCollectionViewDataSource: FilmImagesCollectionViewDataSource?
    private var filmImagesCollectionViewDelegate: FilmImagesCollectionViewDelegate?
    private let dataManager = FilmDetailDataManager()
    private var trailerLink: String!
    private var openControllerAnimator: UIViewPropertyAnimator?
    private var closeControllerAnimator: UIViewPropertyAnimator?
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    override func loadView() {
        super.loadView()
        view = FilmDetailView(playTrailerDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(film)
        setupCollectionViewData()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        openControllerAnimator?.startAnimation()
    }
    
    init(withFilm film: FilmWithInfo) {
        super.init(nibName: nil, bundle: nil)
        self.film = film
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar(_ film: FilmWithInfo) {
        navigationItem.titleView = NavigationItemView(title: "О фильме")
        
        let dismissButton = getDismissButton()
        let favouriteButton = getFavouriteButton()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
    }
    
    private func getDismissButton() -> UIButton {
        let button = UIButton()
        setupCloseControllerAnimator(button: button)
        setupOpenControllerAnimator(button: button)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: Constants.small).isActive = true
        button.widthAnchor.constraint(equalToConstant: Constants.small).isActive = true
        
        button.addAction(UIAction { [weak self] _ in
            self?.closeControllerAnimator?.startAnimation()
        }, for: .touchUpInside)

        return button
    }
    
    private func setupOpenControllerAnimator(button: UIButton) {
        button.transform = CGAffineTransform(scaleX: 0, y: 0)
        openControllerAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            button.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        let secondAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        openControllerAnimator?.addCompletion { _ in
            secondAnimator.startAnimation()
        }
    }

    private func setupCloseControllerAnimator(button: UIButton) {
        closeControllerAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            button.transform = CGAffineTransform(rotationAngle: .pi)
        }
        let secondAnimator = UIViewPropertyAnimator(duration: 0.65, curve: .easeInOut) {
            let rotation = CGAffineTransform(rotationAngle: .pi * -2)
            let scale = CGAffineTransform(scaleX: 2, y: 2)
            button.transform = rotation.concatenating(scale)
        }
        if let closeControllerAnimator {
            secondAnimator.addCompletion { _ in
                UIView.animate(withDuration: 0.2) {
                    button.alpha /= 2
                }
                self.dismiss(animated: true)
            }
            closeControllerAnimator.addCompletion { _ in
                secondAnimator.startAnimation()
            }
        }
    }
    
    private func getFavouriteButton() -> UIButton {
        let favouriteButton = UIButton()
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.heightAnchor.constraint(equalToConstant: Constants.small * 1.2).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: Constants.small).isActive = true
        /// Использовал image'ы из assets'ов потому что с UIImate(systemName: "bookmark") при анимациях были глитчи
        favouriteButton.setImage(dataManager.getFavouriteButtonImage(for: film), for: .normal)
        
        let favouriteButtonAction = UIAction { [weak self] _ in
            guard let self else { return }
            feedbackGenerator.impactOccurred()
            dataManager.switchFilmState(film: film)

            if dataManager.isFavourite(filmTitle: film.title) {
                Animations.addFilmToFavouriteAnimation(button: favouriteButton)
            } else {
                Animations.shake(favouriteButton) { favouriteButton in
                    favouriteButton.setImage(.bookmarkWhite, for: .normal)
                    Animations.shake(favouriteButton)
                }
            }
        }
        favouriteButton.addAction(favouriteButtonAction, for: .touchUpInside)
        return favouriteButton
    }
    
    private func setupData() {
        customView.setUpWithFilm(film)
        images = dataManager.getFilmImages(film)
        trailerLink = dataManager.getTrailerLink(film)
    }
    
    private func setupCollectionViewData() {
        filmImagesCollectionViewDataSource = FilmImagesCollectionViewDataSource(images: images)
        if let filmImagesCollectionViewDataSource {
            filmImagesCollectionViewDelegate = FilmImagesCollectionViewDelegate(withData: filmImagesCollectionViewDataSource.getData(), viewController: self)
        }
        
        customView.setDelegateForFilmImagesCollectionView(with: filmImagesCollectionViewDelegate)
        customView.setDataSourceForFilmImagesCollectionView(with: filmImagesCollectionViewDataSource)
    }
    
    private func playTrailer() {
        guard let url = URL(string: trailerLink) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .automatic
        self.present(safariViewController, animated: true)
    }
}

extension FilmDetailController: PlayTrailerDelegate {
    func play() {
        playTrailer()
    }
}
