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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearch()
    }
    
    // MARK: - Setup methods
    
    private func setupTableView() {
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
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
                guard let movie = self?.movieManager.getMovie(with: row.item.imdbID) else {
                    return
                }
                let controller = MovieDetailViewController.create(with: movie)
                self?.navigationController?.pushViewController(controller, animated: true)
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
                
                self.getMovies(title: self.currentSearch, page: nextPage)
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
    
    func getMovies(title: String,  page: Int = 1) {
        
        Loader.show()
        
        movieManager.getMovies(title: title, page: page) { [weak self] result in
            
            Loader.hide()
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .failure(let error):
                AlertManager.showErrorMessage(with: error.message)
            case .success(let pagination):
                
                if page == 1 {
                    self.moviesPagination = pagination
                } else {
                    self.moviesPagination.merge(with: pagination)
                }
                self.updateTableView()
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension Tab3RootViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let enteredText = searchController.searchBar.text?.lowercased(),
              !enteredText.isEmpty,
              currentSearch != enteredText,
              enteredText.count > 2 else {
            return
        }
        
        currentSearch = enteredText
        getMovies(title: enteredText, page: 1)
    }
}

// MARK: - UISearchBarDelegate

extension Tab3RootViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        moviesPagination = Pagination<Movie>()
        updateTableView()
    }
}
