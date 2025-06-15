//
//  FilmCollectionViewCell.swift
//  Films
//
//  Created by Артур Мавликаев on 06.01.2025.
//

import UIKit

class MainViewCollectionViewCell: UICollectionViewCell {
    private let filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(filmImageView)
        contentView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            filmImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filmImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            filmImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func startLoading() {
        filmImageView.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    private func stopLoading() {
        filmImageView.isHidden = false
        loadingIndicator.stopAnimating()
    }
    
    func configure(with film: Film) {
        if let url = URL(string: film.image) {
            startLoading()
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self, let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self?.stopLoading()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.filmImageView.image = UIImage(data: data)
                    self.stopLoading()
                }
            }.resume()
        } else {
            filmImageView.image = nil
        }
    }
    func configureWithUrl(with url: String) {
        if let url = URL(string: url) {
            startLoading()
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self, let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self?.stopLoading()
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.filmImageView.image = UIImage(data: data)
                    self.stopLoading()
                }
            }.resume()
        } else {
            filmImageView.image = nil
        }
    }
}
