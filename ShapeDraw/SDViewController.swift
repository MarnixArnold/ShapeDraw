//
//  SDViewController.swift
//  ShapeDraw
//
//  Created by Marnix Arnold on 17/08/2020.
//  Copyright © 2020 Marnix Arnold. All rights reserved.
//

import UIKit

class SDViewController: UIViewController {

    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var shapeTableView: UITableView!
    
    @IBOutlet weak var newShapeButton: UIButton!
    
    var shapeViews: [SDShapeView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeTableView.dataSource = self
        
        canvasView.backgroundColor = UIColor.lightGray

        // Do any additional setup after loading the view.
        let shapes = SDShapeFactory.fillDebugShapes()
        shapes.forEach { (shape) in
            addShape(shape: shape)
        }
    }
    
    @IBAction func didTapNewShapeButton(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "New Shape", preferredStyle: .actionSheet)
        
        let supportedShapes = SDShapeFactory.supportedShapeTypes()
        let defaultWidth: CGFloat = 120
        let defaultHeight: CGFloat = 120
        let defaultRect = CGRect(x: canvasView.center.x - 0.5 * defaultWidth,
                                 y: canvasView.center.y - 0.5 * defaultHeight,
                                 width: defaultWidth,
                                 height: defaultHeight)
        supportedShapes.forEach { (shapeType) in
            let shapeAction = UIAlertAction(title: shapeType.rawValue, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                if let shape = SDShapeFactory.create(as: shapeType, rect: defaultRect) {
                    self.addShape(shape: shape)
                }
            })
            alertController.addAction(shapeAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
        })
        
        alertController.addAction(cancelAction)
        

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func addShape(shape: SDShape) {
        let shapeView = SDShapeView(shape: shape)
        shapeViews.append(shapeView)
        canvasView.addSubview(shapeView)
        shapeTableView.reloadData()
    }
}

extension SDViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shapeViews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = shapeViews[indexPath.row].shape.name
        
        // Add a switch to control the visibility of the shape
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(true, animated: false)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.didChangeSwitch(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    
    @objc
    private func didChangeSwitch(_ sender : UISwitch!){
        let row = sender.tag
        guard row < shapeViews.count else {
            return
        }
        let view = shapeViews[row]
        view.isHidden = !sender.isOn
    }
}


