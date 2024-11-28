//
//  ViewController.swift
//  HW_1
//
//  Created by Ильнур Салахов on 01.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView:UITableView  = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: CustomCellWithXib.self), bundle: nil), forCellReuseIdentifier: String(describing: CustomCellWithXib.self))
        tableView.register(SecondCell.self, forCellReuseIdentifier: String(describing: SecondCell.self))
        tableView.register(ThirdCell.self, forCellReuseIdentifier: String(describing: ThirdCell.self))
        return tableView
        
    }()
    
    let stackView = UIStackView()
    
    var dataSoource :  [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User(fullName: "Салахов Ильнур Маратович", age: "19", currentPlace: "Казань", workExpierience: "Без опыта", imageUser: UIImage(named: "userImage"))
        dataSoource.append(user)
        
        let imageOfUserView = UIImageView()
        imageOfUserView.image = user.imageUser
        imageOfUserView.translatesAutoresizingMaskIntoConstraints = false
        imageOfUserView.contentMode = .scaleAspectFit
            

        stackView.addArrangedSubview(imageOfUserView)
        stackView.addArrangedSubview(tableView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false


        view.backgroundColor = .white
        view.addSubview(stackView)
        setupViewController()
        imageOfUserView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageOfUserView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
    }
    private func setupViewController() {
        NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                ])
    }
        
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSoource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
                case 0:  let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCellWithXib.self), for: indexPath) as! CustomCellWithXib
            cell.configure(with: dataSoource[indexPath.row])
            return cell

        case 1: let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SecondCell.self), for: indexPath) as! SecondCell
                    cell.configure(with: dataSoource[indexPath.row])
                    return cell
        case 2: let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ThirdCell.self), for: indexPath) as! ThirdCell
            cell.configure(with: [UIImage(named: "imageForScroll1")!, UIImage(named: "imageForScroll2")!, UIImage(named: "imageForScroll3")!])
                    return cell
                default: return UITableViewCell()
                }
        
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 260
        }

    
}
