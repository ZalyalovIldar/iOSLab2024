import Foundation
import UIKit

class Animations {
    
    static func addFilmToFavouriteAnimation(button bookMarkButton: UIButton) {
        // Step 1: Pulse animation
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .autoreverse]) {
            bookMarkButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            // Step 2: Reset size and apply color change
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                bookMarkButton.transform = .identity
                bookMarkButton.tintColor = .systemOrange // Change button tint color
            } completion: { _ in
                // Step 3: Smooth transition to new image
                UIView.transition(with: bookMarkButton, duration: 0.3, options: .transitionFlipFromTop) {
                    bookMarkButton.setImage(.bookmarkDone, for: .normal)
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
