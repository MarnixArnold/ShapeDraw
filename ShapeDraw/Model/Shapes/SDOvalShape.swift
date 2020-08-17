//
//  SDOvalShape.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

class SDOvalShape: SDShape {
    
    override func createPath(bounds: CGRect) {
        path = UIBezierPath(ovalIn: bounds)
    }
}
