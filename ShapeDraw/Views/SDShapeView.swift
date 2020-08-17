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
    
    private var _editing = false
    var isEditing: Bool {
        get {
            return _editing
        }
        set {
            guard _editing != newValue else {
                return
            }
            _editing = newValue
            showEditingAnchors(enabled: newValue)
        }
    }
    
    private var editingAnchors: [UIView] = []
    
    init(shape: SDShape) {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: shape.path.bounds.maxX,
                           height: shape.path.bounds.maxY)
        super.init(frame: frame)
        self.shape = shape
        self.backgroundColor = UIColor.clear
        setupEditingAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Don't capture any touches on this view itself (only on the editing anchors)
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self { return nil }
        return result
    }
    
    override func draw(_ rect: CGRect) {
        shape.strokeColor.setStroke()
        shape.path.stroke()
            
        shape.fillColor.setFill()
        shape.path.fill()
    }
}

// Editing
extension SDShapeView {
    private func setupEditingAnchors() {
        let centerAnchor = createTranslationAnchor()
        editingAnchors.append(centerAnchor)

        showEditingAnchors(enabled: false)
    }
    
    private func showEditingAnchors(enabled: Bool) {
        editingAnchors.forEach { (view) in
            view.isHidden = !enabled
        }
    }
    
    func createEditingAnchor() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        return view
    }
    
}

