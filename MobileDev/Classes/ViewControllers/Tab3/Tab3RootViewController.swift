//
//  Tab3RootViewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import UIKit
import TableKit

final class Tab3RootViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    
    // MARK: - Private properties
    
    private var tableDirector: TableDirector!
    private var searchController: UISearchController!
    private var movieManager = MoviesManager.shared
    private var currentSearch: String = ""
    private var moviesPagination = Pagination<Movie>() {
        didSet {
            moviesPagination.items.isEmpty ? tableView.addPlaceholder() : tableView.removePlaceholder()
        }
    }
    private var isLoading: Bool = false {
        didSet {
            isLoading ? Loader.show() : Loader.hide()
        }
    }
    
    lazy var spinner: UIActivityIndicatorView = {
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .black
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        
        return spinner
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Setup methods
    
    private func setupTableView() {
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        tableView.tableFooterView = spinner
        
        updateTableView()
        tableView.addPlaceholder()
    }
    
    private func setupSearch() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    // MARK: - Private methods
    
    private func updateTableView() {
        
        tableDirector.clear()
        tableView.separatorStyle = .none
        
        let section = TableSection()
        
        moviesPagination.items.forEach { movie in
            let row = createRow(from: movie)
            section += row
        }
        tableDirector += section
        tableDirector.reload()
    }
    
    private func createRow(from item: Movie) -> TableRow<MovieTableViewCell> {
        
        return TableRow<MovieTableViewCell>(item: item)
            .on(.click) { [weak self] row in
                self?.getMovieDetail(with: row.item.imdbID) { [weak self] movie in
                    let controller = MovieDetailViewController.create(with: movie)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
            .on(.previewForHighlightingContextMenu) { [weak self] item -> UITargetedPreview in
                
                guard let self = self else {
                    return UITargetedPreview(view: UIView())
                }
                return self.createTargetedPreview(for: item)
            }
            .on(.previewForDismissingContextMenu) { [weak self] item -> UITargetedPreview in
                
                guard let self = self else {
                    return UITargetedPreview(view: UIView())
                }
                return self.createTargetedPreview(for: item)
            }
            .on(.willDisplay) { [weak self] options in
                
                guard let self = self,
                      let nextPage = self.moviesPagination.nextPage,
                      options.indexPath.row >= self.moviesPagination.items.count - 1 else {
                    return
                }
                
                self.getNextPage(page: nextPage)
            }
    }
    
    private func createTargetedPreview(for item: TableRowActionOptions<MovieTableViewCell>) -> UITargetedPreview {
        
        let view = item.cell?.mainView ?? UIView()
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20)
        parameters.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20)
        return UITargetedPreview(view: view, parameters: parameters)
    }
}

// MARK: - API

extension Tab3RootViewController {
    
    func getMovies(title: String) {
        
        self.currentSearch = title
        
        isLoading = true
        
        movieManager.getMovies(title: title.lowercased(), page: 1) { [weak self] result in
            
            guard let self = self else {
                return
            }
            self.isLoading = false
            
            switch result {
            case .failure(let error):
                switch error {
                case .customError(.notFound):
                    self.moviesPagination = Pagination<Movie>()
                default:
                    AlertManager.showErrorMessage(with: error.message)
                }
                
            case .success(let pagination):
                self.moviesPagination = pagination
                self.updateTableView()
            }
        }
    }
    
    func getNextPage(page: Int) {
        
        guard !spinner.isAnimating else {
            return
        }
        
        spinner.startAnimating()
        
        movieManager.getMovies(title: currentSearch, page: page) { [weak self] result in
            
            self?.spinner.stopAnimating()
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                switch error {
                case .customError(.notFound):
                    self.moviesPagination = Pagination<Movie>()
                default:
                    AlertManager.showErrorMessage(with: error.message)
                }
                
            case .success(let pagination):
                self.moviesPagination.merge(with: pagination)
                self.updateTableView()
            }
        }
    }
    
    func getMovieDetail(with id: String, completion: ((Movie) -> Void)?) {
        
        Loader.show()
        
        movieManager.getMovieDetail(with: id) { result in
            
            Loader.hide()
            
            switch result {
            case .failure(let error):
                AlertManager.showErrorMessage(with: error.message)
            case .success(let movie):
                completion?(movie)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension Tab3RootViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let enteredText = searchController.searchBar.text,
              !enteredText.isEmpty,
              currentSearch != enteredText,
              enteredText.count > 2 else {
            return
        }
        
        if !isLoading {
            getMovies(title: enteredText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if isLoading {
            searchController.searchBar.text = currentSearch
        }
    }
    
}

// MARK: - UISearchBarDelegate

extension Tab3RootViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        moviesPagination = Pagination<Movie>()
        updateTableView()
    }
}
