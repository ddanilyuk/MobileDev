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
    private var movieManager = MoviesManager.shared
    private var movies: [Movie] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = movieManager.fetchMovies()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        updateTableView()
    }
    
    private func updateTableView() {
        
        tableDirector.clear()
        tableView.separatorStyle = .none
        
        let section = TableSection()
        movies.forEach { movie in
            let row = createRow(from: movie)
            section += row
        }
        tableDirector += section
        tableDirector.reload()
    }
    
    private func createRow(from item: Movie) -> TableRow<MovieTableViewCell> {
        
//        let corners: UIRectCorner = CellType.self == ReceivedMessageTableViewCell.self
//            ? [.bottomRight, .topLeft, .topRight]
//            : [.bottomLeft, .topLeft, .topRight]
        
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
                    
                    let deleteUIAction = UIAction(title: "Delete", image: UIImage(), attributes: .destructive) { _ in
//                        deleteAction?()
//                        self.movies.removeAll { $0.title == item.item.title }
                        self.tableView.beginUpdates()
                        self.tableDirector.sections.first?.delete(rowAt: item.indexPath.row)
                        self.tableView.deleteRows(at: [item.indexPath], with: .fade)
                        self.tableView.endUpdates()

                    }
                    actions.append(deleteUIAction)

                    return UIMenu(children: actions)
                }
            }
            .on(.previewForHighlightingContextMenu) { item -> UITargetedPreview in
                
                let view = item.cell?.mainView ?? UIView()
                let parameters = UIPreviewParameters()
                parameters.backgroundColor = .clear
                parameters.visiblePath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20)
                
                return UITargetedPreview(view: view, parameters: parameters)
            }
            .on(.previewForDismissingContextMenu) { item -> UITargetedPreview in
                
                let view = item.cell?.mainView ?? UIView()
                let parameters = UIPreviewParameters()
                parameters.backgroundColor = .clear
                parameters.visiblePath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20)
                
                return UITargetedPreview(view: view, parameters: parameters)
            }
    }
    
    private func createNewMovie(title: String, year: String, type: String) {
        
        let movie = Movie(title: title, year: year, type: type)
//        let newIndexPath = IndexPath(row: movies.count + 1, section: 0)
//        let row = createRow(from: movie)
        
        movies.append(movie)
//        tableView.beginUpdates()
//        tableDirector.sections.first?.append(row: row)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
//        tableView.endUpdates()
        
        updateTableView()
    }
    
    @IBAction func addMovieAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new movie", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Movie title"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Year"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Type"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak alert, weak self] _ in
            
            let title = alert?.textFields?[0].text ?? "Title"
            let year = alert?.textFields?[1].text ?? ""
            let type = alert?.textFields?[2].text ?? ""
            self?.createNewMovie(title: title, year: year, type: type)
        })
        
        present(alert, animated: true)
    }
    
}
