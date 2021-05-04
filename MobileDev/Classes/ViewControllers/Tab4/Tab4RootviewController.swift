//
//  Tab4RootviewController.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 03.05.2021.
//

import UIKit

final class Tab4RootviewController: UIViewController {
    
    // MARK: - Typealises
    
    typealias DataSource = UICollectionViewDiffableDataSource<UICollectionView.Section, UIImage>
    typealias Snapshot = NSDiffableDataSourceSnapshot<UICollectionView.Section, UIImage>
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    
    private var dataSource: DataSource!
    private var items: [UIImage] = []
    private let imagePicker = ImagePicker(type: .image)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDataSource()
        
        (0...5).forEach { _ in
            addRandomSolidImage(animated: true)
        }
    }
    
    private func addRandomSolidImage(animated: Bool = true) {
        
        let newImage = UIImage(color: .random(), size: UIScreen.main.bounds.size)
        
        if let newImage = newImage, !items.contains(newImage) {
            
            items.append(newImage)
            apply(animated: animated)
            
            if animated {
                scrollToLastItem()
            }
        }
    }
    
    private func scrollToLastItem(animated: Bool = true) {
        
        collectionView.scrollToItem(at: IndexPath(item: items.count - 1, section: 0),
                                    at: .bottom,
                                    animated: true)
    }
    
    // MARK: - Setup methods
    
    private func setupCollectionView() {
        
        let layout = CustomCompositionalLayout.create()
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    private func setupDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<ImageCell, UIImage> { (cell, _, item) in
            cell.imageView.image = item
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, identifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func apply(animated: Bool = true) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    // MARK: - Image picker
    
    private func addImage() {
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.showMediaPicker(with: .camera)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { [weak self] _ in
            self?.showMediaPicker(with: .photoLibrary)
        }
        
        let closeAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        AlertManager.showAlert(withTitle: "Add image",
                               actions: [cameraAction, photoLibraryAction, closeAction],
                               style: .actionSheet)
    }
    
    private func showMediaPicker(with sourceType: UIImagePickerController.SourceType) {
        
        imagePicker
            .presentInViewController(self, isEditable: true, sourceType: sourceType) { [weak self] result in
                
                switch result {
                case .success(let image, let editedImage, _, let picker):
                    if let editedImage = editedImage {
                        self?.items.append(editedImage)
                    } else {
                        self?.items.append(image)
                    }
                    self?.apply(animated: true)
                    self?.scrollToLastItem()
                    picker.dismiss(animated: true, completion: nil)
                default:
                    return
                }
            }
    }
    
    // MARK: - IBActions
    
    @IBAction func randomColorAction(_ sender: UIButton) {
        
        addRandomSolidImage(animated: true)
    }
    
    @IBAction func addImageAction(_ sender: UIButton) {
        
        addImage()
    }
}
