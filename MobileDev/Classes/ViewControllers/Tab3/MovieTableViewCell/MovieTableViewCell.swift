//
//  MovieTableViewCell.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 26.02.2021.
//

import UIKit
import TableKit

final class MovieTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.layer.shadowPath = UIBezierPath(rect: mainView.bounds).cgPath
    }
    
    // MARK: - Setup methdods
    
    private func setupView() {
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.45).cgColor
        posterImageView.layer.addSublayer(layer)
        
        mainView.layer.cornerRadius = 20
        mainView.layer.shadowRadius = 8
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowOpacity = 0.4
        mainView.layer.shadowColor = UIColor.black.cgColor
    }
}

// MARK: - ConfigurableCell

extension MovieTableViewCell: ConfigurableCell {
    
    typealias CellData = Movie
    
    func configure(with model: CellData) {
        
        titleLabel.text = model.title
        yearLabel.text = model.year
        posterImageView.sd_setImage(with: URL(string: model.poster), placeholderImage: UIImage.filmPlaceholder, options: [], completed: nil)
        
        if !model.type.isEmpty && !model.year.isEmpty {
            typeLabel.text = "\(model.type.capitalized)   ·   "
        } else {
            typeLabel.text = model.type.capitalized
        }
    }
}
