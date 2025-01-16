//
//  FilmDetailView.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 14.01.25.
//

import UIKit

class FilmDetailView: UIView {
    
    private var selectedSegmentIndex = 1 {
        didSet {
            if selectedSegmentIndex == 0 {
                selectedDescription.text = "    " + validDescription
            } else {
                selectedDescription.text = "    " + film.stars
            }
        }
    }
    private var film: FilmDetail!
    private lazy var validDescription = makeValid(film.description)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = Colors.backgroud
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .systemGray6
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    lazy var filmImagesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = .init(width: SpacingConstants.width, height: SpacingConstants.width / 1.8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Colors.backgroud
        collectionView.register(FilmImageCell.self, forCellWithReuseIdentifier: FilmImageCell.identifier)
        return collectionView
    }()
    
    private lazy var filmPoster: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = SpacingConstants.small
        return image
    }()
    
    private lazy var filmTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Black", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textAlignment = .left
        label.textColor = .white
        label.lineBreakMode = .byClipping
        return label
    }()
    
    lazy var playerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.display"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.alpha = 0
        button.backgroundColor = .systemRed.withAlphaComponent(0.8)
        return button
    }()
    
    private lazy var ratingView: Rating = {
        let ratingView = Rating()
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.alpha = 0
        return ratingView
    }()
    
    private lazy var ratingAndPlayerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            playerButton,
            ratingView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = SpacingConstants.little
        return stack
    }()
    
    private lazy var filmDataView: FilmDataView = {
        let view = FilmDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["О фильме", "Актеры"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.tintColor = .clear
        control.selectedSegmentTintColor = .systemGray
        if let fontBig = UIFont(name: "Poppins-Black", size: FontConstants.big),
           let fontNormal = UIFont(name: "Poppins-Regular", size: FontConstants.normal) {
        
            control.setTitleTextAttributes([
                .foregroundColor: UIColor.white,
                .font: fontBig
            ], for: .selected)
            
            control.setTitleTextAttributes([
                .foregroundColor: UIColor.darkGray,
                .font: fontNormal
            ], for: .normal)
        }
        control.addAction(UIAction { _ in
            self.selectedSegmentIndex = control.selectedSegmentIndex
        }, for: .valueChanged)
        return control
    }()
    
    private lazy var segmentControllStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            segmentControl,
            selectedDescription
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = SpacingConstants.small
        return stack
    }()
    
    private lazy var selectedDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.textColor = .white
        label.numberOfLines = .zero
        return label
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showRatingAndPlayer() {
        ratingView.alpha = 1
        playerButton.alpha = 1
    }
    
    func setUpWithFilm(_ film: FilmDetail) {
        self.film = film
        ratingView.setRating(rating: film.rating ?? 0.0)
        filmTitle.text = film.title
        selectedDescription.text = validDescription
        
        activityIndicator.startAnimating()
        filmPoster.image = nil
        Task { [weak self] in
            guard let self else { return }
            do {
                let image = try await ImageService.downloadImage(from: film.poster.image)
                activityIndicator.stopAnimating()
                filmPoster.image = image
            } catch {
                activityIndicator.stopAnimating()
                filmPoster.image = .fail
                print("Error during loading \(film.title) avatar image: \(error.localizedDescription)")
            }
        }
        filmDataView.setupWithFilm(film: film, isVertical: false)
    }
    
    private func setup() {
        self.backgroundColor = Colors.backgroud
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(scrollView)
        
        scrollView.addSubview(activityIndicator)
        scrollView.addSubview(filmImagesCollectionView)
        scrollView.addSubview(filmPoster)
        scrollView.addSubview(filmTitle)
        scrollView.addSubview(ratingAndPlayerStackView)
        scrollView.addSubview(filmDataView)
        scrollView.addSubview(segmentControllStackView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            filmImagesCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            filmImagesCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            filmImagesCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            filmImagesCollectionView.heightAnchor.constraint(equalToConstant: SpacingConstants.width / 1.8),
            scrollView.widthAnchor.constraint(equalTo: filmImagesCollectionView.widthAnchor),
            
            filmPoster.centerYAnchor.constraint(equalTo: filmImagesCollectionView.bottomAnchor),
            filmPoster.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: SpacingConstants.big),
            filmPoster.heightAnchor.constraint(equalTo: filmImagesCollectionView.heightAnchor, multiplier: 0.75),
            filmPoster.widthAnchor.constraint(equalToConstant: SpacingConstants.width / 3.5),
            
            activityIndicator.centerXAnchor.constraint(equalTo: filmPoster.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: filmPoster.centerYAnchor),
            
            filmTitle.leadingAnchor.constraint(equalTo: filmPoster.trailingAnchor, constant: SpacingConstants.little),
            filmTitle.bottomAnchor.constraint(equalTo: filmPoster.bottomAnchor),
            filmTitle.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -SpacingConstants.little),
            
            ratingAndPlayerStackView.trailingAnchor.constraint(equalTo: filmImagesCollectionView.trailingAnchor, constant: -SpacingConstants.little),
            ratingAndPlayerStackView.bottomAnchor.constraint(equalTo: filmImagesCollectionView.bottomAnchor, constant: -SpacingConstants.little),
            
            filmDataView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            filmDataView.topAnchor.constraint(equalTo: filmPoster.bottomAnchor, constant: SpacingConstants.small),
            
            segmentControllStackView.topAnchor.constraint(equalTo: filmDataView.bottomAnchor, constant: SpacingConstants.medium),
            segmentControllStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: SpacingConstants.small),
            segmentControllStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -SpacingConstants.small),
            segmentControllStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func makeValid(_ text: String) -> String {
        var validText = "",
            isValid = true
        for char in text {
            if char == "<" {
                isValid = false
            } else if char == ">" {
                isValid = true
            } else if isValid {
                validText += String(char)
            }
        }
        return validText
    }
}
