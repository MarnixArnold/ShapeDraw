//
//  SDShape.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

class SDShape {

    var name: String = "Shape"
    var path: UIBezierPath!
    var fillColor: UIColor = UIColor.blue
    var strokeColor: UIColor = UIColor.darkGray
    
    init(rect: CGRect) {
        createPath(bounds: rect)
    }
    
    func createPath(bounds: CGRect) {
        fatalError("Subclass must override this method")
    }
}
