import UIKit

class PostCell: UITableViewCell{

    private var pictures: [String] = []
    
    private lazy var descriptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        label.lineBreakMode = .byTruncatingTail
        return label
        }()
    
    private lazy var dateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private lazy var picturesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private func setupLayout() {
        let mainStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [picturesCollectionView, dateLabel, descriptLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 5
            return stackView
        }()
        
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            picturesCollectionView.heightAnchor.constraint(equalToConstant: 150),
            picturesCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            descriptLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configureCell(with post: Post){
        dateLabel.text = post.date
        descriptLabel.text = post.text
        pictures = post.pictures
        picturesCollectionView.reloadData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        descriptLabel.text = nil
        pictures = []
        picturesCollectionView.reloadData()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        picturesCollectionView.register(PictureCell.self, forCellWithReuseIdentifier: PictureCell.reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PostCell:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCell.reuseIdentifier, for: indexPath) as! PictureCell
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let postimage = UIImage(named: pictures[indexPath.item])!
        _ = postimage.size.height/postimage.size.width
        let height: CGFloat = 150
        let width = collectionView.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
}
