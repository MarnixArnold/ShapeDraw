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
    
    var shapes: [SDShape] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        fillDebugShapes()
        drawDebugShapes()
    }

    func fillDebugShapes() {
        let debugShape1 = SDRectangleShape(rect: CGRect(x: 100, y: 100, width: 300, height: 300))
        debugShape1.fillColor = UIColor.orange
        debugShape1.name = "Rect 1"
        let debugShape2 = SDOvalShape(rect: CGRect(x: 80, y: 70, width: 250, height: 500))
        debugShape2.fillColor = UIColor.blue
        debugShape2.name = "Oval 1"
        
        shapes = [debugShape1, debugShape2]
    }
    
    func drawDebugShapes() {
        
        canvasView.backgroundColor = UIColor.lightGray
        canvasView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        
        shapes.forEach { (shape) in
            let shapeView = SDShapeView(shape: shape)
            canvasView.addSubview(shapeView)
        }
    }

}

extension SDViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shapes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = shapes[indexPath.row].name
        return cell
    }
    
}


