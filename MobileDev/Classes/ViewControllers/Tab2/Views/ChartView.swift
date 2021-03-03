//
//  ChartView.swift
//  MobileDev
//
//  Created by Denys Danyliuk on 10.02.2021.
//

import UIKit

final class ChartView: UIView {
    
    // MARK: - Public preperties
    
    let startPoint: Double = -6.0
    let endPoint: Double = 6.0
    let offset: Double = 20
    let arrowWidth: Double = 6
    let arrowHeight: Double = 10
    
    var width: Double {
        return Double(frame.width)
    }
    
    var height: Double {
        return Double(frame.height)
    }
    
    var equivalentUnit: Double {
        return height / (exp(endPoint) + offset * 2)
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawChart()
        drawLines()
    }
    
    private func drawChart() {
        
        let chartPath = UIBezierPath()
        
        // Stroke
        chartPath.lineWidth = 1.5
        UIColor.red.setStroke()
        
        chartPath.move(to: getYPoint(for: startPoint))
        
        for pointX in stride(from: startPoint, through: endPoint + 0.01, by: 0.1) {
            chartPath.addLine(to: getYPoint(for: pointX))
        }
        chartPath.stroke()
    }
    
    private func drawLines() {
        
        let line = UIBezierPath()
        line.lineWidth = 1.0
        UIColor.label.setStroke()
        
        let xEndPoint = CGPoint(x: width - offset, y: height - offset)
        let yEndPoint = CGPoint(x: width / 2, y: 0)
        
        // Main Ox line
        line.move(to: CGPoint(x: 16, y: height - offset))
        line.addLine(to: xEndPoint)
        
        // Main Oy line
        line.move(to: CGPoint(x: width / 2, y: height))
        line.addLine(to: yEndPoint)
        
        // Arrow X
        line.move(to: CGPoint(x: width - offset - arrowHeight, y: height - offset - arrowWidth))
        line.addLine(to: xEndPoint)
        line.move(to: CGPoint(x: width - offset - arrowHeight, y: height - offset + arrowWidth))
        line.addLine(to: xEndPoint)
        
        // Arrow Y
        line.move(to: CGPoint(x: width / 2 - arrowWidth, y: arrowHeight))
        line.addLine(to: yEndPoint)
        line.move(to: CGPoint(x: width / 2 + arrowWidth, y: arrowHeight))
        line.addLine(to: yEndPoint)
        
        line.stroke()
    }
    
    private func getYPoint(for x: Double) -> CGPoint {
        
        return CGPoint(x: x * equivalentUnit + (width / 2),
                       y: -(exp(x) * equivalentUnit - height + offset))
    }
}
