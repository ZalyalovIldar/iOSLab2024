import UIKit
import SDWebImage

class ViewController: UIViewController {

    private let imageUrls = [
        "https://picsum.photos/200/300",
        "https://picsum.photos/250/350",
        "https://picsum.photos/300/400",
        "https://picsum.photos/350/450",
        "https://picsum.photos/400/500",
        "https://picsum.photos/450/550",
        "https://picsum.photos/500/600",
        "https://picsum.photos/550/650",
        "https://picsum.photos/600/700",
        "https://picsum.photos/650/750",
        "https://picsum.photos/700/800",
        "https://picsum.photos/750/850",
        "https://picsum.photos/800/900",
        "https://picsum.photos/850/950",
        "https://picsum.photos/900/1000",
        "https://source.unsplash.com/random/200x300",
        "https://source.unsplash.com/random/250x350",
        "https://source.unsplash.com/random/300x400",
        "https://source.unsplash.com/random/350x450",
        "https://source.unsplash.com/random/400x500",
        "https://source.unsplash.com/random/450x550",
        "https://source.unsplash.com/random/500x600",
        "https://source.unsplash.com/random/550x650",
        "https://source.unsplash.com/random/600x700",
        "https://source.unsplash.com/random/650x750",
        "https://source.unsplash.com/random/700x800",
        "https://loremflickr.com/600/700"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setLayouts()
    }

    private func setLayouts() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrls.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentImage = imageUrls[indexPath.row]
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: Подгрузка и хеширование изображения через SDWebImage, а также подгрузка изображения в фоне и постепенную загрузку по пиксельно
        
        guard let url = URL(string: currentImage) else { return cell }
        imageView.sd_setImage(with: url, placeholderImage: nil,
                              options: [.continueInBackground, .progressiveLoad],
                              completed: nil)
        cell.contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
        ])
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
