//
//  SDShape.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

class SDShape {

//    var origin: CGPoint!
    var name: String = "Shape"
    var path: UIBezierPath!
    var fillColor: UIColor = UIColor.blue
    var strokeColor: UIColor = UIColor.darkGray
    
    init(rect: CGRect) {
//        origin = rect.origin
//        let bounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
//        createPath(bounds: bounds)
        createPath(bounds: rect)
    }
    
    func createPath(bounds: CGRect) {
        fatalError("Subclass must override this method")
    }
}
