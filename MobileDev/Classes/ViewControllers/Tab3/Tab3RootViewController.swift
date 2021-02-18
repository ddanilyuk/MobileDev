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
        
        movies = movieManager.fetchMovies(from: "MoviesList")
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.tableFooterView = UIView()
        updateTableView()
    }
    
    private func updateTableView() {
        
        tableDirector.clear()
        
        movies.forEach { movie in
            
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
