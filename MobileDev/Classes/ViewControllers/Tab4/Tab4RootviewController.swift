//
//  Tab4RootviewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 03.05.2021.
//

import UIKit

final class Tab4RootviewController: UIViewController {
    
    // MARK: - Typealises
    
    typealias DataSource = UICollectionViewDiffableDataSource<UICollectionView.Section, PixabayImage>
    typealias Snapshot = NSDiffableDataSourceSnapshot<UICollectionView.Section, PixabayImage>
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    
    private var dataSource: DataSource!
    private var paginationImages: PixabayPagination<PixabayImage> = PixabayPagination<PixabayImage>()
    private let imagePicker = ImagePicker(type: .image)
    private let pixabayAPIClient: PixabayAPIClientable = PixabayAPIClient.shared
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
        
        setupCollectionView()
        setupDataSource()
        getImages()
    }
    
    // MARK: - Setup methods
    
    private func setupCollectionView() {
        
        let layout = CustomCompositionalLayout.create()
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.delegate = self
    }
    
    private func setupDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<ImageCell, PixabayImage> { (cell, _, item) in
            cell.imageView.sd_setImage(with: URL(string: item.imageURL), placeholderImage: UIImage.imagePlaceholder, options: [], context: nil)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, identifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func apply(animated: Bool = true) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(paginationImages.items)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - UICollectionViewDelegate

extension Tab4RootviewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard indexPath.row >= collectionView.numberOfItems(inSection: 0) - 1,
              let nextPage = paginationImages.nextPage else {
            return
        }
        
        getNextPage(page: nextPage)
    }
}

// MARK: - API

extension Tab4RootviewController {
    
    func getImages() {
        
        Loader.show()
        
        pixabayAPIClient.getImages(page: 1) { result in
            
            Loader.hide()
            
            switch result {
            case .failure(let error):
                AlertManager.showErrorMessage(with: error.message)
            case .success(let pixabayPagination):
                
                self.paginationImages = pixabayPagination
                self.apply(animated: true)
            }
        }
    }
    
    func getNextPage(page: Int) {
        
        // TODO: Change loader
        Loader.show()
        
        pixabayAPIClient.getImages(page: page) { result in
            
            Loader.hide()
            
            switch result {
            case .failure(let error):
                AlertManager.showErrorMessage(with: error.message)
            case .success(let pixabayPagination):
                
                self.paginationImages.merge(with: pixabayPagination)
                self.apply(animated: true)
            }
        }
    }
}
