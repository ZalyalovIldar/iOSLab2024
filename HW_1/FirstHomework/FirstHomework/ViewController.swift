import UIKit

class ViewController: UIViewController {
    var dataSource:[[String]] = []
    var headersSource:[String] = []
    var images:[String] = []
    var tableBottomConstraint: NSLayoutConstraint?
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCellIdentifier")
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "CustomCellIdentifier")
        tableView.register(SecondTableViewCell.self, forCellReuseIdentifier: "SecondCellIdentifier")
        tableView.register(ThirdTableViewCell.self, forCellReuseIdentifier: "ThirdCellIdentifier")
        
        headersSource = ["","О себе", "Опыт работы", "Фотографии"]
        dataSource = [["pfp"],["Котов Александр Александрович", "20 лет","Котовск"], ["2020 - Google", "2022 - Apple", "2023 - Microsoft", "2024 - проверка текста на объем в несколько строчек"], ["withFriends", "brothers","scooter","sleeping"]]
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 3 {
            return 1
        } else {
            return dataSource[section].count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headersSource[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCellIdentifier", for: indexPath) as! ProfileTableViewCell
            cell.configure(with: UIImage(named: dataSource[indexPath.section][indexPath.row]) ?? UIImage())
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellIdentifier", for: indexPath) as! CustomViewCell
            cell.titleLabel.text = dataSource[indexPath.section][indexPath.row]
            return cell
            
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCellIdentifier", for: indexPath) as! SecondTableViewCell
            cell.descriptionLabel.text = dataSource[indexPath.section][indexPath.row]
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdCellIdentifier", for: indexPath) as! ThirdTableViewCell
            cell.configure(with: dataSource[indexPath.section])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 170
        }
        if indexPath.section == 3{
            return 200
        }
        return UITableView.automaticDimension
    }

}

