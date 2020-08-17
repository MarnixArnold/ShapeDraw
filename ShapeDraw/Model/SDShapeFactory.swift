//
//  SDShapeFactory.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

enum SDShapeType: String {
    case rectangle = "Rectangle"
    case oval = "Oval"
    case roundedRectangle = "Rounded Rect"
}

// TODO: This is a static class for now. Better to use a protocol and dependency injection
class SDShapeFactory {
    
    class func fillDebugShapes() -> [SDShape] {
        let debugShape1 = SDRectangleShape(rect: CGRect(x: 100, y: 100, width: 300, height: 300))
        debugShape1.fillColor = UIColor.orange
        debugShape1.name = "Rect 1"
        createCounter += 1
        
        let debugShape2 = SDOvalShape(rect: CGRect(x: 80, y: 70, width: 250, height: 500))
        debugShape2.fillColor = UIColor.blue
        debugShape2.name = "Oval 2"
        createCounter += 1

        return [debugShape1, debugShape2]
    }
    

    class func supportedShapeTypes() -> [SDShapeType] {
        return [.rectangle, .oval, .roundedRectangle]
    }
    
    private static var createCounter = 0
    
    class func create(as shapeType: SDShapeType, rect: CGRect) -> SDShape? {
        var newShape: SDShape?
        createCounter += 1
        
        switch shapeType {
        case .rectangle:
            newShape = SDRectangleShape(rect: rect)
        case .oval:
            newShape = SDOvalShape(rect: rect)
        case .roundedRectangle:
            newShape = SDRoundedRectangleShape(rect: rect)
        }

        // TODO: Temporary name, allow the user to set this
        newShape?.name = "\(shapeType.rawValue)_\(createCounter)"

        // TODO: random colors, allow the user to set these
        newShape?.fillColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        newShape?.strokeColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        
        return newShape
    }
}
