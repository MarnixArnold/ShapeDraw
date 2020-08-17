//
//  SDShapeView+Rotate.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

// Rotating: moving the shape around its center
extension SDShapeView {
    
    func createRotationAnchor() -> UIView {
        // Halfway between center and top, anchor for rotation
        let rotationAnchorView = createEditingAnchor()
        addSubview(rotationAnchorView)
        rotationAnchorView.center = initialRotationAnchorPosition()
        rotationAnchorView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.rotationAnchorPan(_:))))
        return rotationAnchorView
    }
    
    @objc
    private func rotationAnchorPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard isEditing else {
            return
        }
        let translation = panGestureRecognizer.translation(in: self)
        // Transform the path, not the view itself
        guard let anchorView = panGestureRecognizer.view else {
            return
        }
        let shapeCenter = centerOfShape()
        let fromCenterToAnchor = anchorView.center - shapeCenter
        let originalAngle = fromCenterToAnchor.angle
        // Rotation is around the origin, so translate, rotate and translate back again
        let fromCenterToNewPosition = anchorView.center + translation - shapeCenter
        let newPositionAngle = fromCenterToNewPosition.angle
        let transform = CGAffineTransform(translationX: shapeCenter.x, y: shapeCenter.y)
            .rotated(by: newPositionAngle - originalAngle)
            .translatedBy(x: -shapeCenter.x, y: -shapeCenter.y)
        shape.path.apply(transform)
        setNeedsDisplay()
        
        // Scale the view to show the entire path
        frame = CGRect(x: 0,
                       y: 0,
                       width: shape.path.bounds.maxX,
                       height: shape.path.bounds.maxY)
        
        // Move the anchor with the shape
        if let anchorView = panGestureRecognizer.view {
            anchorView.center = anchorView.center + translation
            if panGestureRecognizer.state == .ended {
                // Snap to new anchor position
                // TODO: constrain the new position instead of this workaround
                anchorView.center = initialRotationAnchorPosition()
            }
        }
        
        panGestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
    }
    
    private func initialRotationAnchorPosition() -> CGPoint {
        let centerX = shape.path.bounds.width * 0.5
        let centerY = shape.path.bounds.height * 0.25
        return shape.path.bounds.origin + CGPoint(x: centerX, y: centerY)
    }
}

