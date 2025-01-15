//
//  DetailView.swift
//  Movies
//
//  Created by Павел Калинин on 23.12.2024.
//

import UIKit

class DetailView: UIView {
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    lazy var imagesCollectionView: ImagesCollectionView = {
        let imagesCollectionView = ImagesCollectionView()
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return imagesCollectionView
    }()
    
    private lazy var segmentedControl: CustomSegmentedControl<String> = {
        let segmentedControl = CustomSegmentedControl<String>(items: ["О фильме", "Каст", "Трейлер"], titleProvider: { $0 })
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var descriptionView: DescriptionView = {
        let descriptionView = DescriptionView()
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagesCollectionView)
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionView)
        view.addSubview(segmentedControl)
        view.addSubview(descriptionLabel)
        view.addSubview(starsLabel)
        view.addSubview(safariVideoView)
        view.addSubview(ratingView)
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .searchGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private lazy var safariVideoView: SafariVideoView = {
        let safariVideoView = SafariVideoView()
        safariVideoView.translatesAutoresizingMaskIntoConstraints = false
        safariVideoView.isHidden = true
        return safariVideoView
    }()
    
    private lazy var ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.mainColor
        setupUI()
        startLoadingMovie()
        segmentedControl.onSegmentSelected = {[weak self] selection in
            guard let self = self else { return }
            descriptionLabel.isHidden = true
            starsLabel.isHidden = true
            switch selection {
            case "О фильме":
                descriptionLabel.isHidden = false
            case "Каст":
                starsLabel.isHidden = false
            case "Трейлер":
                safariVideoView.openVideo()
            default:
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(scrollView)
        addSubview(activityIndicator)
        addSubview(errorLabel)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imagesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 210),
            
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            ratingView.bottomAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: -5),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 95),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            posterImageView.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: -50),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            titleLabel.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 10),
            
            descriptionView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            descriptionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 50),
            
            segmentedControl.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            starsLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            starsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            starsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            starsLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            safariVideoView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            safariVideoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            safariVideoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            safariVideoView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
        ])
    }
    
    //MARK: public methods
    func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        descriptionView.configure(with: movie)
        titleLabel.text = movie.title
        descriptionLabel.text = parseHTML(movie.description ?? "")
        starsLabel.text = movie.stars ?? "-"
        safariVideoView.videoURLString = movie.trailerUrl ?? ""
        ratingView.configure(rating: movie.rating)
        Task {
            posterImageView.image = (try? await ImageService.shared.downloadImage(url: movie.poster.image)) ?? .default
        }
    }
    
    func reloadCollectionView() {
        imagesCollectionView.imagesCollectionView.reloadData()
        imagesCollectionView.setupController()
    }
    
    func startLoadingMovie() {
        scrollView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func stopLoadingMovie() {
        scrollView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func showErrorLabel(with error: String) {
        errorLabel.isHidden = false
        activityIndicator.isHidden = true
        errorLabel.text = error
    }
    
    func hideErrorLabel() {
        errorLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        errorLabel.text = nil
    }
    
    //MARK: helping methods
    
    //убирает теги html и парсит в обычную строку
    private func parseHTML(_ html: String) -> String {
        guard let data = html.data(using: .utf8) else {
            return ""
        }
        
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
            return attributedString.string
        } catch {
            print("Ошибка при парсинге HTML: \(error)")
            return ""
        }
    }
}
