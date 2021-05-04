//
//  CustomCompositionalLayout.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 03.05.2021.
//

import UIKit

final class CustomCompositionalLayout: UICollectionViewLayout {
    
    static func create() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // MARK: - Items
            
            let bigItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.67),
                                                   heightDimension: .fractionalWidth(0.67)))
            
            
            let littleItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.33)))
            
            // MARK: - Groups
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                                   heightDimension: .fractionalWidth(0.67)),
                subitem: littleItem, count: 2)
            
            let topHorizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.67)),
                
                subitems: [bigItem, verticalGroup])

            let centerHorizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(0.33)),
                subitem: littleItem, count: 3)
        
            let bottomHorizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.67)),
                
                subitems: [verticalGroup, bigItem])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1.67)),
                
                subitems: [topHorizontalGroup, centerHorizontalGroup, bottomHorizontalGroup])
            
            return NSCollectionLayoutSection(group: nestedGroup)
        }
        
        return layout
    }
}
