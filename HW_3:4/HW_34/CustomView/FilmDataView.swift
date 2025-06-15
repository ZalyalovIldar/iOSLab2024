//
//  FilmDataView.swift
//  HW_34
//
//  Created by Damir Rakhmatullin on 14.01.25.
//

import UIKit

class FilmDataView: UIView {
    
    private lazy var firstSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .systemGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
        ])
        return separator
    }()
    
    private lazy var secondSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .systemGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
        ])
        return separator
    }()
    
    private lazy var firstView: UIImageView = {
        let calendare = UIImageView(image: UIImage(systemName: "calendar"))
        calendare.tintColor = .systemGray
        calendare.translatesAutoresizingMaskIntoConstraints = false
        return calendare
    }()
    
    private lazy var firstTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: FontConstants.normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var secondView: UIImageView = {
        let clock = UIImageView(image: UIImage(systemName: "clock"))
        clock.tintColor = .systemGray
        clock.translatesAutoresizingMaskIntoConstraints = false
        return clock
    }()
    
    private lazy var secondTitle: UILabel = {
        let clock = UILabel()
        clock.translatesAutoresizingMaskIntoConstraints = false
        clock.textColor = .systemGray
        clock.font = UIFont(name: "Poppins-Regular", size: FontConstants.normal)
        return clock
    }()
    
    private lazy var thirdView: UIImageView = {
        let flag = UIImageView(image: UIImage(systemName: "ticket"))
        flag.tintColor = .systemGray
        flag.translatesAutoresizingMaskIntoConstraints = false
        return flag
    }()
    
    private lazy var thirdTitle: UILabel = {
        let country = UILabel()
        country.font = UIFont(name: "Poppins-Regular", size: FontConstants.normal)
        country.translatesAutoresizingMaskIntoConstraints = false
        country.textColor = .systemGray
        return country
    }()
    
    private lazy var firstDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            firstView,
            firstTitle
        ])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = SpacingConstants.tiny
        return stack
    }()
    
    private lazy var secondDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            secondView,
            secondTitle
        ])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = SpacingConstants.tiny
        return stack
    }()
    
    private lazy var thirdDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            thirdView,
            thirdTitle
        ])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = SpacingConstants.tiny
        return stack
    }()
    
    private lazy var horisontalDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            firstDataStackView,
            firstSeparator,
            secondDataStackView,
            secondSeparator,
            thirdDataStackView
        ])
        stack.axis = .horizontal
        stack.spacing = SpacingConstants.tiny
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var verticalDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            firstDataStackView,
            secondDataStackView,
            thirdDataStackView
        ])
        stack.spacing = SpacingConstants.tiny
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .leading
        return stack
    }()
    
    func setupWithFilm(film: FilmDetail, isVertical: Bool) {
        firstTitle.text = "\(film.year)"
        secondTitle.text = "\(film.runningTime ?? 0) мин."
        thirdTitle.text = "\(film.genres[0].name)"
        
        if isVertical {
            setupVerticalLayout()
        } else {
            setupHorisontalLayout()
        }
    }
    
    func setupWithFavouriteFilm(film: FavouriteFilm, isVertical: Bool) {
        firstTitle.text = "\(film.year)"
        secondTitle.text = "\(film.runningTime) мин."
        thirdTitle.text = "\(film.year)"
        
        if isVertical {
            setupVerticalLayout()
        } else {
            setupHorisontalLayout()
        }
    }
    
    private func setupVerticalLayout() {
        addSubview(verticalDataStackView)
        NSLayoutConstraint.activate([
            verticalDataStackView.topAnchor.constraint(equalTo: self.topAnchor),
            verticalDataStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            verticalDataStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            verticalDataStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func setupHorisontalLayout() {
        addSubview(horisontalDataStackView)
        NSLayoutConstraint.activate([
            horisontalDataStackView.topAnchor.constraint(equalTo: self.topAnchor),
            horisontalDataStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horisontalDataStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horisontalDataStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
