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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

    lazy var titleLabel: UILabel = {
            let label = UILabel()
        label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 18) // Делаем текст заголовка жирным
            return label
        }()
        
        // Текст "о себе"
        lazy var subTitleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 16) // Обычный шрифт для описания
            label.numberOfLines = 0 // Поддержка многострочного текста
            
            return label
        }()
    func setupData() {
           titleLabel.text = "О себе"
           subTitleLabel.text = "Я разработчик с опытом работы в Swift. Мне нравится создавать приложения и решать сложные задачи." // Пример текста "о себе"
       }
    
    func setupLayout() {
        
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.spacing = 8
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
                   // Заголовок "О себе" располагается в верхнем левом углу
                   titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2), // Отступ сверху
                   titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16), // Отступ слева
                   subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                   
                   
               ])}
}
extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
