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
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = false
        return collectionView
    }()
    
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private func setupLayout() {
        let mainStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [dateLabel, descriptLabel, picturesCollectionView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.distribution = .fill
            return stackView
        }()
        
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            picturesCollectionView.heightAnchor.constraint(equalToConstant: 200),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func configureCell(with post: Post){
        dateLabel.text = post.date
        descriptLabel.text = post.text
        pictures = post.pictures
        setCollectionHeight()
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
    
    private func setCollectionHeight(){
        if pictures.count > 0 {
            picturesCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        } else {
            picturesCollectionView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
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
        let image = UIImage(named: pictures[indexPath.item])!
        let aspectRatio = image.size.height/image.size.width
        let width: CGFloat = (picturesCollectionView.frame.width-10)/2
        let height: CGFloat = width * aspectRatio
        return CGSize(width:width, height: height)
    }
}
