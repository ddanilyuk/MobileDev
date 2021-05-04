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
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    private var isSearching = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = movieManager.fetchMovies()
        setupTableView()
        setupSearch()
    }
    
    // MARK: - Setup methods
    
    private func setupTableView() {
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        updateTableView()
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
        
        let data = isSearching ? filteredMovies : movies
        data.forEach { movie in
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
            .on(.showContextMenu) { item -> UIContextMenuConfiguration in
                return UIContextMenuConfiguration(identifier: item.indexPath as NSIndexPath, previewProvider: nil) { _ in
                    
                    var actions: [UIAction] = []
                    let deleteUIAction = UIAction(title: "Delete", image: .trash, attributes: .destructive) { _ in
                        DispatchQueue.main.async {
                            self.deleteMovie(item.item, at: item.indexPath)
                        }
                    }
                    actions.append(deleteUIAction)
                    return UIMenu(children: actions)
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
    }
    
    private func createTargetedPreview(for item: TableRowActionOptions<MovieTableViewCell>) -> UITargetedPreview {
        
        let view = item.cell?.mainView ?? UIView()
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20)
        parameters.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20)
        return UITargetedPreview(view: view, parameters: parameters)
    }
    
    private func createNewMovie(title: String, year: String, type: String) {
        
        let newMovie = Movie(title: title, year: year, type: type)
        let newIndexPath = IndexPath(row: movies.count, section: 0)
        
        let row = createRow(from: newMovie)
        
        movies.append(newMovie)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath], with: .fade)
        tableDirector.sections.first?.append(row: row)
        tableView.endUpdates()
        
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }
    
    private func deleteMovie(_ movie: Movie, at indexPath: IndexPath) {
        
        tableView.beginUpdates()
        tableDirector.sections.first?.delete(rowAt: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        movies.removeAll { $0.title == movie.title }
    }
    
    @IBAction func addMovieAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new movie", message: "", preferredStyle: .alert)
        
        // Text fields
        alert.addTextField { $0.placeholder = "Movie title" }
        alert.addTextField {
            $0.keyboardType = .numberPad
            $0.placeholder = "Year"
        }
        alert.addTextField { $0.placeholder = "Type" }
        
        // Actions
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak alert, weak self] _ in
            
            guard let title = alert?.textFields?[0].text,
                  let year = alert?.textFields?[1].text,
                  let type = alert?.textFields?[2].text else {
                return
            }
            
            guard let intYear = Int(year),
                  (1895...2030).contains(intYear) else {
                
                let alert = UIAlertController(title: "Invalid year", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert, animated: true)
                return
            }
            
            self?.createNewMovie(title: title, year: year, type: type)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension Tab3RootViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let enteredText = searchController.searchBar.text?.lowercased(),
              !enteredText.isEmpty else {
            isSearching = false
            updateTableView()
            return
        }
        
        filteredMovies = movies.filter { $0.title.lowercased().contains(enteredText) }
        filteredMovies.isEmpty ? tableView.addPlaceholder() : tableView.removePlaceholder()
        isSearching = true
        updateTableView()
    }
}

// MARK: - UISearchBarDelegate

extension Tab3RootViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        tableView.removePlaceholder()
        updateTableView()
    }
}
