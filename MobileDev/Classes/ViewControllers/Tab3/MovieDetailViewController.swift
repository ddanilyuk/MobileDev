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
        
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: MovieDetailViewController.identifier)
        
        return controller as! MovieDetailViewController
    }
    
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
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    //    @IBOutlet weak var visualEffectText: UIVisualEffectView!
    private var tableDirector: TableDirector!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitleLabel.clipsToBounds = true
        
        tableView.contentInset = UIEdgeInsets(top: 550,
                                              left: 0,
                                              bottom: -view.safeAreaInsets.bottom,
                                              right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        viewHeight.constant = 550
        headerView.layoutIfNeeded()
        
        let upSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didPan(_:)))
        upSwipeGestureRecognizer.direction = .up
        
        let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didPan(_:)))
        downSwipeGestureRecognizer.direction = .down
        
        headerView.addGestureRecognizer(upSwipeGestureRecognizer)
        headerView.addGestureRecognizer(downSwipeGestureRecognizer)
        
        setupTableView()
    }
    
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
    
    private func setupTableView() {
        
        tableDirector.clear()
        
        MoviesManager.shared.fetchMovies(from: "MoviesList").forEach { movie in
            
            let section = TableSection(headerView: nil, footerView: nil)
            let row = TableRow<FilmTableViewCell>(item: movie)
                .on(.click) { [weak self] row in
                    let controller = MovieDetailViewController.create(with: row.item)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            
            section += row
            tableDirector += section
        }
        tableDirector.reload()
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let yOffset = -scrollView.contentOffset.y
        
        guard yOffset > 275 else {
            return
        }
        
        let newOffser = yOffset < 550 - (275 / 2) ? tableView.frame.height - 276 : 0
        tableView.scrollRectToVisible(CGRect(x: 0, y: newOffser, width: 1, height: 1), animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let yOffset = -scrollView.contentOffset.y
        
        guard yOffset > 275 else {
            return
        }
        
        let newOffser = yOffset < 550 - (275 / 2) ? tableView.frame.height - 276 : 0
        tableView.scrollRectToVisible(CGRect(x: 0, y: newOffser, width: 1, height: 1), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var yOffset = -scrollView.contentOffset.y
        print("yOffset", yOffset)
        
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        
        if yOffset < 275 {
            yOffset = 275
            navigationController?.navigationBar.tintColor = .accent
        }
        
        navigationController?.navigationBar.tintColor = .white
        
        let persent = abs(min(((yOffset - 275) / 275), 1) - 1)
        
        labelLeading.constant = max(150 * persent, 0)
        labelTrailing.constant = 8 * persent
        labelBottom.constant = ((275 - topPadding - 100 - 8) / 2) * persent
        
        let screenWidth = UIScreen.main.bounds.width
        
        
        imageViewBottom.constant = (100 - (persent * 100)) + (8 * persent)
        imageViewTrailing.constant = (screenWidth - 142.0) * persent
        imageViewLeading.constant = 8 * persent
        
        imageViewTop.constant = topPadding * persent + 8 * persent
        
        posterImageView.layer.cornerRadius = 10 * persent
        movieTitleLabel.layer.cornerRadius = 10 * persent
        
        viewHeight.constant = yOffset
        headerView.layoutIfNeeded()
    }
}
