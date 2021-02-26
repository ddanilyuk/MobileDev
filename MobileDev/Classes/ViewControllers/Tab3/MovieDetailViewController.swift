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
    
    @IBOutlet weak var backButtonView: UIVisualEffectView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView, scrollDelegate: self)
        }
    }
    
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
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
        
        navigationItem.hidesBackButton = true
        setupView()
        setupGestures()
        setupTableView()
        backButtonView.layer.masksToBounds = true
        
        backButtonTop.constant = UIApplication.shared.windows[0].safeAreaInsets.top
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
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
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        
        print(movie.reflex3())
        movie.reflex3().forEach { item in
            
            let header = MovieDetailSectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
            header.configure(with: item.section.rawValue)
            
            let section = TableSection(headerView: header, footerView: nil)
            
            item.values.sorted(by: { $0.field < $1.field }) .forEach { field in
                let row = TableRow<FieldTableViewCell>(item: field)
                section += row
            }
            
            tableDirector += section
        }
//        tableDirector.he
        
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
        
        var screenWidth: CGFloat = 0
        
//        print(UIDevice.current.orientation)
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            screenWidth = UIScreen.main.bounds.width
        case .landscapeLeft, .landscapeRight:
            screenWidth = UIScreen.main.bounds.height
        default:
            break
        }
        
        let persent = abs(min(((yOffset - 275) / 275), 1) - 1)
        let padding = 8 * persent
        
        labelLeading.constant = max(150 * persent, 0)
        labelTrailing.constant = padding
        labelBottom.constant = ((275 - statusBarHeight - 100 - 8) / 2) * persent
        movieTitleLabel.layer.cornerRadius = 10 * persent
        
        imageViewBottom.constant = (100 - (persent * 100)) + padding
        imageViewTrailing.constant = (screenWidth - 142.0) * persent
        imageViewLeading.constant = padding * 2
        imageViewTop.constant = (statusBarHeight + 52) * persent
        posterImageView.layer.cornerRadius = 10 * persent
        
        headerViewHeight.constant = yOffset + 4
        headerView.layoutIfNeeded()
    }
}
