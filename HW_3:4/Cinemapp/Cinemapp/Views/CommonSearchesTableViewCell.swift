import UIKit
import SDWebImage

class CommonSearchesTableViewCell: UITableViewCell {

    static let identifier = "CommonSearchesTableViewCell"
    
    private let movieLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let watchMovieButton: UIButton = {
       
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchPostersImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(searchPostersImageView)
        contentView.addSubview(movieLabel)
        contentView.addSubview(watchMovieButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        let searchPostersImageViewConstraints = [
            searchPostersImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchPostersImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchPostersImageView.widthAnchor.constraint(equalToConstant: 100),
            searchPostersImageView.heightAnchor.constraint(equalToConstant: 100)
        ]

        let movieLabelConstraints = [
            movieLabel.leadingAnchor.constraint(equalTo: searchPostersImageView.trailingAnchor, constant: 20),
            movieLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            movieLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            movieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]

        NSLayoutConstraint.activate(searchPostersImageViewConstraints)
        NSLayoutConstraint.activate(movieLabelConstraints)
    }

    
    public func configureMV(with model: MovieViewModel){
        guard let url = URL(string: model.poster?.image ?? "movieclapper") else {return}
        searchPostersImageView.sd_setImage(with: url, completed: nil)
        movieLabel.text = model.title
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
