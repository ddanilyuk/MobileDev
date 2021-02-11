//
//  GraphView.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 10.02.2021.
//

import UIKit

final class GraphView: UIView {
    
    // MARK: - Variables
    
    private var units = [Unit(value: 0.3, color: .orange),
                         Unit(value: 0.3, color: .green),
                         Unit(value: 0.4, color: .black)]
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        
        var lastAngle: CGFloat = 0
        
        units.forEach { unit in
            
            let path = UIBezierPath()
            let endAngle: CGFloat = lastAngle + CGFloat(unit.value * 2 * Double.pi)
            let radius = frame.width / 3
            
            path.addArc(withCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                        radius: radius,
                        startAngle: lastAngle,
                        endAngle: endAngle,
                        clockwise: true)
            
            path.lineWidth = radius / 3
            unit.color.setStroke()
            path.stroke()
            
            lastAngle = endAngle
        }
    }
}

// MARK: - DiagramUnit

extension GraphView {
    
    struct Unit {
        
        let value: Double
        let color: UIColor
    }
}
