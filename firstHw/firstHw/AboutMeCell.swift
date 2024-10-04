import UIKit

class AboutMeCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        fullNameLabel.textAlignment = .left
        ageLabel.textAlignment = .left
        cityLabel.textAlignment = .left

        setupConstraints()
    }
    
    private func setupConstraints() {
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            fullNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            ageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ageLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),

            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 8),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    

    func configure(with profile: UserProfile?) {
        fullNameLabel.text = (profile?.fullName)
        ageLabel.text = "Возраст: \(profile?.age ?? 0)"
        cityLabel.text = profile?.city
    }
    

}
