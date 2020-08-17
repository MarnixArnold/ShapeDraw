//
//  SDStarShape.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

class SDStarShape: SDShape {
    
    override func createPath(bounds: CGRect) {
        path = UIBezierPath()
        let center = CGPoint(x: bounds.origin.x + bounds.width / 2.0, y: bounds.origin.y + bounds.height / 2.0)
        let xCenter: CGFloat = center.x
        let yCenter: CGFloat = center.y
        let w = bounds.width
        let r = w * 0.5
        let polySide = CGFloat(5)
        let theta = 2.0 * Double.pi * Double(2.0 / polySide)
        path.move(to: CGPoint(x: xCenter, y: -r + yCenter))
        for i in 1..<Int(polySide) {
            let x: CGFloat = r * CGFloat( sin(Double(i) * theta) )
            let y: CGFloat = r * CGFloat( cos(Double(i) * theta) )
            path.addLine(to: CGPoint(x: x + xCenter, y: -y + yCenter))
        }
        path.close()
    }
}
