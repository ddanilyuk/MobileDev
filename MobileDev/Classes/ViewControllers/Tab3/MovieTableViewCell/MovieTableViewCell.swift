//
//  MovieTableViewCell.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 26.02.2021.
//

import UIKit
import TableKit

final class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - ConfigurableCell

extension MovieTableViewCell: ConfigurableCell {
    
    typealias CellData = Movie
    
    func configure(with model: CellData) {
        
        titleLabel.text = model.title
        yearLabel.text = model.year
        posterImage.image = model.posterImage
        
        if !model.type.isEmpty && !model.year.isEmpty {
            typeLabel.text = "\(model.type.capitalized)   ·   "
        } else {
            typeLabel.text = model.type.capitalized
        }
    }
}
