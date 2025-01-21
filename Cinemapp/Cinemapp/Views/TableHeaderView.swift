import UIKit

class TableHeaderView: UIView {
    
    private let watchButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Смотреть", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addToFavouritesButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("+ Избранное", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let headerImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        setupGradient()
        addSubview(watchButton)
        addSubview(addToFavouritesButton)
        addConstr()
    }
    
    private func addConstr(){
        let watchButtonConstraints = [
            watchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            watchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            watchButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let favButtonConstraints = [
            addToFavouritesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            addToFavouritesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            addToFavouritesButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(watchButtonConstraints)
        NSLayoutConstraint.activate(favButtonConstraints)
    }
    
    private func setupGradient(){
        let gradLayer = CAGradientLayer()
        gradLayer.colors = [
            UIColor.clear,
            UIColor.systemBackground.cgColor
        ]
        gradLayer.frame = bounds
        layer.addSublayer(gradLayer)
    }
    
    public func configure(with model: String){
        guard let url = URL(string: model) else {return}
        headerImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "movieclapper"), completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
