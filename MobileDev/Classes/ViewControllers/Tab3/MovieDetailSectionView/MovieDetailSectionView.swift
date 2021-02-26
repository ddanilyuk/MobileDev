//
//  MovieDetailSectionView.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 26.02.2021.
//

import UIKit

final class MovieDetailSectionView: UIView {
 
    @IBOutlet weak var mainLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        
        fromNib()
    }
    
    func configure(with text: String) {
        
        mainLabel.text = text
    }
}
