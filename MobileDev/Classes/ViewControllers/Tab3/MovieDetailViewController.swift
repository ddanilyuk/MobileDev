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
        
        var padding: CGFloat {
            return 8
        }
        
        var imageWidth: CGFloat {
            return 150
        }
        
        var backButtonHeight: CGFloat {
            return 44
        }
        
        var labelHeight: CGFloat {
            return 100
        }
        
        var headerHeight: CGFloat {
            return 550
        }
        
        func imageTop(topInset: CGFloat = UIApplication.shared.windows[0].safeAreaInsets.top) -> CGFloat {
            switch self {
            case .compact:
                return topInset + backButtonHeight + padding
            case .exapnded:
                return 0
            case .landscape:
                return 8
            }
        }
        
        var imageLeading: CGFloat {
            switch self {
            case .compact:
                return padding * 2
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        func imageTrailing(screenWidth: CGFloat = UIScreen.main.bounds.width) -> CGFloat {
            switch self {
            case .compact:
                return screenWidth - imageWidth + padding
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var imageBottom: CGFloat {
            switch self {
            case .compact:
                return padding
            case .exapnded:
                return labelHeight
            case .landscape:
                return labelHeight

            }
        }
        
        var labelLeading: CGFloat {
            switch self {
            case .compact:
                return imageWidth
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var labelTrailing: CGFloat {
            switch self {
            case .compact:
                return padding
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }
        
        var labelBottom: CGFloat {
            switch self {
            case .compact:
                return (headerHeight / 2 - imageTop() - labelHeight) / 2
            case .exapnded:
                return 0
            case .landscape:
                return 0
            }
        }

        var labelFont: UIFont {
            
            switch self {
            case .compact:
                return UIFont.systemFont(ofSize: 27, weight: .semibold)
            case .exapnded:
                return UIFont.systemFont(ofSize: 27, weight: .semibold)
            case .landscape:
                return UIFont.systemFont(ofSize: 18, weight: .semibold)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
//        print(coordinator.)
        print("viewWillTransition")
        print(size)
        print(UIApplication.shared.windows[0].safeAreaInsets)
        // TODO: Change to ternary
        
        var topInset: CGFloat = 0
        var screenWidth: CGFloat = 0
        
        if UIDevice.current.orientation.isLandscape {
            state = .landscape
            backButtonTop.constant = 8
            
            topInset = UIApplication.shared.windows[0].safeAreaInsets.left
            screenWidth = size.width
        } else {
            state = .exapnded
            backButtonTop.constant = UIApplication.shared.windows[0].safeAreaInsets.left
            
            topInset = UIApplication.shared.windows[0].safeAreaInsets.top
            screenWidth = size.width
        }
        setState(state, topInset:  topInset, screenWidth: screenWidth)
        
        let path = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: path, at: .top, animated: true)
//        let newOffser = state == .exapnded ? tableView.frame.height - 276 : 0
//        print(newOffser)
//        tableView.scrollRectToVisible(CGRect(x: 0, y: newOffser, width: 1, height: 1), animated: true)
    }
        
    
    // MARK: - Setup methods
    
    private func setupView() {
        
        navigationItem.hidesBackButton = true
        backButtonView.layer.masksToBounds = true
        backButtonTop.constant = UIApplication.shared.windows[0].safeAreaInsets.top
//        movieTitleLabel.clipsToBounds = true

        movieTitleLabel.text = movie.title
        posterImageView.image = movie.posterImage
        

        
        if UIDevice.current.orientation.isLandscape {
            state = .landscape
            backButtonTop.constant = 8
            
        } else {
            state = .exapnded
            backButtonTop.constant = UIApplication.shared.windows[0].safeAreaInsets.top
        }
        
        
        setState(state)
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
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setState(_ state: State,
                          topInset: CGFloat = UIApplication.shared.windows[0].safeAreaInsets.top,
                          screenWidth: CGFloat = UIScreen.main.bounds.width) {
        
        labelLeading.constant = state.labelLeading
        labelTrailing.constant = state.labelTrailing
        labelBottom.constant = state.labelBottom
        
        imageViewBottom.constant = state.imageBottom
        imageViewTrailing.constant = state.imageTrailing(screenWidth: screenWidth)
        imageViewLeading.constant = state.imageLeading
        imageViewTop.constant = state.imageTop(topInset: topInset)
        
        posterImageView.layer.cornerRadius = state.cornerRadius
        movieTitleLabel.font = state.labelFont
        tableView.contentInset = state.contentInset
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        headerViewHeight.constant = state.headerHeight
        headerView.layoutIfNeeded()
        
//        let newOffser = state == .exapnded ? tableView.frame.height - 276 : 0
//        print(newOffser)
//        tableView.scrollRectToVisible(CGRect(x: 0, y: newOffser, width: 1, height: 1), animated: true)
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
        
        guard state != .landscape else {
            return
        }
        
        let yOffset = max(-scrollView.contentOffset.y, 275)
        
        debugPrint("yOffset: ", yOffset)

        let compactState: State = .compact
        let expandState: State = .exapnded
        
        let persent = abs(min(((yOffset - 275) / 275), 1) - 1)
//        let padding = 8 * persent

        labelLeading.constant = compactState.labelLeading * persent
        labelTrailing.constant = compactState.labelTrailing * persent
        labelBottom.constant = compactState.labelBottom * persent
        
        imageViewBottom.constant = expandState.imageBottom - (expandState.imageBottom * persent) + compactState.imageBottom
        imageViewTrailing.constant = compactState.imageTrailing() * persent
        imageViewLeading.constant = compactState.imageLeading * persent
        imageViewTop.constant = compactState.imageTop() * persent
        posterImageView.layer.cornerRadius = compactState.cornerRadius * persent
        
        headerViewHeight.constant = yOffset
        headerView.layoutIfNeeded()
    }
}
