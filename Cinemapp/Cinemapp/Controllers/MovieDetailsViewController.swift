import UIKit
import WebKit

class MovieDetailsViewController: UIViewController {
    
    //private let webView: WKWebView = WKWebView()

    private let titleLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Пример"
        return label
    }()
    
    private let addToFavouritesButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("+ Избранное", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(addToFavouritesButton)
        navigationItem.hidesBackButton = false
        
        setDetailsConstraints()
    }
    
    func setDetailsConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ]
        
        let addToFavouritesButtonConstraints = [
            addToFavouritesButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            addToFavouritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToFavouritesButton.widthAnchor.constraint(equalToConstant: 200),
            addToFavouritesButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(addToFavouritesButtonConstraints)
    }
    
    func configure(with model: DetailedMovieViewModel){
        titleLabel.text = model.title
        
    }

}
