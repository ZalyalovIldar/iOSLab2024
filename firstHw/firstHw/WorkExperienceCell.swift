import UIKit
class WorkExperienceCell: UITableViewCell {
    let workExperienceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        workExperienceLabel.numberOfLines = 0
        workExperienceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(workExperienceLabel)
        
        NSLayoutConstraint.activate([
            workExperienceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            workExperienceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            workExperienceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            workExperienceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with profile: UserProfile?) {
        workExperienceLabel.text = profile?.workExperience
    }
}
