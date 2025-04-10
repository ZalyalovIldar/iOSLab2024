import UIKit

class CityCollectionVIewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var nameCity: UILabel = {
        let text = UILabel()
        text.textColor = .white
        text.font = UIFont(name: Constant.Font.poppinsRegular, size: 14)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        return text
    }()
    
    
    private func setupUI() {
        contentView.addSubview(nameCity)
        
        NSLayoutConstraint.activate([
            nameCity.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameCity.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameCity.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameCity.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
    }
    
    func configureCell(with city: City) {
        nameCity.text = city.name
    }
    
}

extension CityCollectionVIewCell {
    static var reuseIndentifier: String {
        return String(describing: self)
    }
}


