import UIKit

class ProfileViewController: UIViewController {
    
    let tableView = UITableView()
    var userProfile: UserProfile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfile = UserProfile(
            fullName: "Шамсутдинов Камиль",
            age: 19,
            city: "Казань",
            workExperience: "1 месяц в iOS разработке",
            photos: ["photo1", "photo2", "photo3"]
        )
        
        setupTableView()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "AboutMeCell", bundle: nil), forCellReuseIdentifier: "AboutMeCell")
        
        tableView.register(WorkExperienceCell.self, forCellReuseIdentifier: "WorkExperienceCell")
        tableView.register(PhotosCell.self, forCellReuseIdentifier: "PhotosCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "О себе"
        case 1:
            return "Опыт работы"
        case 2:
            return "Фото"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeCell", for: indexPath) as! AboutMeCell
            cell.configure(with: userProfile)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkExperienceCell", for: indexPath) as! WorkExperienceCell
            cell.configure(with: userProfile)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
            cell.configure(with: userProfile?.photos ?? [])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 200
        default:
            return 44
        }
    }
    
}

