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
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterImageViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var posterImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var posterImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var posterImageViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieTitleLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var movieTitleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var movieTitleLabelBottom: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView, scrollDelegate: self)
        }
    }
    
    // MARK: - Private properties
    
    private var tableDirector: TableDirector!
    private var movie: Movie!
    private var isRotating = false
    private var layoutState: LayoutState = .compact
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupGestures()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let isNeedToSetLandscape = UIApplication.interfaceOrientation.isLandscape && !layoutState.isLandscape
        let isNeedToSetPortrait = !UIApplication.interfaceOrientation.isLandscape && layoutState.isLandscape
        
        if isNeedToSetLandscape || isNeedToSetPortrait {
            layoutState = isNeedToSetLandscape ? .landscape : .exapnded
            setLayout(with: layoutState)
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        isRotating = true
        
        coordinator.animate { context in
            context.viewController(forKey: UITransitionContextViewControllerKey.from)
        } completion: { [weak self] _ in
            self?.isRotating = false
        }
    }
    
    // MARK: - Setup methods
    
    private func setupView() {
        
        navigationItem.hidesBackButton = true
        backButtonView.layer.masksToBounds = true
        movieTitleLabel.text = movie.title
        posterImageView.sd_setImage(with: URL(string: movie.poster), placeholderImage: UIImage.filmPlaceholder, options: [], completed: nil)
        
        layoutState = UIApplication.interfaceOrientation.isLandscape ? .landscape : .exapnded
        setLayout(with: layoutState)
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
        tableDirector.reload()
    }
    
    // MARK: - Actions
    
    @objc private func didPan(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .down:
            
            tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        case .up:
            
            guard -tableView.contentOffset.y == layoutState.headerHeight else {
                return
            }
            tableView.scrollRectToVisible(CGRect(x: 0,
                                                 y: tableView.frame.height - layoutState.compactHeaderHeight - 1,
                                                 width: 1,
                                                 height: 1), animated: true)
        default:
            break
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setLayout(with state: LayoutState) {
        
        movieTitleLabelLeading.constant = state.movieTitleLabelLeading
        movieTitleLabelTrailing.constant = state.movieTitleLabelTrailing
        movieTitleLabelBottom.constant = state.movieTitleLabelBottom
        
        posterImageViewBottom.constant = state.posterImageViewBottom
        posterImageViewTrailing.constant = state.posterImageViewTrailing
        posterImageViewLeading.constant = state.posterImageViewLeading
        posterImageViewTop.constant = state.posterImageViewTop
        
        posterImageView.layer.cornerRadius = state.cornerRadius
        movieTitleLabel.font = state.movieTitleLabelFont
        tableView.contentInset = state.contentInset
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        backButtonTop.constant = state.backButtonTop
        backButtonLeading.constant = state.backButtonLeading
        
        headerViewHeight.constant = state.headerHeight
        headerView.layoutIfNeeded()
    }
}

// MARK: UIScrollViewDelegate

extension MovieDetailViewController: UIScrollViewDelegate {
    
    func endDecelerating(_ scrollView: UIScrollView) {
        
        let yOffset = -scrollView.contentOffset.y
        
        guard yOffset > layoutState.compactHeaderHeight else {
            return
        }
        
        let newOffser = yOffset < layoutState.headerHeight - (layoutState.compactHeaderHeight / 2)
            ? tableView.frame.height - layoutState.compactHeaderHeight - 1
            : 0
        tableView.scrollRectToVisible(CGRect(x: 0, y: newOffser, width: 1, height: 1), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        endDecelerating(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        endDecelerating(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard layoutState != .landscape, !isRotating else {
            return
        }
        
        let compactState: LayoutState = .compact
        let expandState: LayoutState = .exapnded
        
        let yOffset = max(-scrollView.contentOffset.y, layoutState.compactHeaderHeight)
        let persent = abs(min(((yOffset - layoutState.compactHeaderHeight) / layoutState.compactHeaderHeight), 1) - 1)
        
        movieTitleLabelLeading.constant = compactState.movieTitleLabelLeading * persent
        movieTitleLabelTrailing.constant = compactState.movieTitleLabelTrailing * persent
        movieTitleLabelBottom.constant = compactState.movieTitleLabelBottom * persent
        
        posterImageViewBottom.constant = expandState.posterImageViewBottom - (expandState.posterImageViewBottom * persent) + compactState.posterImageViewBottom
        posterImageViewTrailing.constant = compactState.posterImageViewTrailing * persent
        posterImageViewLeading.constant = compactState.posterImageViewLeading * persent
        posterImageViewTop.constant = compactState.posterImageViewTop * persent
        posterImageView.layer.cornerRadius = compactState.cornerRadius * persent
        
        headerViewHeight.constant = yOffset
        headerView.layoutIfNeeded()
    }
}

// MARK: - LayoutState

extension MovieDetailViewController {
    
    enum LayoutState {
        
        case compact
        case exapnded
        case landscape
        
        var isLandscape: Bool {
            switch self {
            case .compact, .exapnded:
                return false
            default:
                return true
            }
        }
        
        var headerHeight: CGFloat {
            return 550
        }
        
        var compactHeaderHeight: CGFloat {
            return headerHeight / 2
        }
        
        var padding: CGFloat {
            return 8
        }
        
        var imageWidth: CGFloat {
            return 150
        }
        
        var backButtonHeight: CGFloat {
            return 44
        }
        
        var titleLabelHeight: CGFloat {
            return 100
        }
        
        var posterImageViewTop: CGFloat {
            switch self {
            case .compact:
                return UIApplication.shared.windows[0].safeAreaInsets.top + backButtonHeight + padding
            case .exapnded:
                return 0
            case .landscape:
                return 8
            }
        }
        
        var posterImageViewLeading: CGFloat {
            switch self {
            case .compact:
                return padding * 2
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var posterImageViewTrailing: CGFloat {
            switch self {
            case .compact:
                return UIScreen.main.bounds.width - imageWidth + padding
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var posterImageViewBottom: CGFloat {
            switch self {
            case .compact:
                return padding
            case .exapnded:
                return titleLabelHeight
            case .landscape:
                return titleLabelHeight
            }
        }
        
        var movieTitleLabelLeading: CGFloat {
            switch self {
            case .compact:
                return imageWidth
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var movieTitleLabelTrailing: CGFloat {
            switch self {
            case .compact:
                return padding
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var movieTitleLabelBottom: CGFloat {
            switch self {
            case .compact:
                return (headerHeight / 2 - posterImageViewTop - titleLabelHeight) / 2
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var movieTitleLabelFont: UIFont {
            
            switch self {
            case .compact:
                return UIFont.systemFont(ofSize: 27, weight: .semibold)
            case .exapnded:
                return UIFont.systemFont(ofSize: 27, weight: .semibold)
            case .landscape:
                return UIFont.systemFont(ofSize: 18, weight: .semibold)
            }
        }
        
        var backButtonTop: CGFloat {
            switch self {
            case .compact:
                return UIApplication.shared.windows[0].safeAreaInsets.top
            case .exapnded:
                return UIApplication.shared.windows[0].safeAreaInsets.top
            case .landscape:
                return 8
            }
        }
        
        var backButtonLeading: CGFloat {
            switch self {
            case .compact:
                return 16
            case .exapnded:
                return 16
            case .landscape:
                return 0
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .compact:
                return 8
            case .exapnded:
                return 0
            case .landscape:
                return 10
            }
        }
        
        var contentInset: UIEdgeInsets {
            switch self {
            case .compact, .exapnded:
                return UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
            case .landscape:
                return UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
            }
        }
    }
}
