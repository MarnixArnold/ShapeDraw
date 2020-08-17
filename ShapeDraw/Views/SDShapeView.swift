//
//  SDShapeView.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

class SDShapeView: UIView {

    var shape: SDShape!
    
    init(shape: SDShape) {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: shape.path.bounds.maxX,
                           height: shape.path.bounds.maxY)
        super.init(frame: frame)
        self.shape = shape
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        shape.strokeColor.setStroke()
        shape.path.stroke()
            
        shape.fillColor.setFill()
        shape.path.fill()
    }
        
}
