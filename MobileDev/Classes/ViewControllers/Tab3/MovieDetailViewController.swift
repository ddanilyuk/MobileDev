//
//  MovieDetailViewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import UIKit
import TableKit

final class MovieDetailViewController: UIViewController {
    
    static func create(with movie: Movie) -> MovieDetailViewController {
        
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as! MovieDetailViewController
        controller.movie = movie
        
        return controller
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView, scrollDelegate: self)
        }
    }
    
    @IBOutlet weak var imageViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var imageViewTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var labelTrailing: NSLayoutConstraint!
    @IBOutlet weak var labelLeading: NSLayoutConstraint!
    @IBOutlet weak var labelBottom: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    // MARK: - Private properties
    
    private var tableDirector: TableDirector!
    private var movie: Movie!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupGestures()
        setupTableView()
    }
    
    // MARK: - Setup methods
    
    private func setupView() {
        
        movieTitleLabel.text = movie.title
        posterImageView.image = movie.posterImage
        
        movieTitleLabel.clipsToBounds = true
        
        tableView.contentInset = UIEdgeInsets(top: 554, left: 0, bottom: 4, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        headerViewHeight.constant = 550
        headerView.layoutIfNeeded()
    }
    
    private func setupGestures() {
        
        let upSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didPan(_:)))
        upSwipeGestureRecognizer.direction = .up
        
        let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didPan(_:)))
        downSwipeGestureRecognizer.direction = .down
        
        headerView.addGestureRecognizer(upSwipeGestureRecognizer)
        headerView.addGestureRecognizer(downSwipeGestureRecognizer)
    }
    
    private func setupTableView() {
        
        tableDirector.clear()
        tableView.separatorStyle = .none
        
        movie.reflex().forEach { fieldRepresentable in
            
            let section = TableSection(headerView: nil, footerView: nil)
            let row = TableRow<FieldTableViewCell>(item: fieldRepresentable)
            
            section += row
            tableDirector += section
        }
        tableDirector.reload()
    }
    
    // MARK: - Actions
    
    @objc private func didPan(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .down:
            tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        case .up:
            tableView.scrollRectToVisible(CGRect(x: 0, y: tableView.frame.height - 276, width: 1, height: 1), animated: true)
        default:
            break
        }
    }
}

// MARK: UIScrollViewDelegate

extension MovieDetailViewController: UIScrollViewDelegate {
    
    func endDecelerating(_ scrollView: UIScrollView) {
        let yOffset = -scrollView.contentOffset.y
        
        guard yOffset > 275 else {
            return
        }
        
        let newOffser = yOffset < 550 - (275 / 2) ? tableView.frame.height - 276 : 0
        tableView.scrollRectToVisible(CGRect(x: 0, y: newOffser, width: 1, height: 1), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        endDecelerating(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        endDecelerating(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = max(-scrollView.contentOffset.y, 275)
        debugPrint("yOffset: ", yOffset)
        
        let statusBarHeight = UIApplication.shared.windows[0].safeAreaInsets.top
        let screenWidth = UIScreen.main.bounds.width
        let persent = abs(min(((yOffset - 275) / 275), 1) - 1)
        
        labelLeading.constant = max(150 * persent, 0)
        labelTrailing.constant = 8 * persent
        labelBottom.constant = ((275 - statusBarHeight - 100 - 8) / 2) * persent
        movieTitleLabel.layer.cornerRadius = 10 * persent
        
        imageViewBottom.constant = (100 - (persent * 100)) + (8 * persent)
        imageViewTrailing.constant = (screenWidth - 142.0) * persent
        imageViewLeading.constant = 8 * persent
        imageViewTop.constant = statusBarHeight * persent + 8 * persent
        posterImageView.layer.cornerRadius = 10 * persent
        
        headerViewHeight.constant = yOffset + 4
        headerView.layoutIfNeeded()
    }
}
