import UIKit

class ViewController: UIViewController {
    enum TableSection {
        case main
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(MomentTableViewCell.self, forCellReuseIdentifier: "MomentTableViewCell")
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<TableSection, Moment>!
    private var moments: [Moment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        configureDataSource()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Моменты"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
            self?.presentEditViewController()
        })
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<TableSection, Moment>(tableView: tableView) { tableView, indexPath, moment in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MomentTableViewCell") as? MomentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: moment)
            return cell
        }
        updateDataSource(animated: false)
    }
    
    private func updateDataSource(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, Moment>()
        snapshot.appendSections([.main])
        snapshot.appendItems(moments)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func presentEditViewController() {
        let editVC = EditViewController()
        editVC.completion = { [weak self] newMoment in
            guard let self = self else { return }
            self.moments.append(newMoment)
            self.updateDataSource(animated: true)
        }
        
        let navigationController = UINavigationController(rootViewController: editVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedMoment = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let detailVC = DetailViewController(
            moment: selectedMoment,
            onUpdateMoment: { [weak self] updatedMoment in
                guard let self = self else { return }
                if let index = self.moments.firstIndex(where: { $0.id == updatedMoment.id }) {
                    self.moments[index] = updatedMoment
                    self.updateDataSource(animated: true)
                }
            },
            onDeleteMoment: { [weak self] deletedMoment in
                guard let self = self else { return }
                self.moments.removeAll { $0.id == deletedMoment.id }
                self.updateDataSource(animated: true)
            }
        )
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
