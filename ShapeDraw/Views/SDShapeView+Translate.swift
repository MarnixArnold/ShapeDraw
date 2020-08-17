//
//  SDShapeView+Translate.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

// Translating: moving the shape horizontally and vertically
extension SDShapeView {
    
    func createTranslationAnchor() -> UIView {
        // Center anchor for translation
        let centerAnchorView = createEditingAnchor()
        addSubview(centerAnchorView)
        let centerX = shape.path.bounds.width * 0.5
        let centerY = shape.path.bounds.height * 0.5
        centerAnchorView.center = shape.path.bounds.origin + CGPoint(x: centerX, y: centerY)
        centerAnchorView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.centerAnchorPan(_:))))
        return centerAnchorView
    }
    
    @objc
    private func centerAnchorPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        guard isEditing else {
            return
        }
        let translation = panGestureRecognizer.translation(in: self)
        // Transform the path, not the view itself
        let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
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

