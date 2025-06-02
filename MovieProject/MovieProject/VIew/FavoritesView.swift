import UIKit

class FavoritesView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.init(hex: "242A32")
    }
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FavoriteScreenTableViewCell.self, forCellReuseIdentifier: FavoriteScreenTableViewCell.reuseIndentifier)
        table.backgroundColor = UIColor.init(hex: "242A32")
        table.delegate = self
        return table
    }()
    
    private func setupLayout() {
        addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: topAnchor),
            table.leadingAnchor.constraint(equalTo: leadingAnchor),
            table.trailingAnchor.constraint(equalTo: trailingAnchor),
            table.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupTableViewDataSource(_ dataSource: UITableViewDataSource) {
        table.dataSource = dataSource
    }
}

extension FavoritesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.screenHeight / 5
    }
}
