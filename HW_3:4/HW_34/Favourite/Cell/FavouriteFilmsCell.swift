//
//  FavouriteFilmsTableViewCell.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 15.01.25.
//

import UIKit

class FavouriteFilmsCell: UITableViewCell {

    private lazy var moviePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = SpacingConstants.small
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var movieName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Black", size: 20)
        label.textColor = .white
        return label
    }()

    private lazy var movieRating: Rating = {
        let rating = Rating()
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    private lazy var filmDataView: FilmDataView = {
        let view = FilmDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleAndInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            movieName,
            movieRating,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = SpacingConstants.tiny
        stack.distribution = .equalCentering
        stack.alignment = .leading
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWithFilm(_ film: FavouriteFilm) {
        if let imageData = Data(base64Encoded: film.poster.image) {
            moviePoster.image = UIImage(data: imageData)
        } else {
            moviePoster.image = .fail
        }
        movieName.text = film.title
        movieRating.setRating(rating: film.rating)
        filmDataView.setupWithFavouriteFilm(film: film, isVertical: true)
    }

    private func setup() {
        self.backgroundColor = Colors.backgroud
        contentView.addSubview(moviePoster)
        contentView.addSubview(titleAndInfoStack)
        contentView.addSubview(filmDataView)
        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SpacingConstants.small),
            moviePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SpacingConstants.small),
            moviePoster.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: SpacingConstants.little),
            moviePoster.widthAnchor.constraint(equalToConstant: SpacingConstants.width / 3.75),

            titleAndInfoStack.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: SpacingConstants.little),
            titleAndInfoStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: SpacingConstants.little),
            titleAndInfoStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -SpacingConstants.little),
            
            filmDataView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -SpacingConstants.small),
            filmDataView.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: SpacingConstants.little),
        ])
    }
}

extension FavouriteFilmsCell {
    static var identifier: String {
        "\(self)"
    }
}
