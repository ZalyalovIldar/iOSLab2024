//
//  Animations.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 05.01.2025.
//

import UIKit

class Animations {
    
    static func addFilmToFavouriteAnimation(button bookMarkButton: UIButton) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
            let rotateTransformation = CGAffineTransform(rotationAngle: .pi).scaledBy(x: 1.5, y: 1.5)
            bookMarkButton.transform = rotateTransformation
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                bookMarkButton.transform = .identity
            } completion: { _ in
                UIView.transition(with: bookMarkButton, duration: 0.3, options: .transitionCrossDissolve) {
                    bookMarkButton.setImage(.bookmarkOrange, for: .normal)
                }
            }
        }
    }
    
    static func shake(_ bookMarkButton: UIButton, completion: ((UIButton) -> Void)? = nil) {
        UIView.animate(withDuration: 0.075, delay: 0, options: .curveLinear) {
            let transform = CGAffineTransform(rotationAngle: .pi / 6)
            bookMarkButton.transform = transform
        } completion: { _ in
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveLinear) {
                bookMarkButton.transform = .identity
            } completion: { _ in
                UIView.animate(withDuration: 0.075, delay: 0, options: .curveLinear) {
                    let transform = CGAffineTransform(rotationAngle: .pi / -6)
                    bookMarkButton.transform = transform
                } completion: { _ in
                    UIView.animate(withDuration: 0.075, delay: 0, options: .curveLinear) {
                        bookMarkButton.transform = .identity
                    } completion: { _ in
                        completion?(bookMarkButton)
                    }
                }
            }
        }
    }
}
