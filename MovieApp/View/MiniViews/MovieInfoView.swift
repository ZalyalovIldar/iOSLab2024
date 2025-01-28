//
//  FilmInfoView.swift
//  MovieApp
//
//  Created by Anna on 28.01.2025.
//

import UIKit

class MovieInfoView: UIView {
    
    private lazy var firstVerticalSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = Colors.lighterGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
        ])
        return separator
    }()
    
    private lazy var secondVerticalSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = Colors.lighterGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
        ])
        return separator
    }()
    
    private lazy var calendarView: UIImageView = {
        let calendare = UIImageView(image: UIImage(systemName: "calendar"))
        calendare.tintColor = Colors.lighterGray
        calendare.translatesAutoresizingMaskIntoConstraints = false
        return calendare
    }()
    
    private lazy var calendarTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.lighterGray
        label.font = UIFont(name: "Montserrat-Medium", size: Fonts.small)
        return label
    }()
    
    private lazy var calendarStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            calendarView,
            calendarTitle,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.nothing / 2
        return stack
    }()
    
    private lazy var clockView: UIImageView = {
        let clock = UIImageView(image: UIImage(systemName: "clock"))
        clock.tintColor = Colors.lighterGray
        clock.translatesAutoresizingMaskIntoConstraints = false
        return clock
    }()
    
    private lazy var filmDurationTitle: UILabel = {
        let clock = UILabel()
        clock.translatesAutoresizingMaskIntoConstraints = false
        clock.textColor = Colors.lighterGray
        clock.font = UIFont(name: "Montserrat-Medium", size: Fonts.small)
        return clock
    }()
    
    private lazy var minutesLabel: UILabel = {
        let duration = UILabel()
        duration.text = "Минут"
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.textColor = Colors.lighterGray
        duration.font = UIFont(name: "Montserrat-Medium", size: Fonts.small)
        return duration
    }()
    
    private lazy var fildmDurationStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            clockView,
            filmDurationTitle,
            minutesLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.nothing / 2
        return stack
    }()
    
    private lazy var flagView: UIImageView = {
        let flag = UIImageView(image: UIImage(systemName: "flag"))
        flag.tintColor = Colors.lighterGray
        flag.translatesAutoresizingMaskIntoConstraints = false
        return flag
    }()
    
    private lazy var countryTitle: UILabel = {
        let country = UILabel()
        country.font = .systemFont(ofSize: Fonts.small)
        country.translatesAutoresizingMaskIntoConstraints = false
        country.textColor = Colors.lighterGray
        country.font = UIFont(name: "Montserrat-Medium", size: Fonts.small)
        return country
    }()
    
    private lazy var countryInfoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            flagView,
            countryTitle,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.nothing / 2
        return stack
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            calendarStackView,
            firstVerticalSeparator,
            fildmDurationStackView,
            secondVerticalSeparator,
            countryInfoStackView
        ])
        stack.spacing = Constants.ultraTiny
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithFilm(_ film: FilmWithInfo) {
        calendarTitle.text = "\(film.year)"
        filmDurationTitle.text = "\(film.runningTime ?? 0)"
        countryTitle.text = "\(Array(film.country.split(separator: ", "))[0])"
    }
    
    private func setup() {
        addSubview(dataStackView)
        NSLayoutConstraint.activate([
            dataStackView.topAnchor.constraint(equalTo: self.topAnchor),
            dataStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dataStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dataStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            firstVerticalSeparator.heightAnchor.constraint(equalTo: dataStackView.heightAnchor),
            secondVerticalSeparator.heightAnchor.constraint(equalTo: dataStackView.heightAnchor)
        ])
    }
    
    
}
