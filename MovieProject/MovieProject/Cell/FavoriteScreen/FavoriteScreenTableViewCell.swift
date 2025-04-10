import UIKit

class FavoriteScreenTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var poster: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = Constant.imageMediumCornerRadius
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var title: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: Constant.Font.poppinsRegular, size: 18)
        text.textColor = .white
        return text
    }()
    
    private lazy var raitingLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = Constant.orangeColor
        return text
    }()
    
    private lazy var genreLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .white
        text.numberOfLines = 1
        text.font = UIFont(name: Constant.Font.poppinsRegular, size: 12)
        return text
    }()
    
    private lazy var dataLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .white
        text.font = UIFont(name: Constant.Font.poppinsRegular, size: 12)
        return text
    }()
    
    private lazy var durationLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .white
        text.font = UIFont(name: Constant.Font.poppinsRegular, size: 12)
        return text
    }()
    
    private lazy var raitingIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = Constant.orangeColor
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = .star
        return icon
    }()
    
    private lazy var genreIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = .ticket
        return icon
    }()
    
    private lazy var dataIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = .calendarBlank
        return icon
    }()
    
    private lazy var durationIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = .clock
        return icon
    }()
    
    private lazy var raitingStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [raitingIcon, raitingLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constant.FavoriteView.stackViewSpaicing
        return stack
    }()
    
    private lazy var genreStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [genreIcon, genreLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constant.FavoriteView.stackViewSpaicing
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dataIcon, dataLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constant.FavoriteView.stackViewSpaicing
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var durationStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [durationIcon, durationLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constant.FavoriteView.stackViewSpaicing
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var movieInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [raitingStackView, genreStackView, dataStackView, durationStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constant.FavoriteView.mainStackViewSpaicing
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, movieInfoStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constant.FavoriteView.stackViewSpaicing
        stack.alignment = .leading
        return stack
    }()
    
    private func setupLayout() {
        self.backgroundColor = Constant.grayColor
        addSubview(poster)
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Padding.medium),
            poster.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: Constant.Padding.medium),
                 poster.widthAnchor.constraint(equalToConstant: Constant.screenWidth / 4.5),
                 poster.heightAnchor.constraint(equalToConstant: Constant.screenHeight / 6.5),

            mainStackView.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: Constant.Padding.medium),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Padding.medium),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.Padding.xxxLarge),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.Padding.medium)
        ])
    }
    
    func configure(movie: MovieFavoriteEntites) {
        Task {
            do {
                poster.image = try await ImageService.downloadImage(by: movie.poster!)
            } catch {
                poster.image = .notFound
            }
        }
        title.text = movie.title
        raitingLabel.text = movie.raiting == 0 ? "Нет оценки" : "\(movie.raiting)"
        dataLabel.text = "\(movie.year)"
        genreLabel.text = movie.genre
        durationLabel.text = "\(movie.duration)" + " минуты"
    }
}

extension FavoriteScreenTableViewCell {
    static var reuseIndentifier: String {
        return String(describing: self)
    }
}
