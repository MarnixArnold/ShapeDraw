//
//  SDShapeView+Scale.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

// Scaling: changing the size of the shape horizontally and vertically
extension SDShapeView {
    
    func createScaleXYAnchor() -> UIView {
        // Center anchor for translation
        let scaleAnchorView = createEditingAnchor()
        addSubview(scaleAnchorView)
        let offsetX = shape.path.bounds.width - 12
        let offsetY = shape.path.bounds.height - 12
        scaleAnchorView.center = shape.path.bounds.origin + CGPoint(x: offsetX, y: offsetY)
        scaleAnchorView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.scaleXYAnchorPan(_:))))
        return scaleAnchorView
    }
    
    @objc
    private func scaleXYAnchorPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard isEditing else {
            return
        }
        let translation = panGestureRecognizer.translation(in: self)
        // Transform the path, not the view itself
        let width = shape.path.bounds.width
        let scaleX = (width == 0 ? 1.0 : (width + translation.x) / width)
        let height = shape.path.bounds.height
        let scaleY = (height == 0 ? 1.0 : (height + translation.y) / height)
        
        // Scaling is around the origin, so translate, rotate and translate back again
        let shapeCenter = centerOfShape()
        let transform = CGAffineTransform(translationX: shapeCenter.x, y: shapeCenter.y)
            .scaledBy(x: scaleX, y: scaleY)
            .translatedBy(x: -shapeCenter.x, y: -shapeCenter.y)
        shape.path.apply(transform)
        setNeedsDisplay()
        
        // Scale the view to show the entire path
        frame = CGRect(x: 0,
                       y: 0,
                       width: shape.path.bounds.maxX,
                       height: shape.path.bounds.maxY)
        
        // Move all anchors with the shape
        editingAnchors.forEach { (anchorView) in
            anchorView.center = anchorView.center + translation
        }
        panGestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
        
        if panGestureRecognizer.state == .ended {
            resetEditingAnchors()
        }
    }
}

