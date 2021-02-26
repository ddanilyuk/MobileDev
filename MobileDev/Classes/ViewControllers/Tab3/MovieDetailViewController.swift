//
//  MovieDetailViewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import UIKit
import TableKit

final class MovieDetailViewController: UIViewController {
    
    enum State {
        case compact
        case exapnded
        case landscape
        
        var imageTop: CGFloat {
            switch self {
            case .compact:
                return UIApplication.shared.windows[0].safeAreaInsets.top + 52
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var imageLeading: CGFloat {
            switch self {
            case .compact:
                return 16
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var imageTrailing: CGFloat {
            switch self {
            case .compact:
                return 16
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }


        
        var contentInset: UIEdgeInsets {
            switch self {
            case .compact, .exapnded:
                return UIEdgeInsets(top: 554, left: 0, bottom: 0, right: 0)
            case .landscape:
                return UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
            }
        }
        
        
    }
    
    static func create(with movie: Movie) -> MovieDetailViewController {
        
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as! MovieDetailViewController
        controller.movie = movie
        
        return controller
    }
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView, scrollDelegate: self)
        }
    }
    
    @IBOutlet weak var backButtonView: UIVisualEffectView!
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var imageViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var imageViewTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var labelTrailing: NSLayoutConstraint!
    @IBOutlet weak var labelLeading: NSLayoutConstraint!
    @IBOutlet weak var labelBottom: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    // MARK: - Private properties
    
    private var tableDirector: TableDirector!
    private var movie: Movie!
    
    private var state: State = .compact
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupGestures()
        setupTableView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            backButtonTop.constant = 8
            imageViewTop.constant = 8
            tableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
            
            posterImageView.layer.cornerRadius = 8
            movieTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//            imageViewBottom.constant = 50
//            headerViewHeight.isActive = false
        default:
            backButtonTop.constant = UIApplication.shared.windows[0].safeAreaInsets.top
            tableView.contentInset = UIEdgeInsets(top: 554, left: 0, bottom: 0, right: 0)
            posterImageView.layer.cornerRadius = 0
            movieTitleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)


//            headerViewHeight.isActive = true

        }
    }
    
    // MARK: - Setup methods
    
    private func setupView() {
        
        navigationItem.hidesBackButton = true
        backButtonView.layer.masksToBounds = true
        backButtonTop.constant = UIApplication.shared.windows[0].safeAreaInsets.top
        
        
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
        
        print(movie.getSections())
        movie.getSections().forEach { item in
            
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
        case .landscapeLeft, .landscapeRight:
            return
        default:
            screenWidth = UIScreen.main.bounds.width

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
