//
//  Tab2RootViewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 09.02.2021.
//

import UIKit

final class Tab2RootViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(pageControl.currentPage), y: 0), animated: false)
    }
    
    // MARK: - Setup methods
    
    private func setupView() {
        
        scrollView.delegate = self
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
    }
    
    // MARK: - IBActions
    
    @IBAction func pageControlDidChange(_ sender: UIPageControl) {
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(sender.currentPage), y: 0), animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension Tab2RootViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageIndex = round(Float(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = Int(pageIndex)
    }
}
