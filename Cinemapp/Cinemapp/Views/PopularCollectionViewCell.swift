import UIKit
import SDWebImage

class PopularCollectionViewCell: UICollectionViewCell {
    static let identifier = "PopularCollectionViewCell"
    
    private let posterImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String){
        guard let url = URL(string: model) else {return}
        posterImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "movieclapper"), completed: nil)
        print(url)
    }
}
