//
//  SDRoundedRectangleShape.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

class SDRoundedRectangleShape: SDShape {
    
    // TODO: make the corder radius editable by the user
    
    override func createPath(bounds: CGRect) {
        let minDim = min(bounds.size.width, bounds.size.height)
        let cornerRadius = 0.2 * minDim
        path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }
}
