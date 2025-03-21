//
//  ViewController.swift
//  Homework
//
//  Created by Павел on 27.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: UserTableViewCell.identifier)
        table.register(ExperienceTableViewCell.self, forCellReuseIdentifier: ExperienceTableViewCell.identifier)
        table.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        table.estimatedRowHeight = 300
        return table
    }()
    
    private lazy var tableHeaderView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 250)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AvatarFinal")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "О себе"
        titleLabel.textColor = .gray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(imageView)
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
        ])
        
        DispatchQueue.main.async {
            imageView.layer.cornerRadius = imageView.frame.width / 2
        }
        
        return headerView
    }()
    
    private var dataSource: User = User(surname: "", name: "", patronymic: "", age: 0, city: "")
    private var experiences: [Experience] = [
        Experience(year: 2019, description: """
            Позиция: IOS junior разработчик
            Компания: Aston
            - Разработка и поддержка небольших приложений для западного рынка 
            - Есть реализованные мной с 0 проекты. 
            Стек: MVC, MVP, Objective-c, Alamofire, PurchaseManage 
            """),
        Experience(year: 2021, description: """
            Позиция: IOS middle разработчик
            Компания: Сбер
            - работа с RESTful API, обработка ответов и управление данными в приложении;
            - реализация сложных кастомных анимации;
            - разработка и поддержка сетевого слоя приложения;
            - организовал работу с push-уведомлениями;
            - соблюдение практик Code review, Pair programming в ходе формирования команды;
            - решение проблем с приложением
            Стек: Swift, UiKit, VIPER, Swinject, Alamofire, SnapKit, XIB, Lottie, Firebase
            """),
        Experience(year: 2024, description: """
            Позиция: IOS senior разработчик 
            Компания: Мегамаркет 
            - Разработал с нуля многофункциональные виджеты с разными видами таймеров и сделал их
            переиспользуемыми для внедрения в другие модули приложения
            - Полноценный рефакторинг модуля списка заказов с перестройкой архитектуры и
            декомпозицией определенных компонентов
            Стек: Swift, UIKit(+ кастомный фреймворк), MVVM+Router, gRPC, SPM+CocoaPods, GitLab CI + Fastlane, Gitflow
            """)]
        
        private var images: [UIImage] = ["Photo1", "Photo2"].compactMap { UIImage(named: $0) }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            dataSource = User(surname: "Сушков", name: "Павел", patronymic: "Андреевич", age: 19, city: "Казань")
            view.addSubview(tableView)
            view.backgroundColor = .white
            setupLayout()
            tableView.tableHeaderView = tableHeaderView
        }
        
        private func setupLayout() {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    enum Sections: Int {
        case aboutMe = 0
        case experience = 1
        case photography = 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        
        switch section {
        case .aboutMe:
            return 1
        case .experience:
            return experiences.count
        case .photography:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .aboutMe:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            cell.configureCell(with: dataSource)
            return cell
        case .experience:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExperienceTableViewCell.identifier, for: indexPath) as! ExperienceTableViewCell
            cell.configureCell(experience: experiences[indexPath.row])
            return cell
        case .photography:
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
            cell.configureCell(with: images)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let section = Sections(rawValue: section) else { return UIView() }
        
        switch section {
        case .experience:
            titleLabel.text = "Опыт работы"
        case .photography:
            titleLabel.text = "Фото"
        default:
            break
        }
        
        headerView.addSubview(titleLabel)
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Sections(rawValue: section) else { return 40 }
        return section == .aboutMe ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Sections(rawValue: indexPath.section) else {
            return UITableView.automaticDimension
        }
        
        switch section {
        case .experience:
            let experience = experiences[indexPath.row]
            let width = tableView.frame.width - 20
            let font = UIFont.systemFont(ofSize: 17)
            let size = experience.description.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [.font: font],
                                                           context: nil).size
            return size.height + 60
        case .photography:
            let width = tableView.frame.width - 20
            guard let firstImage = images.first else { return 0 }
            let aspectRatio = firstImage.size.height / firstImage.size.width
            return width * aspectRatio
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section) else { return }
        if section == .aboutMe {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = tableView.separatorInset
        }
    }
}
