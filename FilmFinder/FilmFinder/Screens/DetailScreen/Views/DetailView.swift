//
//  DetailView.swift
//  FilmFinder
//
//  Created by Тагир Файрушин on 03.01.2025.
//

import UIKit

class DetailView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var activityIndicatorText: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    lazy var headerImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = Color.backgroundColor
        return collectionView
    }()
    
    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleMovieLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: Constant.Font.extraLarge)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingView: CustomRatingView = {
        let view = CustomRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var runningView: CustomRunningTime = {
        let view = CustomRunningTime()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var yearView: CustomYearView = {
        let view = CustomYearView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var genreView: CustomGenreView = {
        let view = CustomGenreView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.distribution = .equalSpacing
        
        stack.addArrangedSubview(yearView)
        stack.addArrangedSubview(createSeparator())
        stack.addArrangedSubview(runningView)
        stack.addArrangedSubview(createSeparator())
        stack.addArrangedSubview(genreView)
        
        return stack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: Constant.Font.regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var segmentControl: CustomSegmentControl = {
        let segmentControl = CustomSegmentControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    lazy var trailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var trailerButtonPropertyAnimator: UIViewPropertyAnimator = {
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            self.trailerButton.alpha = 1
        }
        return propertyAnimator
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.backgroundColor
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = Color.customGrey
        separator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    
    func configureSegmentControl(items: [String]) {
        segmentControl.setItems(items)
    }
    
    func setImagePoster(imageURL: String? = nil, dataImage: Data? = nil) {
        activityIndicator.startAnimating()
        
        if let dataImage = dataImage {
            movieImage.image = UIImage(data: dataImage)
            activityIndicator.stopAnimating()
            return
        }
        
        if let imageURL = imageURL {
            Task {
                do {
                    let image = try await ImageService.downloadImage(from: imageURL)
                    activityIndicator.stopAnimating()
                    movieImage.image = image
                }
            }
        }
    }
    
    func setTitleMovie(title: String) {
        titleMovieLabel.text = title
    }
    
    func setRating(rating: String) {
        ratingView.setRating(rating: rating)
    }
    
    func setYear(year: String) {
        yearView.setYear(year: year)
    }
    
    func setRunningTime(time: String) {
        runningView.setTime(runningTime: time)
    }
    
    func setGenre(genre: String) {
        genreView.setGenre(genre: genre)
    }
    
    func setDescriptionLabel(description: String) {
        descriptionLabel.text = description
        activityIndicatorText.stopAnimating()
    }
    
    func updateLayout() {
        let itemWidth = self.bounds.width - safeAreaInsets.left - safeAreaInsets.right
        if let layout = headerImagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = .init(width: itemWidth, height: itemWidth / 1.6)
            layout.invalidateLayout()
        }
        
        segmentControl.updateLayout()
    }
    
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImagesCollectionView)
        contentView.addSubview(movieImage)
        contentView.addSubview(titleMovieLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(activityIndicatorText)
        contentView.addSubview(segmentControl)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(trailerButton)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerImagesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImagesCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.3),
            
            movieImage.bottomAnchor.constraint(equalTo: headerImagesCollectionView.bottomAnchor, constant: Constant.DesignMetrics.headerHeight),
            movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.DesignMetrics.extraLargePadding),
            movieImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.18),
            movieImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3),
            
            titleMovieLabel.topAnchor.constraint(equalTo: headerImagesCollectionView.bottomAnchor, constant: Constant.Constraint.marginExtraLarge),
            titleMovieLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: Constant.Constraint.marginExtraLarge),
            titleMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.DesignMetrics.sectionSpacing),
            
            ratingView.bottomAnchor.constraint(equalTo: headerImagesCollectionView.bottomAnchor, constant: -Constant.Constraint.marginExtraLarge),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Constraint.marginExtraLarge),
            ratingView.heightAnchor.constraint(equalToConstant: Constant.DesignMetrics.mediumPadding),
            ratingView.widthAnchor.constraint(equalToConstant: Constant.DesignMetrics.ratingWeight),
            
            trailerButton.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),

            trailerButton.trailingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: -Constant.Constraint.marginExtraLarge),
            trailerButton.heightAnchor.constraint(equalToConstant: Constant.DesignMetrics.mediumPadding),
            trailerButton.widthAnchor.constraint(equalToConstant: Constant.DesignMetrics.mediumPadding),
            
            infoStackView.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: Constant.DesignMetrics.smallPadding),
            infoStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            segmentControl.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: Constant.Constraint.marginHuge),
            segmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.DesignMetrics.largePadding),
            segmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.DesignMetrics.largePadding),
            segmentControl.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05),
            
            descriptionLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Constant.Constraint.marginHuge),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.DesignMetrics.largePadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.DesignMetrics.largePadding),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Constraint.marginHuge),
            
            
            activityIndicator.centerXAnchor.constraint(equalTo: movieImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: movieImage.centerYAnchor),
            
            activityIndicatorText.centerXAnchor.constraint(equalTo: descriptionLabel.centerXAnchor),
            activityIndicatorText.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor, constant: 150)
        ])
    }
}
