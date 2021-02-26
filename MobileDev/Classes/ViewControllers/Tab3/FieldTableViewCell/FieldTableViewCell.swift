//
//  FieldTableViewCell.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 19.02.2021.
//

import UIKit
import TableKit

final class FieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        roundedView.layer.cornerRadius = 4
    }
}

// MARK: - ConfigurableCell

extension FieldTableViewCell: ConfigurableCell {
    
    typealias CellData = Movie.FieldRepresenting
    
    func configure(with model: CellData) {
        
        fieldLabel.text = model.field
        valueLabel.text = model.value
    }
}
