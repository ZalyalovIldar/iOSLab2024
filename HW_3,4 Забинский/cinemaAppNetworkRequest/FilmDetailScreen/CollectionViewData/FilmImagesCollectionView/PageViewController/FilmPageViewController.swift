//
//  FilmPageViewController.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 06.01.2025.
//

import UIKit

class FilmPageViewController: UIPageViewController {
    
    private var pages: [FilmImageSlideViewController] = []
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
            let filmImageSlideViewController = FilmImageSlideViewController()
            if index == 0 {
                filmImageSlideViewController.customView.deactivateBackwardButton()
            } else if index == images.count - 1 {
               filmImageSlideViewController.customView.deactivateForwardButton()
            }
            filmImageSlideViewController.customView.setDelegate(delegate: self)
            filmImageSlideViewController.customView.setupWithImage(imageTitle: image)
            pages.append(filmImageSlideViewController)
        }
        
        if !pages.isEmpty {
            setViewControllers([pages[initialPageIndex]], direction: .forward, animated: true)
        }
    }
}

extension FilmPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let filmImageSlideViewController = viewController as? FilmImageSlideViewController,
              let currentPageIndex = pages.firstIndex(of: filmImageSlideViewController),
              currentPageIndex > 0 else  { return nil }
        
        return pages[currentPageIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let filmImageSlideViewController = viewController as? FilmImageSlideViewController,
              let currentPageIndex = pages.firstIndex(of: filmImageSlideViewController),
              currentPageIndex < pages.count - 1 else { return nil }
        
        return pages[currentPageIndex + 1]
    }
}

extension FilmPageViewController: FilmImageSlideViewDelegate {
    func next() {
        guard let currentVC = viewControllers?.first as? FilmImageSlideViewController,
              let currentIndex = pages.firstIndex(of: currentVC),
              currentIndex < pages.count - 1 else { return }
        
        setViewControllers([pages[currentIndex + 1]], direction: .forward, animated: true)
    }
    
    func prev() {
        guard let currentVC = viewControllers?.first as? FilmImageSlideViewController,
              let currentIndex = pages.firstIndex(of: currentVC),
              currentIndex > 0 else { return }
        
        setViewControllers([pages[currentIndex - 1]], direction: .reverse, animated: true)
    }
}
