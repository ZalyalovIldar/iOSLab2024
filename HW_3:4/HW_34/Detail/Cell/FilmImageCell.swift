//
//  FilmImageCollectionViewCell.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 14.01.25.
//

import UIKit

class FilmImageCell: UICollectionViewCell {
    
    static var identifier: String { "\(self)" }
    
    private lazy var activity: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .systemGray6
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var filmPoster: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    func setupWithImage(_ image: String) {
        filmPoster.image = nil
        
        activity.startAnimating()
        Task {
            do {
                let image = try await ImageService.downloadImage(from: image)
                filmPoster.image = image
                activity.stopAnimating()
            } catch {
                print("Error of loading image on film: \(error.localizedDescription)")
                activity.stopAnimating()
                filmPoster.image = UIImage(named: "photo")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(activity)
        addSubview(filmPoster)
    
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            filmPoster.topAnchor.constraint(equalTo: self.topAnchor),
            filmPoster.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            filmPoster.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filmPoster.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

