import UIKit

class MovieSnapsCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    private weak var viewController: UIViewController?
    private var images = [String]()
    private var pageViewController: MoviePageViewController?
    
    init(withData images: [String], viewController: UIViewController) {
        self.images = images
        self.viewController = viewController
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pageViewController = MoviePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        if let pageViewController {
            pageViewController.setImages(images: self.images)
            pageViewController.setInitialPage(index: indexPath.item)
            pageViewController.modalPresentationStyle = .overCurrentContext
            pageViewController.modalTransitionStyle = .crossDissolve
            viewController?.present(pageViewController, animated: true)
        }
    }
}
