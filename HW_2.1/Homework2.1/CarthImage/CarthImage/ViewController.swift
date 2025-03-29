import UIKit
import SDWebImage

class ViewController: UIViewController {

    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadRandomImage()
    }

    private func setupViews() {
        view.addSubview(imageView)
        view.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

        ])

    }

    private func loadRandomImage() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                guard let imageUrl = json?["message"] as? String else { return }
                
                DispatchQueue.main.async {
                    
                    guard let image_url = URL(string: imageUrl) else { return }
                    self.imageView.sd_setImage(with: image_url, placeholderImage: UIImage(named: "placeholder"))
                }
            } catch {
                print("Ошибка парсинга JSON: \(error)")
            }
        }.resume()
    }
}

