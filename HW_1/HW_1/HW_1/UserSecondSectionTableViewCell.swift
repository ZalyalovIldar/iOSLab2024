//
//  UserTableViewCell.swift
//  HW_1
//
//  Created by Артур Мавликаев on 02.10.2024.
//

import UIKit

class UserSecondSectionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }

    private lazy var titleLabel: UILabel = {
            let label = UILabel()
        label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 22)
            return label
        }()
        
        
    private lazy var subTitleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 20)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
    func setupData() {
           titleLabel.text = "Опыт Работы"
        subTitleLabel.text = """
        Стажер iOS-разработчик, ABC Technologies
        Июнь 2023 - Сентябрь 2023

        iOS-разработчик (фриланс)
        Приложение для планирования задач
        Январь 2024 - Март 2024

        iOS-разработчик, Хакатон XYZ
        Ноябрь 2023

        Веб-разработчик, Web Solutions Inc.
        Январь 2023 - Май 2023.
        """

       }
    
    func setupLayout() {
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

}
extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
