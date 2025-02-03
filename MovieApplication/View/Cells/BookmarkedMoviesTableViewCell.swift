import UIKit

class BookmarkedMoviesTableViewCell: UITableViewCell {

    private lazy var movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = Constants.tiny
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: Fonts.big)
        label.textColor = .white
        return label
    }()

    private lazy var movieRating: MovieRatingViewSimple = {
        let rating = MovieRatingViewSimple()
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()


    private lazy var calendarView: UIImageView = {
        let calendare = UIImageView(image: UIImage(systemName: "calendar"))
        calendare.tintColor = Colors.lighterGray
        calendare.translatesAutoresizingMaskIntoConstraints = false
        return calendare
    }()

    private lazy var calendarTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.lighterGray
        label.font = UIFont(name: "Montserrat-Medium", size: Fonts.tiny)
        return label
    }()

    private lazy var calendarStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            calendarView,
            calendarTitle,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.nothing
        return stack
    }()

    private lazy var clockView: UIImageView = {
        let clock = UIImageView(image: UIImage(systemName: "clock"))
        clock.tintColor = Colors.lighterGray
        clock.translatesAutoresizingMaskIntoConstraints = false
        return clock
    }()

    private lazy var movieDurationTitle: UILabel = {
        let clock = UILabel()
        clock.translatesAutoresizingMaskIntoConstraints = false
        clock.textColor = Colors.lighterGray
        clock.font = UIFont(name: "Montserrat-Medium", size: Fonts.tiny)
        return clock
    }()

    private lazy var minutesLabel: UILabel = {
        let duration = UILabel()
        duration.text = "Минут"
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.textColor = Colors.lighterGray
        duration.font = UIFont(name: "Montserrat-Medium", size: Fonts.tiny)
        return duration
    }()

    private lazy var movieDurationStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            clockView,
            movieDurationTitle,
            minutesLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.nothing
        return stack
    }()

    private lazy var flagView: UIImageView = {
        let flag = UIImageView(image: UIImage(systemName: "flag"))
        flag.tintColor = Colors.lighterGray
        flag.translatesAutoresizingMaskIntoConstraints = false
        return flag
    }()

    private lazy var countryTitle: UILabel = {
        let country = UILabel()
        country.font = UIFont(name: "Montserrat-Medium", size: Fonts.tiny)
        country.translatesAutoresizingMaskIntoConstraints = false
        country.textColor = Colors.lighterGray

        return country
    }()

    private lazy var countryInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            flagView,
            countryTitle,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.nothing
        return stack
    }()

    private lazy var movieInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            movieRating,
            countryInfoStackView,
            calendarStackView,
            movieDurationStackView
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        stack.spacing = Constants.nothing
        return stack
    }()

    private lazy var titleAndDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            movieTitle,
            movieInfoStackView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.small
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

    func setupWithMovie(_ film: BookmarkedMovie) {
        if let imageData = Data(base64Encoded: film.poster.image) {
            movieImage.image = UIImage(data: imageData)
        } else {
            movieImage.image = .failToLoad
        }
        
        movieTitle.text = film.title
        movieRating.setRating(rating: film.rating)
        calendarTitle.text = "\(film.year)"
        movieDurationTitle.text = "\(film.runningTime)"
        countryTitle.text = "\(Array(film.country.split(separator: ", "))[0])"
    }

    private func setup() {
        self.backgroundColor = Colors.mainGray
        contentView.addSubview(movieImage)
        contentView.addSubview(titleAndDataStackView)
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.ultraTiny),
            movieImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.ultraTiny),
            movieImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Constants.tiny),
            movieImage.widthAnchor.constraint(equalToConstant: Constants.screenWidth / 3.5),

            titleAndDataStackView.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: Constants.tiny),
            titleAndDataStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.tiny),
            titleAndDataStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.tiny),
            titleAndDataStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.tiny),
        ])
    }
}

extension BookmarkedMoviesTableViewCell {
    static var identifier: String {
        "\(self)"
    }
}

