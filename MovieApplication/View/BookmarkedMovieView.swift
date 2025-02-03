import UIKit

class BookmarkedMovieView: UIView, UITableViewDelegate {
    
    private lazy var bookmarkedMovieTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = Constants.screenWidth / 2
        table.separatorStyle = .none
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = Colors.mainGray
        table.register(BookmarkedMoviesTableViewCell.self, forCellReuseIdentifier: BookmarkedMoviesTableViewCell.identifier)
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        bookmarkedMovieTableView.reloadData()
    }
    
    func setDataSource(dataSource: BookmarkedMoviesTableViewDataSource) {
        bookmarkedMovieTableView.dataSource = dataSource
    }
    
    private func setup() {
        self.backgroundColor = Colors.mainGray
        addSubview(bookmarkedMovieTableView)
        NSLayoutConstraint.activate([
            bookmarkedMovieTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            bookmarkedMovieTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            bookmarkedMovieTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            bookmarkedMovieTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

