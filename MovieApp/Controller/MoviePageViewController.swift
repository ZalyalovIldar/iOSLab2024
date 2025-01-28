import UIKit

class MoviePageViewController: UIPageViewController {
    
    private var pages: [SlideViewController] = []
    private var images: [String] = []
    private var initialPageIndex: Int = 0
    
    func setImages(images: [String]) {
        self.images = images
    }
    
    func setInitialPage(index: Int) {
        self.initialPageIndex = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        for (index, image) in images.enumerated() {
            let filmImageSlideViewController = SlideViewController()
            if index == 0 {
                filmImageSlideViewController.customView.deactivateNavigationButtons()
            } else if index == images.count - 1 {
               filmImageSlideViewController.customView.deactivateNavigationButtons()
            }
            filmImageSlideViewController.customView.setDelegate(self)
            filmImageSlideViewController.customView.setupWithImage(url: image)
            pages.append(filmImageSlideViewController)
        }
        
        if !pages.isEmpty {
            setViewControllers([pages[initialPageIndex]], direction: .forward, animated: true)
        }
    }
}

extension MoviePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let imageSlideViewController = viewController as? SlideViewController,
              let currentPageIndex = pages.firstIndex(of: imageSlideViewController),
              currentPageIndex > 0 else  { return nil }
        
        return pages[currentPageIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let imageSlideViewController = viewController as? SlideViewController,
              let currentPageIndex = pages.firstIndex(of: imageSlideViewController),
              currentPageIndex < pages.count - 1 else { return nil }
        
        return pages[currentPageIndex + 1]
    }
}

extension MoviePageViewController: SlideViewDelegate {
    func nextImage() {
        guard let currentVC = viewControllers?.first as? SlideViewController,
              let currentIndex = pages.firstIndex(of: currentVC),
              currentIndex < pages.count - 1 else { return }
        
        setViewControllers([pages[currentIndex + 1]], direction: .forward, animated: true)
    }
    
    func previousImage() {
        guard let currentVC = viewControllers?.first as? SlideViewController,
              let currentIndex = pages.firstIndex(of: currentVC),
              currentIndex > 0 else { return }
        
        setViewControllers([pages[currentIndex - 1]], direction: .reverse, animated: true)
    }
}
