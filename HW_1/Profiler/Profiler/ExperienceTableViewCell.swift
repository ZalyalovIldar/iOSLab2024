//
//  ExperienceTableViewCell.swift
//  Profiler
//
//  Created by Тимур Салахиев on 03.10.2024.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {
    
    var user: User = User(avatar: UIImage(named: "avatar")!,
                          fullName: "Salakhiev Timur Airatovich",
                          age: 19,
                          city: "Kazan",
                          workingExperience: 1,
                          photos: [
                             UIImage(named: "photo_1")!,
                             UIImage(named: "photo_2")!,
                             UIImage(named: "photo_3")!,
                             UIImage(named: "photo_4")!
                          ]
                     )
    
    lazy var experienceLabel: UILabel = {
        let label = UILabel()
        let text: String = String(self.user.workingExperience) + " years"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }()
    
    

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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        contentView.addSubview(experienceLabel)
        
        NSLayoutConstraint.activate([
            experienceLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            experienceLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            experienceLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            experienceLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,constant: -16)
        ])
    }

}
