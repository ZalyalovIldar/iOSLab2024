//
//  FirstTableViewCell.swift
//  homeWork1
//
//  Created by Данил Забинский on 27.09.2024.
//
import UIKit

class FirstTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleUILabel: UILabel!
    @IBOutlet weak var userFullNameUILabel: UILabel!
    @IBOutlet weak var userAgeUILabel: UILabel!
    @IBOutlet weak var userCurrenCityUILabel: UILabel!
    @IBOutlet weak var userTitleLabelImage: UIImageView!
    @IBOutlet weak var userFullNameImage: UIImageView!
    @IBOutlet weak var userAgeImage: UIImageView!
    @IBOutlet weak var userCurrentCityImage: UIImageView!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUp()
    }
    
    // MARK: Configuration
    func configureWithUser(from user: User) {
        userFullNameUILabel.text = user.fullName
        userAgeUILabel.text = String(user.age) + " лет"
        userCurrenCityUILabel.text = user.currentCity
    }
    
    // MARK: - Selection Handling
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private Methods
    private func setUp() {
        setupAppearance()
        setUpTitleLabelText()
        setUpConstraints()
    }
    
    private func setupAppearance() {
        self.backgroundColor = .systemGray4
        self.layer.cornerRadius = 25
    }
    
    private func setUpTitleLabelText() {
        titleUILabel.text = "О себе"
        titleUILabel.font = .boldSystemFont(ofSize: 22)
        titleUILabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpConstraints() {
        let widthHeightConstant = titleUILabel.bounds.height
        
        setLabelsLengthConstraints()
        
        let userImageLabelStackView = UIStackView(arrangedSubviews: [
            userTitleLabelImage,
            titleUILabel
        ])
        
        let userFullNameLabelStackView = UIStackView(arrangedSubviews: [
            userFullNameImage,
            userFullNameUILabel
        ])
        
        let userAgeLabelStackView = UIStackView(arrangedSubviews: [
            userAgeImage,
            userAgeUILabel
        ])
        
        let userCurrentCityLabelStackView = UIStackView(arrangedSubviews: [
            userCurrentCityImage,
            userCurrenCityUILabel
        ])
        
        let userDataStackView = UIStackView(arrangedSubviews: [
            userFullNameLabelStackView,
            userAgeLabelStackView,
            userCurrentCityLabelStackView
        ])
        
        configurateVStackView(stackView: userDataStackView)
        
        configurateHStackView(stackView: userImageLabelStackView)
        configurateHStackView(stackView: userFullNameLabelStackView)
        configurateHStackView(stackView: userAgeLabelStackView)
        configurateHStackView(stackView: userCurrentCityLabelStackView)
        
        contentView.addSubview(userImageLabelStackView)
        contentView.addSubview(userDataStackView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 115),
            
            userTitleLabelImage.widthAnchor.constraint(equalToConstant: widthHeightConstant),
            userTitleLabelImage.heightAnchor.constraint(equalToConstant: widthHeightConstant),
            
            userAgeImage.widthAnchor.constraint(equalToConstant: widthHeightConstant),
            userAgeImage.heightAnchor.constraint(equalToConstant: widthHeightConstant),
            
            userCurrentCityImage.widthAnchor.constraint(equalToConstant: widthHeightConstant),
            userCurrentCityImage.heightAnchor.constraint(equalToConstant: widthHeightConstant),
            
            userImageLabelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userImageLabelStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            userDataStackView.topAnchor.constraint(equalTo: titleUILabel.bottomAnchor, constant: 5),
            userDataStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
        ])
    }
    
    private func setLabelsLengthConstraints() {
        userFullNameUILabel.numberOfLines = 1
        userAgeUILabel.numberOfLines = 1
        userCurrenCityUILabel.numberOfLines = 1
    }
    
    private func configurateHStackView(stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configurateVStackView(stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
}
