//
//  FilmTableViewCell.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 11.02.2021.
//

import UIKit
import TableKit

final class FilmTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        yearLabel.isHidden = false
        typeLabel.isHidden = false
    }
}

// MARK: - ConfigurableCell

extension FilmTableViewCell: ConfigurableCell {
    
    typealias CellData = Movie
    
    func configure(with model: Movie) {
        
        nameLabel.text = model.title
        posterImageView.image = model.posterImage
        
        if model.year.isEmpty {
            yearLabel.isHidden = true
        } else {
            yearLabel.text = model.year
        }
        
        if model.type.isEmpty {
            typeLabel.isHidden = true
        } else {
            typeLabel.text = model.type
        }
    }
}
